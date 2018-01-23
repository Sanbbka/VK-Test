//
//  BaseCell.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 20.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    static var reuseIdentifier: String {
        return self.className
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
