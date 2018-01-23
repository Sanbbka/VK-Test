//
//  Constants.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 08.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

let AuthVK: URL = "https://oauth.vk.com/authorize?client_id=6324594&scope=friends,offline,wall&DISPLAY=touch&REDIRECT_URI=http://oauth.vk.com/blank.html&response_type=token".toURL()!

public struct Consts {
    
    public enum UserDefaultsKey: String {
        case authVKToken = "Auth_VK_Token"
        case postVKstartFrom
        
        static func removeAll() {
            ud_removeValue(forKey: .authVKToken)
            ud_removeValue(forKey: .postVKstartFrom)
        }
    }
    
    public enum AppColors {
        static let lightGrayColor: UIColor = UIColor(hexString: "E6E6E6")!
    }
}
