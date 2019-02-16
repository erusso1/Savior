//
//  Realm+Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/19/18.
//

import Foundation
import Realm
import RealmSwift

public protocol RealmStorageManaging: StorageManaging { }

@objcMembers open class RealmObject: Object {
    
    override open class func primaryKey() -> String? { return "identifier" }
    
    dynamic public var identifier: String = ""
}

extension NotificationToken: StorageObservingToken { }

extension Realm: StorageProviding {
    
    fileprivate static var realmConfiguration = Realm.Configuration()

    public static func use(encryptionKey: Data?, enableMigrations: Bool) {
        
        realmConfiguration = Realm.Configuration(encryptionKey: encryptionKey, deleteRealmIfMigrationNeeded: !enableMigrations)
    }
    
    public static func instance() -> Realm {
        
        return try! Realm(configuration: realmConfiguration)
    }
    
    public static func clear() {
        
        let realm = Realm.instance()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

extension Sequence where Element : Storable, Element.ManagedType : (Object & RealmStorageManaging) {
    
    public func save() {
        
        self.map { $0.managedObject() }.save()
    }
    
    public func delete() {
        
        let realm = Realm.instance()
        let result = realm.objects(Element.ManagedType.self).filter("identifier IN %@", self.map { String($0.identifier) })
        try! realm.write {
            realm.delete(result)
        }
    }
}

extension Sequence where Element : (Object & RealmStorageManaging) {
    
    public func save() {
        
        let realm = Realm.instance()
        try! realm.write {
            for item in self {
                realm.add(item, update: true)
            }
        }
    }
}

extension NSPredicate {
    
    static var `true`: NSPredicate { return NSPredicate(format: "TRUEPREDICATE") }
}
