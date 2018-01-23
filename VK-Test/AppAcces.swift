//
//  AppAcces.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

class AppAccess {
    enum UserState {
        /// Не был авторизован или разлогинился.
        case unlogged
        /// В случае неудачной авторизации или не прошел валидность текущего токена.
        case failure
        /// Авторизован.
        case logged
    }
    
    private static var _userState: UserState = .unlogged
    static var userState: UserState {
        get {
            if AppUser.shared.checkExisting == true {
                AppAccess._userState = .logged
            }
            return AppAccess._userState
        }
        set {
            _userState = newValue
        }
        
    }
}
