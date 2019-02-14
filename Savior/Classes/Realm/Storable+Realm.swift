//
//  Storable+Realm.swift
//  Savior
//
//  Created by Ephraim Russo on 2/15/19.
//

import Foundation
import RealmSwift

extension Storable where ManagedType: RealmObject, ManagedType.StorageType == Self {
    
    public func managedObject() -> ManagedType {
        
        return ManagedType.fromStorageObject(self)
    }
    
    public static func fromManagedObject(_ item: ManagedType) -> Self {
        
        return item.storageObject()
    }
    
    public func save() {
        
        let realm = Realm.instance()
        try! realm.write {
            realm.add(managedObject(), update: true)
        }
    }
    
    public func delete() {
        
        guard let item: ManagedType = Realm.instance().objects(ManagedType.self).filter("identifier == '\(String(identifier))'").first else { return }
        let realm = Realm.instance()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    public static func deleteAll() {
        
        let realm = Realm.instance()
        let items: Results<ManagedType> = realm.objects(ManagedType.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
    public static func count(predicate: NSPredicate? = nil) -> Int  {
        
        return query(predicate).count
    }
    
    public static func query(_ predicate: NSPredicate? = nil) -> [Self] {
        
        return Realm.instance().objects(ManagedType.self).filter(predicate ?? .true).map { $0.storageObject() }
    }
    
    public static func query(_ predicateFormat: String? = nil, args: Any...) -> [Self] {
        
        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
        return query(predicate)
    }
    
    public static func find(byId identifier: IdentifierType) -> Self? {
        
        return query("identifier == '\(String(identifier))'").first
    }

    public static func query<T: NSObject & StorageObserving>(_ predicateFormat: String? = nil, args: [Any] = [], observer: T, keyPath: ReferenceWritableKeyPath<T, [ManagedType.StorageType]>) -> [Self] {
        
        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
        
        return query(predicate, observer: observer, keyPath: keyPath)
    }
    
    public static func query<T: NSObject & StorageObserving>(_ predicate: NSPredicate? = nil, observer: T, keyPath: ReferenceWritableKeyPath<T, [ManagedType.StorageType]>) -> [Self] {
        
        let items: Results<ManagedType> = Realm.instance().objects(ManagedType.self).filter(predicate ?? .true)
    
        observer.storageObservingToken = items.observe { [weak observer] changes in
            
            switch changes {
                
            case .initial(let i):
                let items = Array(i).map { $0.storageObject() }
                observer?[keyPath: keyPath] = items
                observer?.didObserveInitialCollection(items: items, predicate: predicate, keyPath: keyPath)
                
            case .update(let c, let d, let i, modifications: let m):
                let items = Array(c).map { $0.storageObject() }
                observer?[keyPath: keyPath] = items
                observer?.didObserveUpdatedCollection(items: items, predicate: predicate, deleted: d, inserted: i, modified: m, keyPath: keyPath)
                
            case .error(let e): observer?.didObserveCollectionError(e)
            }
        }

        return items.map { $0.storageObject() }
    }
    
    public static func query<T: Storable>(_ predicateFormat: String? = nil, args: [Any] = [], joining type: T.Type, foreignKey: String, joinedPredicateFormat: String? = nil, joinedArgs: [Any] = []) -> [Self] where T.ManagedType : RealmObject, T.ManagedType.StorageType == T {
        
        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
        let joinedPredicate: NSPredicate? = joinedPredicateFormat == nil ? nil : NSPredicate(format: joinedPredicateFormat!, joinedArgs)
        return query(predicate, joining: type, foreignKey: foreignKey, joinedPredicate: joinedPredicate)
    }
    
    public static func query<T: Storable>(_ predicate: NSPredicate? = nil, joining type: T.Type, foreignKey: String, joinedPredicate: NSPredicate? = nil) -> [Self] where T.ManagedType : RealmObject, T.ManagedType.StorageType == T {
        
        let joinedIdentifiers = T.query(joinedPredicate).map { $0.identifier }
        let foreignPredicate = NSPredicate(format: "(\(foreignKey) IN %@)", joinedIdentifiers)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, foreignPredicate].compactMap { $0 })
        return query(compoundPredicate)
    }
    
    public static func values<T>(filteredBy predicateFormat: String?, args: [Any], keyPath: String, type: T.Type) -> [T] {
        
        let predicate: NSPredicate? = predicateFormat == nil ? nil : NSPredicate(format: predicateFormat!, args)
        return values(filteredBy: predicate, keyPath: keyPath, type: type)
    }
    
    public static func values<T>(filteredBy predicate: NSPredicate?, keyPath: String, type: T.Type) -> [T] {
        
        return Realm.instance().objects(ManagedType.self).filter(predicate ?? .true).value(forKeyPath: "@distinctUnionOfObjects.\(keyPath)") as? [T] ?? []
    }
}
