//
//  GroupMO.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData

extension GroupMO: BaseMO {
    func fill(withObj obj: Any, moc: NSManagedObjectContext) {
        guard let group = obj as? VKGroup else { return }
        
        self.uid = group.id
        self.name = group.name
        self.visibleName = group.name
        self.photo50 = group.photo50
        self.photo100 = group.photo100
    }
}

