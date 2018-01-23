//
//  Ex+TableView.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 20.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(for cellType: BaseCell.Type) {
        self.register(UINib(nibName: cellType.reuseIdentifier, bundle: nil), forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
