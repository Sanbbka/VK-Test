//
//  UserDefaultsSettingsHelper.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 08.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

public func ud_getValue(forKey key: Consts.UserDefaultsKey) -> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
}

public func ud_setValue(forKey key: Consts.UserDefaultsKey, value: Any?) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
}

public func ud_removeValue(forKey key: Consts.UserDefaultsKey) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
    UserDefaults.standard.synchronize()
}
