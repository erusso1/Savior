//
//  RealmObject.swift
//  SwiftyStorage_Tests
//
//  Created by Ephraim Russo on 11/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers public class RealmObject: Object {
    
    override public static func primaryKey() -> String? { return "identifier" }
    
    dynamic public var identifier: String = ""
}
