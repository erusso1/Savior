//
//  StorageManaging.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public protocol StorageManaging {
    
    associatedtype StorageType: Storable
    
    /// Returns an instance of the originating `Storable` item.
    /// Must be an item of type `StorageType`.
    func storageObject() -> StorageType
    
    /// Returns a new instsance of the `Storable` using the given `ManagedType` item.
    static func fromStorageObject(_ item: StorageType) -> Self
    
    /// A unique identifier used to look up the `StorageManaging`
    var identifier: String { get }
}
