//
//  StorageObserving.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public protocol StorageObservingToken {
    
    func invalidate()
}

public protocol StorageObserving: class {
    
    var storageObservingToken: StorageObservingToken! { get set }
    
    func didObserveInitialCollection<T: Storable>(items: [T], predicate: String?, keyPath: AnyKeyPath)
    
    func didObserveUpdatedCollection<T: Storable>(items: [T], predicate: String?, deleted: [Int], inserted: [Int], modified: [Int], keyPath: AnyKeyPath)
    
    func didObserveCollectionError(_ error: Error)
}

extension StorageObserving {
    
    public func didObserveCollectionError(_ error: Error) {
        
        fatalError("\(error)")
    }
}
