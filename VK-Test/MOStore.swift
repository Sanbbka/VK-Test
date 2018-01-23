//
//  MOStore.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 17.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData

protocol BaseMO {
    static var className: String { get }
    func fill(withObj obj: Any, moc: NSManagedObjectContext)
}

struct MOStore {
    static func clearDB() {
        let moc = BDWorker.mocPerThread()
        
        moc.perform {
            BDWorker.deleteObjectWith(entity: PhotoMO.className, param: nil, moc: moc)
            BDWorker.deleteObjectWith(entity: PostMO.className, param: nil, moc: moc)
            BDWorker.deleteObjectWith(entity: UserMO.className, param: nil, moc: moc)
            BDWorker.deleteObjectWith(entity: GroupMO.className, param: nil, moc: moc)
            
            BDWorker.save(context: moc)
        }
    }
}

extension NSManagedObject {
    static func createDbDataObject<T: BaseMO>(moc: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.className, into: moc) as! T
    }
    
    static func getOrCreate<T: BaseMO>(with uid: String, moc: NSManagedObjectContext) -> T  {
        if let mo = self.getMO(uid: uid, moc: moc) as? T {
            return mo
        }
        
        return createDbDataObject(moc: moc)
    }
    
    static func getMO(uid: String, moc: NSManagedObjectContext) -> NSManagedObject? {
        let arr = BDWorker.object(with: self.className,
                                  param: ["uid" : uid],
                                  sort: nil,
                                  offset: 0,
                                  limit: 0,
                                  MOC: moc)
        return arr?.first
    }
    
    static func getObjects<T: NSManagedObject>(param:[String: Any]? = nil, sort: [String: Bool]? = nil, offset: Int = 0, limit: Int = 0, complete: @escaping ([T]?)->()) {
        let moc = BDWorker.mocPerThread()
        
        moc.perform {
            let arr = BDWorker.object(with: T.className,
                                      param: param,
                                      sort: sort,
                                      offset: offset,
                                      limit: limit,
                                      MOC: moc) as? [T]
            complete(arr)
        }
    }
}


