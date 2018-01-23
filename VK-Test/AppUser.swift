//
//  AppUser.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

class AppUser {
    static var shared = AppUser()
    
    private var _token: String?

    var checkExisting: Bool {
        let isToken = checkToken()
        return isToken
    }
    
    private func checkToken() -> Bool {
        return getToken() != nil
    }
    
    private func setToken(_ token: String) {
        ud_setValue(forKey: .authVKToken, value: token)
        _token = token
    }
    
    private func clearToken() {
        _token = nil
        ud_removeValue(forKey: .authVKToken)
    }
    
    func getToken() -> String? {
        if _token == nil {
            _token = ud_getValue(forKey: .authVKToken) as? String
        }
        
        return _token
    }
    
    func setAppUser(token: String) {
        setToken(token)
        AppAccess.userState = .logged
    }
    
    func clearAppUser() {
        clearToken()
        AppAccess.userState = .unlogged
    }
}
