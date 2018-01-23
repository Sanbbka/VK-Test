//
//  UserMO.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData

extension UserMO: BaseMO {
    func fill(withObj obj: Any, moc: NSManagedObjectContext) {
        guard let user = obj as? VKProfile else { return }
        
        self.uid = user.id
        self.photo50 = user.photo50
        self.photo100 = user.photo100
        self.lastName = user.lastName
        self.firstName = user.firstName
        self.visibleName = ([user.firstName, user.lastName].flatMap { $0 }).joined(separator: " ")
    }
}
