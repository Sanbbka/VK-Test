//
//  NPost.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

struct VKLike: NLikes {
    var count: Int64
}

struct VKComments: NComments {
    var count: Int64
}

struct NPost {
    var uid: String = ""
    var items: [NItemOfPost] = [NItemOfPost]()
    
    init(with objMO: PostMO, isDetail: Bool) {
        self.fill(from: objMO, isDetail)
    }
    
    mutating func fill(from fPost: PostMO, _ isDetail: Bool) {
        self.uid = fPost.uid!
        self.addInfo(from: fPost)
        self.addText(from: fPost)
        if let attachsMO = fPost.attachments?.allObjects,
            attachsMO.count > 0 {
            if isDetail {
                self.addAttachments(from: attachsMO)
            } else {
                self.addAttachments(from: [attachsMO.first!])
            }
        }
        self.addState(from: fPost)
    }
    
    private mutating func addInfo(from fPost: PostMO) {
        guard
            let name = fPost.owner?.visibleName,
            let date = fPost.date,
            let avatar = fPost.owner?.photo50 else {
                return }
        
        self.items.append(NItemOfPost.info(name: name, date: date, avatarLink: avatar))
    }
    
    private mutating func addText(from fPost: PostMO) {
        guard
            let text = fPost.text,
            text.count > 0
            else { return }
        self.items.append(NItemOfPost.text(text))
    }
    
    private mutating func addState(from fPost: PostMO) {
        self.items.append(NItemOfPost.state(likes: VKLike(count: fPost.likesCount),
                                            comments: VKComments(count: fPost.commentsCount)))
    }
    
    private mutating func addAttachments(from fAttachment: [Any]) {
        fAttachment.forEach { (attachMO) in
            if let photo = attachMO as? PhotoMO,
                let link = photo.link604 {
                self.items.append(NItemOfPost.attachment(NAttachment.photo(NPhoto(link: link,
                                                                                  size: CGSize(width:  CGFloat(photo.width), 
                                                                                               height: CGFloat(photo.height) )))))
            }
        }
    }
}
