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

extension Realm: StorageProviding {
    
    public static func instance(encryptionKey: Data?, enableMigrations: Bool) throws -> Realm {
        
        let config = Realm.Configuration(encryptionKey: encryptionKey, deleteRealmIfMigrationNeeded: !enableMigrations)
        
        //config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("Savior-disk.realm")
        
        return try Realm(configuration: config)
    }
    
    public func clear() throws {
        
        try self.write {
            self.deleteAll()
        }
    }
}

extension Savior {
    
    internal static func realm() throws -> Realm {
        
        guard let provider = Savior.provider else { throw SaviorError.noProvider }
        guard let realm = provider as? Realm else { throw SaviorError.incorrectProvider(provider: provider) }
        return realm
    }
}

extension Sequence where Element : Storable, Element.ManagedType : (Object & RealmStorageManaging) {
    
    public func save() throws {
        
        let realm = try Savior.realm()
        let managedObjects = try self.map { try $0.managedObject() }
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
