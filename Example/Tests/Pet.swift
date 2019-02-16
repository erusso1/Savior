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
    
    let id: String
    
    let name: String
    
    var ownerId: String?
    
    init(name: String, id: String, ownerId: String? = nil) {
        
        self.id = id
        self.name = name
        self.ownerId = ownerId
    }
}

extension Pet: Storable {
        
    public typealias ManagedType = ManagedPet
        
    public var identifier: String { return id }
}

extension Pet {
    
    public func owner() -> Person? {

        guard let ownerId = self.ownerId else { return nil }
        
        return Person.find(byId: ownerId)
    }
}

extension Pet: CustomDebugStringConvertible {
    
    public var debugDescription: String { return name }
}
