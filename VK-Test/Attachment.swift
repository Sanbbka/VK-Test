//
//  Attachment.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct Attachment: Decodable {
    var type: String
    var photo: Photo?
}
