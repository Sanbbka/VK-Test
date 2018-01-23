//
//  Post.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct StatusInfo: Codable {
    var count: Int64
}

struct Post: BaseVKItem {
    var id: String
    var type: String
    var sourceID: String
    var date: TimeInterval
    var text: String?
    var attachments: [Attachment]?
    var comments: StatusInfo
    var likes: StatusInfo

    enum CodingKeys: String, CodingKey {
        case type 
        case source_id
        case date
        case post_id
        case text
        case attachments
        case comments
        case likes
        case views
    }
}

extension Post: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(String.self, forKey: .type)
        sourceID = "\(try container.decode(Int64 .self, forKey: .source_id))"
        date = try container.decode(TimeInterval.self, forKey: .date)
        id = "\(try container.decode(Int64.self, forKey: .post_id))"
        text = try? container.decode(String?.self, forKey: .text) ?? ""
        attachments = try? container.decode([Attachment].self, forKey: .attachments)
        likes = try container.decode(StatusInfo.self, forKey: .likes)
        comments = try container.decode(StatusInfo.self, forKey: .comments)
    }
}
