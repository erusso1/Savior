//
//  Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public struct Savior {
    
    internal static var encryptionKey: Data?
    
    internal static var isMigrationEnabled = true
    
    public static func useEncryption(key: Data) {
        
        self.encryptionKey = key
    }
    
    public static func enableMigrations(_ enable: Bool) {
        
        self.isMigrationEnabled = enable
    }
}

extension Savior: SwiftyStorable {
    
    public static func clear() throws {
        
        try database().clear()
    }
}

internal protocol SwiftyDataStoring {
    
    func clear() throws
}

internal protocol SwiftyStorable {
    
    static func database() throws -> SwiftyDataStoring
}
