//
//  Extensions.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 08.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import Foundation

extension String {
    public var hex: Int? {
        return Int(self, radix: 16)
    }
    
    public func toURL() -> URL? {
        return URL(string: self)
    }
    
    public func stringBetweenString (_ firstString: String, _ secondString: String) -> String? {
        var str = self.getStringAfter(str: firstString)
        str = str.flatMap { $0.getStringBefore(str: secondString) }
        
        return str
    }
    
    public func getStringBefore(str: String) -> String? {
        guard let range = self.range(of: str) else { return nil }
        return String(self[..<range.lowerBound])
    }
    
    public func getStringAfter(str: String) -> String? {
        guard let range = self.range(of: str) else { return nil }
        return String(self[range.upperBound...])
    }
}
