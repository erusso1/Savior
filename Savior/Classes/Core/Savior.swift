//
//  Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public final class Savior {
    
    public static let shared = Savior()
    
    public func use<T: StorageProviding>(provider: T.Type, encryptionKey: Data? = nil, enableMigrations: Bool = true) {
        
        T.use(encryptionKey: encryptionKey, enableMigrations: enableMigrations)
    }
    
    public func clear<T: StorageProviding>(provider: T.Type) {
        
        T.clear()
    }
}

public protocol StorageProviding {
    
    static func use(encryptionKey: Data?, enableMigrations: Bool)
    
    static func instance() -> Self
    
    static func clear()
}
