//
//  Savior.swift
//  Savior
//
//  Created by Ephraim Russo on 11/18/18.
//

import Foundation

public final class Savior {
    
    public static let shared = Savior()
    
    internal static var logger: SaviorLogProviding?
    
    public func use<T: StorageProviding>(provider: T.Type, encryptionKey: Data? = nil, enableMigrations: Bool = true, filename: String? = nil, logger: SaviorLogProviding? = SaviorLogger()) {
        
        Savior.logger = logger
        
        T.use(encryptionKey: encryptionKey, enableMigrations: enableMigrations, filename: filename)
    }
    
    public func clear<T: StorageProviding>(provider: T.Type) {
        
        T.clear()
    }
}

public protocol StorageProviding {
    
    static func use(encryptionKey: Data?, enableMigrations: Bool, filename: String?)
    
    static func instance() -> Self?
    
    static func clear()
}

public protocol SaviorLogProviding {
    
    func log(_ items: Any...)
}

extension SaviorLogProviding {
    
    public func log(_ items: Any...) {
        
        print("***************************************")
        print(" ")
        print(items)
        print(" ")
        print("***************************************")
    }
}

open class SaviorLogger: NSObject, SaviorLogProviding {
 
    public override init() {
        super.init()
    }
}
