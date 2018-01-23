//
//  NewsModel.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 18.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit

enum NItemOfPost {
    case info(name: String, date: Date, avatarLink: String)
    case text(String)
    case attachment(NAttachment)
    case state(likes: NLikes, comments: NComments)
}

protocol NLikes {
    var count: Int64 { get }
}

protocol NComments {
    var count: Int64 { get }
}

enum NAttachment {
    case photo(NPhoto)
}

struct NPhoto {
    let link: String
    let size: CGSize
}

