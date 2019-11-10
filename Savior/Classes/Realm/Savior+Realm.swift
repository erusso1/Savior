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
    
    public static func instance() -> Realm? {
        
        do {
            let realm = try Realm(configuration: realmConfiguration)
            return realm
        }
        catch {
            Savior.logger?.log("An error occurred initializing Realm instance - Error: \(error)")
            return nil
        }
    }
    
    public static func clear() {
        
        guard let realm = Realm.instance() else { return }
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            Savior.logger?.log("An error occurred saving sequence to Realm - Sequence: \(self), Error: \(error)")
        }
    }
}
