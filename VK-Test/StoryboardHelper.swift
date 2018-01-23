//
//  StoryboardHelper.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

struct StoryboardHelper {
    static func signInScreen() -> UIViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()!
    }
    
    static func newsScreen() -> UIViewController {
        return UIStoryboard(name: "News", bundle: nil).instantiateInitialViewController()!
    }
    
    static func newsDetailScreen() -> UIViewController {
        return UIStoryboard(name: "NewsDetail", bundle: nil).instantiateInitialViewController()!
    }
}
