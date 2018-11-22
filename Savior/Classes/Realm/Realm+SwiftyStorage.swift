//
//  Realm+Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/19/18.
//

import Foundation
import Realm
import RealmSwift

extension NotificationToken: StorageObservingToken { }

extension Realm: SwiftyDataStoring {
    
    public func clear() throws {
        
        try self.write {
            self.deleteAll()
        }
    }
}

extension Savior {
    
    internal static func database() throws -> SwiftyDataStoring {
        
        return try realm()
    }
    
    internal static func realm() throws -> Realm {
        
        let config = Realm.Configuration(encryptionKey: encryptionKey, deleteRealmIfMigrationNeeded: !isMigrationEnabled)
        
        //config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("Savior-disk.realm")
        
        return try Realm(configuration: config)
    }
}

extension Sequence where Element : Storable, Element.ManagedType : (Object & RealmStorageManaging) {
    
    public func save() throws {
        
        let managedObjects = try self.map { try $0.managedObject() }

        let realm = try Savior.realm()
        try realm.write {
            realm.add(managedObjects, update: true)
        }        
    }
    
    public func delete() throws {
        
        let realm = try Savior.realm()
        let items = realm.objects(Element.ManagedType.self).filter("identifier IN %@", self.map { String($0.identifier) })
        try realm.write {
            realm.delete(items)
        }
    }
}

extension Sequence where Element : (Object & RealmStorageManaging) {
    
    public func save() throws {
        
        let realm = try Savior.realm()
        try realm.write {
            realm.add(self, update: true)
        }
    }
}
