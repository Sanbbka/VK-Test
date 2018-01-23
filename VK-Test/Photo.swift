//
//  Photo.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct Photo {
    var id: String
    var ownerId: String
    var link604: String
    var text: String?
    var width: Float
    var height: Float
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
        case link604 = "photo_604"
        case text
        case width
        case height
    }
}

extension Photo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = "\(try container.decode(Int.self, forKey: .id))"
        ownerId = "\(try container.decode(Int.self, forKey: .ownerId))"
        link604 = try container.decode(String.self, forKey: .link604)
        text = try? container.decode(String.self, forKey: .text)
        width = try container.decode(Float.self, forKey: .width)
        height = try container.decode(Float.self, forKey: .height)
    }
}

