//
//  BaseManagedObject.swift
//  Savior_Tests
//
//  Created by Ephraim Russo on 2/16/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers open class BaseManagedObject: Object {
    
    override open class func primaryKey() -> String? { return "identifier" }
    
    dynamic public var identifier: String = ""
}
