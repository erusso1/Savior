//
//  Codable+Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

extension Encodable {
    
    public func json() throws -> [String : Any] {
        
        let jsonData = try JSONEncoder().encode(self)
        
        return try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
    }
}

extension Decodable {
    
    public static func from(json: [String : Any]) throws -> Self {
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        return try JSONDecoder().decode(Self.self, from: data)
    }
}
