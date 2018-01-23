//
//  Alerts.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 22.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

func requestConfirmActionOfUser(with text: String, response: @escaping (_ isConfirm: Bool)->()) {
    let alertController = UIAlertController(title: nil, message: text, preferredStyle: UIAlertControllerStyle.alert)
    
    let confirmButton = UIAlertAction(title: "OK", style: .default) { (alertAction: UIAlertAction) -> Void in
        response(true)
    }
    
    let cancelButton = UIAlertAction(title: "Отмена", style: .cancel) { (alertAction: UIAlertAction) -> Void in
        response(false)
    }
    
    alertController.addAction(cancelButton)
    alertController.addAction(confirmButton)
    alertController.presentIfNoAlertsPresented()
}

