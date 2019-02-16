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
            realm.add(self, update: true)
        }
    }
}
