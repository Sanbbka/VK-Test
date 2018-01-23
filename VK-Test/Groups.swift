//
//  Groups.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct VKGroup: BaseVKItem {
    var id: String
    var name: String
    var photo50: String
    var photo100: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo_50
        case photo_100
    }
}

extension VKGroup: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = "\(try container.decode(Int64.self, forKey: .id) * (-1))"
        name = try container.decode(String.self, forKey: .name)
        photo50 = try container.decode(String.self, forKey: .photo_50)
        photo100 = try container.decode(String.self, forKey: .photo_100)
    }
}
