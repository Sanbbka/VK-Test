//
//  VKError.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 14.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

struct VKErrorResponse: Decodable {
    var error: VKError
}

struct VKError {
    var code: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case error_code
        case error_msg
    }
}

extension VKError: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(Int.self, forKey: .error_code)
        message = try container.decode(String.self, forKey: .error_msg)
    }
}
