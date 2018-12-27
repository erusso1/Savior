//
//  Pet.swift
//  SwiftyStorage_Tests
//
//  Created by Ephraim Russo on 11/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Savior

public final class Pet {
    
    let id: Int64?
    
    let name: String
    
    var ownerId: Int64?
    
    init(name: String, id: Int64? = Int64.random(in: 0..<Int64.max-1), ownerId: Int64? = nil) {
        
        self.id = id
        self.name = name
        self.ownerId = ownerId
    }
}

extension Pet: Storable {
        
    public typealias ManagedType = ManagedPet
        
    public var identifier: Int64 { return id ?? 0 }
}

extension Pet {
    
    public func owner() throws -> Person? {
        
        guard let managedOwner = try managedObject().managedOwner() else { return nil }
        return Person.fromManagedObject(managedOwner) 
    }
}

extension Pet: CustomDebugStringConvertible {
    
    public var debugDescription: String { return name }
}
