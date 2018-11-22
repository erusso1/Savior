
import Foundation
import Realm
import RealmSwift

public protocol RealmStorageManaging: StorageManaging { }

extension RealmStorageManaging where Self : Object {
    
    public func save() throws {
                
        let realm = try Savior.realm()
        try realm.write {
            realm.add(self, update: true)
        }
    }
    
    public func delete() throws {
        
        let realm = try Savior.realm()
        guard let item = realm.objects(Self.self).filter("identifier == '\(self.identifier)'").first else { return }
        try realm.write {
            realm.delete(item)
        }
    }

    public static func count() throws -> Int {
        
        return try query().count
    }
    
    public static func query(_ predicate: String? = nil) throws -> [Self] {
        
        let realm = try Realm()
        let result = realm.objects(Self.self).filter(predicate ?? "TRUEPREDICATE")
        return Array(result)
    }
    
    public static func query<T: NSObject & StorageObserving>(_ predicate: String?, observer: T, keyPath: ReferenceWritableKeyPath<T, [StorageType]>) throws -> [Self] {

        let realm = try Realm()
        let result = realm.objects(Self.self).filter(predicate ?? "TRUEPREDICATE")
        
        observer.storageObservingToken = result.observe { [weak observer] changes in
            
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
        
        return Array(result)
    }

    public static func find(byId identifier: String) throws -> Self? {
        
        return try query("identifier == '\(identifier)'").first
    }
    
    public static func deleteAll() throws {
        
        let realm = try Savior.realm()
        let items = realm.objects(Self.self)
        try realm.write {
            realm.delete(items)
        }
    }
}
