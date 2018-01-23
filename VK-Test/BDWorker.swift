//
//  Created by Alexander Drovnyashin on 12.04.17.
//  Copyright © 2017 Bars Group. All rights reserved.
//

import Foundation
import CoreData

import Foundation
import CoreData

extension NSObject {
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

class BDWorker {
    
    let bgProcessBDWorkingQueue: DispatchQueue = DispatchQueue(label: "BDWorker.processBDWorkingQueue", attributes: .concurrent)
    var psc: NSPersistentStoreCoordinator!
    var _daddyManagedObjectContext: NSManagedObjectContext!
    var _defaultManagedObjectContext: NSManagedObjectContext!
    var isReady: Bool = false
    
    static let sharedInstance: BDWorker = BDWorker()
    
    private init() {
    }
    
    func initBD(with block:@escaping (Bool)->()) -> () {
        
        if self.isReady {
            block(true)
            return
        }
        
        let applicationDocumentsDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        // Создание NSManagedObjectModel
        let managedObjectModel: NSManagedObjectModel = {
            let modelURL = Bundle.main.url(forResource: "VK_Test", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        
        let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            let url = applicationDocumentsDirectory.appendingPathComponent("VK_Test.sqlite")
            
            var retryCount = 0
            
            var succes = false
            
            repeat {
                do {
                    let options = [NSMigratePersistentStoresAutomaticallyOption : 1, NSInferMappingModelAutomaticallyOption : 1]
                    try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
                    
                    succes = true
                } catch {
                    if retryCount > 1 {
                        abort()
                    }
                    
                    retryCount += 1
                    do {
                        try FileManager.default.removeItem(at: url)
                    } catch {
                    }
                }
            } while !succes
            
            return coordinator
        }()
        
        // Создаем NSPersistentStoreCoordinator
        self.psc = persistentStoreCoordinator
        
        
        // Создание контекстов
        // _daddyManagedObjectContext является настоящим отцом всех дочерних контекстов юзер кода, он приватен.
        
        self._daddyManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self._daddyManagedObjectContext.persistentStoreCoordinator = self.psc
        self._daddyManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Далее инициализируем main-thread context, он будет доступен пользователям
        self._defaultManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // Добавляем наш приватный контекст отцом, чтобы дочка смогла пушить все изменения
        self._defaultManagedObjectContext.parent = self._daddyManagedObjectContext
        self._defaultManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.isReady = true
        block(true)
    }
    
    static func mocMain()->NSManagedObjectContext {
        return BDWorker.sharedInstance._defaultManagedObjectContext
    }
    static func mocPerThread()->NSManagedObjectContext {
        
        let _self = BDWorker.sharedInstance
        
        while !_self.isReady {
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = _self._defaultManagedObjectContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
    
    static func save(context bgTaskContext: NSManagedObjectContext) {
        guard bgTaskContext.hasChanges else { return }
        
        bgTaskContext.performAndWait {
            do {
                try bgTaskContext.save()
            } catch {
                BDWorker.sayContextError(error: error)
            }
        }
        
        let _self = BDWorker.sharedInstance
        
        //Save default context
        guard _self._defaultManagedObjectContext.hasChanges else { return }
        
        _self._defaultManagedObjectContext.performAndWait {
            do {
                try _self._defaultManagedObjectContext.save()
            } catch {
                BDWorker.sayContextError(error: error)
            }
            
            // А после сохранения _defaultManagedObjectContext необходимо сохранить его родителя, то есть _daddyManagedObjectContext
            _self._daddyManagedObjectContext.performAndWait {
                do {
                    try _self._daddyManagedObjectContext.save()
                } catch {
                    BDWorker.sayContextError(error: error)
                }
            }
        }
    }
    
    static func saveAllContext() {
        let _self = BDWorker.sharedInstance
        
        do {
            guard _self._defaultManagedObjectContext.hasChanges else { return }
            try _self._defaultManagedObjectContext.save()
        } catch {
            BDWorker.sayContextError(error: error)
        }
    }
    
    ///
    
    static func object<T: NSManagedObject>(with entity: String, param: [String: Any]?, sort: [String: Bool]?, offset: Int = 0, limit: Int = 0, MOC context: NSManagedObjectContext) -> [T]? {
        
        var retVal: [T]?
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: context)
            
            fetchRequest.fetchOffset = offset
            fetchRequest.fetchLimit = limit
            
            predicateFor(request: fetchRequest, filters: param)
            
            if let sort = sort {
                var sortDesc = [NSSortDescriptor]()
                
                for s in sort {
                    let sortD = NSSortDescriptor(key: s.key, ascending: s.value)
                    sortDesc.append(sortD)
                }
                fetchRequest.sortDescriptors = sortDesc
            }
            
            do {
                let result = try context.fetch(fetchRequest)

                retVal = result as? [T]
            } catch {
                BDWorker.sayContextError(error: error)
            }
        }
        
        return retVal
    }
    
    static func predicateFor(request: NSFetchRequest<NSFetchRequestResult>, filters: [String: Any]?) {
        guard let
            param = filters,
            param.count > 0 else { return }
        
        var preds = [NSPredicate]()
        
        filters?.forEach({ (key, value) in
            if let arr = value as? [Any] {
                if key.hasSuffix("!") {
                    var key2 = key
                    key2.removeLast()
                    if key2.caseInsensitiveCompare("self") == .orderedSame {
                        preds.append(NSPredicate(format: "NOT (SELF IN %@)", arr))
                    } else {
                        preds.append(NSPredicate(format: "NOT (%K IN %@)", key2, arr))
                    }
                } else {
                    if key.caseInsensitiveCompare("self") == .orderedSame {
                        preds.append(NSPredicate(format: "(SELF IN %@)", arr))
                    } else {
                        preds.append(NSPredicate(format: "(%K IN %@)", key, arr))
                    }
                }
            } else {
                var format = "("
                var par1 = key
                let par2 = value
                
                if par1.uppercased().hasPrefix("ANY ") {
                    let index = par1.index(par1.startIndex, offsetBy: 4)
                    par1 = String(par1[index...])
                    format += "ANY "
                }
                
                format += "%K "
                if par1.hasSuffix(">") {
                    par1.removeLast()
                    format += ">"
                } else if par1.hasSuffix("<") {
                    par1.removeLast()
                    format += "<"
                } else if par1.hasSuffix("!") {
                    par1.removeLast()
                    format += "!="
                } else if par1.hasSuffix(">=") {
                    par1.removeLast()
                    par1.removeLast()
                    format += ">="
                } else if par1.hasSuffix("<=") {
                    par1.removeLast()
                    par1.removeLast()
                    format += "<="
                } else {
                    format += "=="
                }
                format += "%@)"
                
                preds.append(NSPredicate(format: format, par1, par2 as! CVarArg))
            }
        })
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds)
        request.predicate = predicate
    }
    
    static func deleteObjectWith(entity: String, param: [String: Any]?, moc: NSManagedObjectContext) {
        guard let arr = object(with: entity, param: param, sort: nil, offset: 0, limit: 0, MOC: moc) else { return }
        
        arr.forEach { (obj) in
            moc.delete(obj)
        }
        save(context: moc)
    }
    
    static func sayContextError(error: Error) {
        
    }
}

