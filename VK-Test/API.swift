//
//  API.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 07.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData
import Moya

enum ApiError: Error {
    case authError(msg: String)
    case undefinedError(msg: String)
    case networkError
    case none
}

struct APIVKNews {
    static let provider = MoyaProvider<VKapi>()
    static var request: Cancellable?
    
    static func getNews(at indexStart: String, status: @escaping (ApiError)->()) {
        request = provider.request(.getNewsFeed(userToken: AppUser.shared.getToken()!, indexStart: indexStart)) { (event) in
            switch event {
            case .success(let response):
                handle(response, status: status)
            case .failure:
                let error: ApiError = .networkError
                DispatchQueue.main.async {
                    status(error)
                }
            }
        }
    }
    
    static func userLogout() {
        request?.cancel()
    }
}

extension APIVKNews {
    fileprivate static func parseError(from data: Data, _ error: inout ApiError) {
        if let vkErr = try? JSONDecoder().decode(VKErrorResponse.self, from: data) {
            switch vkErr.error.code {
            case 5:
                error = ApiError.authError(msg: vkErr.error.message)
            default:
                error = ApiError.undefinedError(msg: vkErr.error.message)
            }
        } else {
            error = ApiError.undefinedError(msg: "Неизвестная ошибка")
        }
    }
    
    fileprivate static func handle(_ response: (Response), status: @escaping (ApiError)->()) {
        var error: ApiError = .none
        
        let data = response.data
        guard let vkResponse = try? JSONDecoder().decode(VKResponse.self, from: data) else {
            parseError(from: data, &error)
            DispatchQueue.main.async {
                status(error)
            }
            return
        }
        handle(vkResponse, status: status)
    }
    
    fileprivate static func saveVKItems<T: NSManagedObject>(typeMOClass classMO: T.Type, items: [BaseVKItem], moc: NSManagedObjectContext) where T: BaseMO {
        items.forEach { (i) in
            let vkMO: T = T.getOrCreate(with: i.id, moc: moc)
            vkMO.fill(withObj: i, moc: moc)
            
            BDWorker.save(context: moc)
        }
    }
    
    fileprivate static func savePosts(_ items: [BaseVKItem], moc: NSManagedObjectContext) {
        items.forEach { (post) in
            let postMO: PostMO = PostMO.getOrCreate(with: post.id, moc: moc)
            
            postMO.fill(withObj: post, moc: moc)
            BDWorker.save(context: moc)
        }
    }
    
    fileprivate static func handle(_ response: VKResponse, status: @escaping (ApiError)->()) {
        let moc = BDWorker.mocPerThread()
        moc.perform {
            saveVKItems(typeMOClass: GroupMO.self, items: response.response.groups, moc: moc)
            saveVKItems(typeMOClass: UserMO.self, items: response.response.profiles, moc: moc)
            saveVKItems(typeMOClass: PostMO.self, items: response.response.items, moc: moc)
            
            ud_setValue(forKey: .postVKstartFrom, value: response.response.next_from)
            
            DispatchQueue.main.async {
                status(.none)
            }
        }
    }
}
