//
//  ManagedPet.swift
//  SwiftyStorage_Example
//
//  Created by Ephraim Russo on 11/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift
import Savior

@objcMembers public final class ManagedPet: BaseManagedObject {
    
    public dynamic var name: String = ""
    
    public dynamic var ownerId: String = ""
    
    convenience init(name: String, identifier: String, ownerId: String?) {
        
        self.init()
        self.name = name
        self.identifier = identifier
        self.ownerId = ownerId ?? ""
    }
}

extension ManagedPet: RealmStorageManaging {
    
    public func storageObject() -> Pet {
        
        return Pet(name: self.name, id: self.identifier, ownerId: self.ownerId)
    }
    
    public static func fromStorageObject(_ item: Pet) -> ManagedPet {
        
        return ManagedPet(name: item.name, identifier: String(item.identifier), ownerId: item.ownerId == nil ? "" : String(item.ownerId!))
    }
    
    public typealias StorageType = Pet
}
