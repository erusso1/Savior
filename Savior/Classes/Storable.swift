
import Foundation

public protocol Storable: Codable {
    
    /// The associated `StorageManaging` type used facilite storage.
    associatedtype ManagedType: StorageManaging
    
    /// The associated `Hashable` identifier type used for the `identifier` property.
    associatedtype IdentifierType: LosslessStringConvertible
    
    /// Returns an instance of the managed item used to facilite storage.
    /// Must be an item of type `ManagedType`.
    func managedObject() throws -> ManagedType
    
    /// Returns a new instsance of the `Storable` using the given `ManagedType` item.
    static func fromManagedObject(_ item: ManagedType) -> Self
    
    /// A unique identifier used to look up the `Storable`
    var identifier: IdentifierType { get }
    
    /// Saves the `Storable` to storage.
    func save() throws
    
    /// Deletes the `Storable` from storage.
    func delete() throws
    
    /// Obtains the total number of items of this type that
    /// are in storage.
    static func count() throws -> Int
    
    /// Queries the `Storable` for items that have been persisted. Passing `nil`
    /// for the `predicate` argument returns all items in storage. The `observer`
    /// argument may be used to receive notification when items within the returned
    /// collection have additions, removals, and updates.
    static func query(_ predicate: String?) throws -> [Self]
    
    static func query<T: NSObject & StorageObserving>(_ predicate: String?, observer: T, keyPath: ReferenceWritableKeyPath<T, [Self]>) throws -> [Self]
    
    /// Finds the `Storable` with the given `identifier` in storage, if it exists.
    static func find(byId identifier: IdentifierType) throws -> Self?
    
    /// Deletes all items of this type in storage.
    static func deleteAll() throws
}

extension Storable where Self == ManagedType.StorageType {
    
    public func managedObject() throws -> ManagedType {
    
        return try ManagedType.fromStorageObject(self)
    }
    
    public static func fromManagedObject(_ item: ManagedType) -> Self {
        
        return item.storageObject()
    }
}

extension Storable {
    
    public static func count() throws -> Int  { return try ManagedType.count() }
    
    public func save() throws { try managedObject().save() }
    
    public func delete() throws { try managedObject().delete() }
    
    public static func query(_ predicate: String? = nil) throws -> [Self] {
        
        let managedObjects = try ManagedType.query(predicate)
        return managedObjects.map { Self.fromManagedObject($0) }
    }
    
    public static func query<T: NSObject & StorageObserving>(_ predicate: String?, observer: T, keyPath: ReferenceWritableKeyPath<T, [ManagedType.StorageType]>) throws -> [Self] {

        let managedObjects = try ManagedType.query(predicate, observer: observer, keyPath: keyPath)
        return managedObjects.map { Self.fromManagedObject($0) }
    }
    
    public static func find(byId identifier: IdentifierType) throws -> Self? {
        
        guard let item = try ManagedType.find(byId: String(identifier)) else { return nil }
        return Self.fromManagedObject(item)
    }
    
    public static func deleteAll() throws { try ManagedType.deleteAll() }
}
