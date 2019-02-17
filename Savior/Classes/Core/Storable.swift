
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
        
    /// A unique identifier used to look up the `Storable`
    var identifier: IdentifierType { get }
}

public func ==<T: Storable>(lhs: T, rhs: T) -> Bool {
    
    return String(lhs.identifier) == String(rhs.identifier)
}
