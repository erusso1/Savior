
import Foundation

public protocol Storable: Equatable {
    
    /// The associated `StorageManaging` type used facilite storage.
    associatedtype ManagedType: StorageManaging
    
    /// The associated `Hashable` identifier type used for the `identifier` property.
    associatedtype IdentifierType: LosslessStringConvertible
    
    /// Returns an instance of the managed item used to facilite storage.
    /// Must be an item of type `ManagedType`.
    func managedObject() -> ManagedType
    
    /// Returns a new instsance of the `Storable` using the given `ManagedType` item.
    static func fromManagedObject(_ item: ManagedType) -> Self
    
    init(managedObject: ManagedType)
    
    /// A unique identifier used to look up the `Storable`
    var identifier: IdentifierType { get }
//
//    /// Saves the `Storable` to storage.
//    func save()
//
//    /// Deletes the `Storable` from storage.
//    func delete()
//
//    /// Obtains the total number of items of this type that
//    /// are in storage.
//    static func count() -> Int
//
//    /// Queries the `Storable` for items that have been persisted. Passing `nil`
//    /// for the `predicate` argument returns all items in storage. The `observer`
//    /// argument may be used to receive notification when items within the returned
//    /// collection have additions, removals, and updates.
//    static func query(_ predicateFormat: String?, _ args: Any...) -> [Self]
//
//    static func query(_ predicate: NSPredicate?) -> [Self]
//
//    static func query<T: NSObject & StorageObserving>(_ predicateFormat: String?, args: [Any], observer: T, keyPath: ReferenceWritableKeyPath<T, [Self]>) -> [Self]
//
//    static func query<T: NSObject & StorageObserving>(_ predicate: NSPredicate?, observer: T, keyPath: ReferenceWritableKeyPath<T, [Self]>) throws -> [Self]
//
//    static func query<T: Storable>(_ predicateFormat: String?, args: [Any], joining type: T.Type, foreignKey: String, joinedPredicateFormat: String?, joinedArgs: [Any]) -> [Self] where T.ManagedType.StorageType == T
//
//    static func query<T: Storable>(_ predicate: NSPredicate?, joining type: T.Type, foreignKey: String, joinedPredicate: NSPredicate?) -> [Self] where T.ManagedType.StorageType == T
//
//    /// Queries the `Storable` for all items matching `predicateFormat` and associated predicate `args`, and returns an array of all parameters at the specified `keyPath`. This method attemps to cast the found properties as `[T]`. If the type of the property located at the given `keyPath` cannot be casted to `T`, this method returns an empty array.
//    static func values<T>(filteredBy predicateFormat: String?, args: [Any], keyPath: String, type: T.Type) -> [T]
//
//    /// Queries the `Storable` for all items matching `predicate`, and returns an array of all parameters at the specified `keyPath`. This method attemps to cast the found properties as `[T]`. If the type of the property located at the given `keyPath` cannot be casted to `T`, this method returns an empty array.
//    static func values<T>(filteredBy predicate: NSPredicate?, keyPath: String, type: T.Type) -> [T]
//
//    //static func query<T: Storable, O: NSObject & StorageObserving>(_ predicateFormat: String?, args: [Any], joining type: T.Type, foreignKey: String, joinedPredicateFormat: String?, joinedArgs: [Any],  observer: O, keyPath: ReferenceWritableKeyPath<O, [Self]>) throws -> [Self]
//
//    //static func query<T: Storable, O: NSObject & StorageObserving>(_ predicate: NSPredicate?, joining type: T.Type, foreignKey: String, joinedPredicate: NSPredicate?, observer: O, keyPath: ReferenceWritableKeyPath<O, [Self]>) throws -> [Self]
//
//    /// Finds the `Storable` with the given `identifier` in storage, if it exists.
//    static func find(byId identifier: IdentifierType) -> Self?
//
//    /// Deletes all items of this type in storage.
//    static func deleteAll()
//}

//extension Storable where Self == ManagedType.StorageType {
//
//    public func managedObject() -> ManagedType {
//
//        return ManagedType.fromStorageObject(self)
//    }
//
//    public static func fromManagedObject(_ item: ManagedType) -> Self {
//
//        return item.storageObject()
//    }
//}
//
//extension Storable {
//
//    public static func count() -> Int  { return ManagedType.count() }
//
//    public func save() {
//
//        managedObject().save()
//
//    }
//
//    public func delete() { managedObject().delete() }
//
//    public static func deleteAll() { ManagedType.deleteAll() }
//}
//
//extension Storable where ManagedType.StorageType == Self {
//
//    public static func query(_ predicateFormat: String? = nil, _ args: Any...) -> [Self] {
//
//        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
//        return query(predicate)
//    }
//
//    public static func query(_ predicate: NSPredicate? = nil) -> [Self] {
//
//        return ManagedType.query(predicate)
//    }
//
//    public static func query<T: NSObject & StorageObserving>(_ predicateFormat: String? = nil, args: [Any] = [], observer: T, keyPath: ReferenceWritableKeyPath<T, [ManagedType.StorageType]>) -> [Self] {
//
//        return ManagedType.query(predicateFormat, args: args, observer: observer, keyPath: keyPath)
//    }
//
//    public static func query<T: NSObject & StorageObserving>(_ predicate: NSPredicate? = nil, observer: T, keyPath: ReferenceWritableKeyPath<T, [ManagedType.StorageType]>) -> [Self] {
//
//        return ManagedType.query(predicate, observer: observer, keyPath: keyPath)
//    }
//
//    public static func query<T: Storable>(_ predicateFormat: String? = nil, args: [Any] = [], joining type: T.Type, foreignKey: String, joinedPredicateFormat: String? = nil, joinedArgs: [Any] = []) -> [Self] where T.ManagedType.StorageType == T {
//
//        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
//        let joinedPredicate: NSPredicate? = joinedPredicateFormat == nil ? nil : NSPredicate(format: joinedPredicateFormat!, joinedArgs)
//        return query(predicate, joining: type, foreignKey: foreignKey, joinedPredicate: joinedPredicate)
//    }
//
//    public static func query<T: Storable>(_ predicate: NSPredicate? = nil, joining type: T.Type, foreignKey: String, joinedPredicate: NSPredicate? = nil) -> [Self] where T.ManagedType.StorageType == T {
//
//        let items: [T] = T.ManagedType.query(joinedPredicate)
//        let foreignKeys = items.map { $0.identifier }
//        let foreignPredicate = NSPredicate(format: "(\(foreignKey) IN %@)", foreignKeys)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, foreignPredicate].compactMap { $0 })
//        return query(compoundPredicate)
//    }
//
//    public static func values<T>(filteredBy predicateFormat: String?, args: [Any], keyPath: String, type: T.Type) -> [T] {
//
//        return ManagedType.values(filteredBy: predicateFormat, args: args, keyPath: keyPath, type: type)
//    }
//
//    public static func values<T>(filteredBy predicate: NSPredicate?, keyPath: String, type: T.Type) -> [T] {
//
//        return ManagedType.values(filteredBy: predicate, keyPath: keyPath, type: type)
//    }
//
//    public static func find(byId identifier: IdentifierType) -> Self? {
//
//        return ManagedType.find(byId: String(identifier))
//    }
//
////    public static func query<T: Storable, O: NSObject & StorageObserving>(_ predicateFormat: String? = nil, args: [Any] = [], joining type: T.Type, foreignKey: String, joinedPredicateFormat: String? = nil, joinedArgs: [Any] = [], observer: O, keyPath: ReferenceWritableKeyPath<O, [Self]>) throws -> [Self] {
////
////        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
////        let joinedPredicate: NSPredicate? = joinedPredicateFormat == nil ? nil : NSPredicate(format: joinedPredicateFormat!, joinedArgs)
////
////        return try query(predicate, joining: type, foreignKey: foreignKey, joinedPredicate: joinedPredicate, observer: observer, keyPath: keyPath)
////    }
////
////    public static func query<T: Storable, O: NSObject & StorageObserving>(_ predicate: NSPredicate?, joining type: T.Type, foreignKey: String, joinedPredicate: NSPredicate? = nil, observer: O, keyPath: ReferenceWritableKeyPath<O, [Self]>) throws -> [Self] {
////
////        let foreignKeys = try T.ManagedType.query(joinedPredicate).map { $0.identifier }
////        let foreignPredicate = NSPredicate(format: "(\(foreignKey) IN %@)", foreignKeys)
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, foreignPredicate].compactMap { $0 })
////        return try query(compoundPredicate, observer: observer, keyPath: keyPath)
////    }
//}
}

public func ==<T: Storable>(lhs: T, rhs: T) -> Bool {
    
    return String(lhs.identifier) == String(rhs.identifier)
}
