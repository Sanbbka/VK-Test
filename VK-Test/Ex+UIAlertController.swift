//
//  Ex+UIAlertController.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 22.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

extension UIAlertController {
    func presentIfNoAlertsPresented() {
        guard let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window else {return}
        var presentedController = window?.rootViewController
        var nextController = presentedController?.presentedViewController
        while nextController != nil  {
            presentedController = nextController
            nextController = presentedController?.presentedViewController
        }
        if let _ = presentedController as? UIAlertController {return}
        presentedController?.present(self, animated: true, completion: nil)
    }
}
