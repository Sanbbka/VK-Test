//
//  AppWireframe.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit
import Kingfisher

class AppWireframe {
    
    static var shared = AppWireframe()
    
    weak var window: UIWindow!
    
    func setRootViewController(for window: UIWindow?, completion: ((Bool)->())?) {
        let bounds = UIScreen.main.bounds
        
        if let w = window {
            self.window = w
        } else if let k = UIApplication.shared.keyWindow {
            self.window = k
        } else {
            self.window = UIWindow(frame: bounds)
            self.window.makeKeyAndVisible()
        }
        
        var newView: UIViewController
        var options: UIViewAnimationOptions
        
        if AppAccess.userState == .logged {
            newView = StoryboardHelper.newsScreen()
            options = .transitionFlipFromLeft
        } else {
            newView = StoryboardHelper.signInScreen()
            options = .transitionFlipFromRight
        }
        
        newView.view.frame = bounds

        UIView.transition(with: self.window, duration: 0.4, options: options, animations: {
            self.window.rootViewController = newView
        }, completion: completion)
    }
    
    func showLoginScreenFromRootViewController() {
        guard var vc = self.window.rootViewController as UIViewController? else { return }
        
        if let pvc = vc.presentedViewController { vc = pvc }
        
        let signInScreen = StoryboardHelper.signInScreen()
        vc.present(signInScreen, animated: true, completion: nil)
    }
    
    /// Пользователь захотел выйти, или текущая сессия стала невалидной, сбрасываем все данные
    func userLogout(completion: ((Bool)->())?) {
        clearCache()
        self.setRootViewController(for: window, completion: completion)
    }
    
    fileprivate func clearCache() {
        MOStore.clearDB()
        VKapi.userLogout()
        AppUser.shared.clearAppUser()
        Consts.UserDefaultsKey.removeAll()
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
    }
}
