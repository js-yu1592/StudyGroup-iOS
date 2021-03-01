//
//  Memo+CoreDataClass.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    var STATEMEMO : StateMemo {
        get { return StateMemo.init(rawValue: state) ?? .dafaultStatus }
        set { state = Int64(newValue.rawValue) }
    }
}
