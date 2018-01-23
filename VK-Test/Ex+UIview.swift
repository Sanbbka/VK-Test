//
//  Ex+UIview.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 20.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = min(self.bounds.height, self.bounds.width) / 2
    }
}
