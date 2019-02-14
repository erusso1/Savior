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
    
//    func save()
//    
//    func delete()
//    
//    static func count() -> Int
//    
//    static func query<S: Storable>(_ predicateFormat: String?, _ args: Any...) -> [S] where S == StorageType
//    
//    static func query<S: Storable>(_ predicate: NSPredicate?) -> [S] where S == StorageType
//    
//    static func query<S: Storable, T: NSObject & StorageObserving>(_ predicateFormat: String?, args: [Any], observer: T, keyPath: ReferenceWritableKeyPath<T, [StorageType]>) -> [S] where S == StorageType
//    
//    static func query<S: Storable, T: NSObject & StorageObserving>(_ predicate: NSPredicate?, observer: T, keyPath: ReferenceWritableKeyPath<T, [StorageType]>) -> [S] where S == StorageType
//
//    static func find<S: Storable>(byId identifier: String) -> S? where S == StorageType
//    
//    static func values<T>(filteredBy predicateFormat: String?, args: [Any], keyPath: String, type: T.Type) -> [T]
//    
//    static func values<T>(filteredBy predicate: NSPredicate?, keyPath: String, type: T.Type) -> [T]
//    
//    static func deleteAll()
}
