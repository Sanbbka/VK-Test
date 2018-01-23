//
//  PostMO.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation
import CoreData

extension PostMO: BaseMO {
    func fill(withObj obj: Any, moc: NSManagedObjectContext) {
        guard let post = obj as? Post else { return }
        
        self.uid = post.id
        self.type = post.type
        self.text = post.text
        self.date = Date(timeIntervalSince1970: post.date)
        self.commentsCount = post.comments.count
        self.likesCount = post.likes.count
        
        if let owner = ProfileMO.getMO(uid: post.sourceID, moc: moc) as? ProfileMO {
            owner.addToPosts(self)
        } else {
            print("")
        }
        
        post.attachments?.forEach({ [unowned self] (attach) in
            if let photo = attach.photo {
                let attachMO: PhotoMO = PhotoMO.getOrCreate(with: photo.id, moc: moc)
                attachMO.fill(withObj: photo, moc: moc)
                self.addToAttachments(attachMO)
            }
        })
    }
}
