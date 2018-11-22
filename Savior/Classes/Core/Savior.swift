//
//  Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public struct Savior {
    
    internal static var provider: StorageProviding?
    
    public static func useProvider<T: StorageProviding>(_ provider: T.Type, encryptionKey: Data? = nil, enableMigrations: Bool = true) throws {
        
        self.provider = try T.instance(encryptionKey: encryptionKey, enableMigrations: enableMigrations)
    }
    
    public static func clear() throws {
        
        guard let provider = self.provider else { throw SaviorError.noProvider }
        
        try provider.clear()
    }
}

public protocol StorageProviding {
    
    static func instance(encryptionKey: Data?, enableMigrations: Bool) throws -> Self
    
    func clear() throws
}

enum SaviorError: Error {
    
    case noProvider
    
    case incorrectProvider(provider: StorageProviding)
}
