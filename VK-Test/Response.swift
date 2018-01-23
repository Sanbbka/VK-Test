//
//  Response.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct VKResponse: Decodable {
    var response: VKNewsResponse
}

struct VKNewsResponse: Decodable {
    var items: [Post]
    var profiles: [VKProfile]
    var groups: [VKGroup]
    var next_from: String
}

protocol BaseVKItem {
    var id: String { get }
}
