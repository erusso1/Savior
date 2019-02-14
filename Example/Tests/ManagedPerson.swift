//
//  ManagedPerson.swift
//  SwiftyStorage_Tests
//
//  Created by Ephraim Russo on 11/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift
import Savior

@objcMembers public final class ManagedPerson: RealmObject {
    
    public dynamic var name: String = ""
    
    convenience init(name: String, identifier: String) {
        self.init()
        self.name = name
        self.identifier = identifier
    }
}

extension ManagedPerson: RealmStorageManaging {
    
    public func storageObject() -> Person {
        
        return Person(name: self.name, id: self.identifier)
    }
    
    public static func fromStorageObject(_ item: Person) -> ManagedPerson {
        
        return ManagedPerson(name: item.name, identifier: String(item.identifier))
    }
    
    public typealias StorageType = Person
}
