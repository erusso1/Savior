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
    static func fromStorageObject(_ item: StorageType) throws -> Self
    
    /// A unique identifier used to look up the `StorageManaging`
    var identifier: String { get }
    
    func save() throws
    
    func delete() throws
    
    static func count() throws -> Int
    
    static func query(_ predicateFormat: String?, _ args: Any...) throws -> [Self]
    
    static func query(_ predicate: NSPredicate?) throws -> [Self]
    
    static func query<T: NSObject & StorageObserving>(_ predicateFormat: String?, args: [Any], observer: T, keyPath: ReferenceWritableKeyPath<T, [StorageType]>) throws -> [Self]
    
    static func query<T: NSObject & StorageObserving>(_ predicate: NSPredicate?, observer: T, keyPath: ReferenceWritableKeyPath<T, [StorageType]>) throws -> [Self]

    static func find(byId identifier: String) throws -> Self?
    
    static func deleteAll() throws
}
