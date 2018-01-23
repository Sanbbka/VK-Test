//
//  VKServices.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 07.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import Moya

let BaseURL = "https://api.vk.com/method"

enum VKapi {
    case getNewsFeed(userToken: String, indexStart: String)
}

extension VKapi {
    static func userLogout() {
        clearCookies()
        APIVKNews.userLogout()
    }
    
    static func clearCookies() {
        let cookieJar = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies {
            for cookie in cookies {
                cookieJar.deleteCookie(cookie)
            }
        }
    }
}

extension VKapi: TargetType {
    var baseURL: URL {
        return URL(string: BaseURL)!
    }
    
    var path: String {
        switch self {
        case .getNewsFeed:
            return "/newsfeed.get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNewsFeed: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getNewsFeed:
            return Task.requestParameters(parameters: self.parameters,
                                          encoding: self.parameterEncoding)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getNewsFeed(let userToken, let indexStart):
            return ["filters":"post",
                    "return_banned":"1",
                    "start_from":indexStart,
                    "count":20,
                    "access_token":userToken,
                    "v":"5.62"]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
