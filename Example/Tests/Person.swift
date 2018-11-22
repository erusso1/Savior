//
//  Person.swift
//  SwiftyStorage_Tests
//
//  Created by Ephraim Russo on 11/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Savior

public final class Person {
    
    let id: Int64?
    
    let name: String
    
    init(name: String, id: Int64? = Int64.random(in: 0..<Int64.max-1)) {
        
        self.id = id
        self.name = name
    }
}

extension Person: Storable {
    
    public typealias ManagedType = ManagedPerson
        
    public var identifier: Int64 { return id ?? 0 }
}

extension Person: CustomDebugStringConvertible {
    
    public var debugDescription: String { return name }
}
