//
//  Realm+Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/19/18.
//

import Foundation
import Realm
import RealmSwift

public typealias RealmObject = Object

public protocol RealmStorageManaging: StorageManaging { }

extension NotificationToken: StorageObservingToken { }

extension Realm: StorageProviding {
    
    fileprivate static var realmConfiguration = Realm.Configuration()

    public static func use(encryptionKey: Data?, enableMigrations: Bool, filename: String?) {
        
        var config = Realm.Configuration(encryptionKey: encryptionKey, deleteRealmIfMigrationNeeded: !enableMigrations)
        
        if let filename = filename { config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(filename).realm") }
        
        realmConfiguration = config
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
