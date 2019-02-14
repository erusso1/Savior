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
    
    let id: String
    
    let name: String
    
    init(name: String, id: String) {
        
        self.id = id
        self.name = name
    }
}

extension Person: Storable {
    
    public typealias ManagedType = ManagedPerson
        
    public var identifier: String { return id }
    
    public convenience init(managedObject: ManagedPerson) {
        self.init(name: managedObject.name, id: managedObject.identifier)
    }
}

extension Person: CustomDebugStringConvertible {
    
    public var debugDescription: String { return name }
}
