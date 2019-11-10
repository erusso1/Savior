//
//  Sequence+Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 2/17/19.
//

import Foundation
import RealmSwift

extension Sequence where Element : Storable, Element.ManagedType : (Object & RealmStorageManaging) {
    
    public func save() {
                
        self.map { $0.managedObject() }.save()
    }
    
    public func delete() {
        
        guard let realm = Realm.instance() else { return }
        
        let result = realm.objects(Element.ManagedType.self).filter("\(Element.ManagedType.primaryKey()!) IN %@", self.map { String($0.identifier) })
        do {
            try realm.write {
                realm.delete(result)
            }
        }
        catch {
            Savior.logger?.log("An error occurred remoing sequence from Realm - Sequence: \(self), Error: \(error)")

        }
    }
}

extension Sequence where Element : (Object & RealmStorageManaging) {
    
    public func save() {
        
        guard let realm = Realm.instance() else { return }
        
        do {
            try realm.write {
                realm.add(self, update: .modified)
            }
        }
        catch {
            Savior.logger?.log("An error occurred saving sequence to Realm - Sequence: \(self), Error: \(error)")
        }
    }
}
