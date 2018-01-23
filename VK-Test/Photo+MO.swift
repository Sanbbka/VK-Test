//
//  PhotoMO.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData

extension PhotoMO: BaseMO {
    func fill(withObj obj: Any, moc: NSManagedObjectContext) {
        guard let photo = obj as? Photo else { return }
        
        self.uid = photo.id
        self.text = photo.text
        self.link604 = photo.link604
        self.width = photo.width
        self.height = photo.height
    }
}
