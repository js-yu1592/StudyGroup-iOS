//
//  Memo+CoreDataClass.swift
//  
//
//  Created by 박형석 on 2021/02/22.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    var STATUSMEMO : StatusMemo {
        get { return StatusMemo.init(rawValue: status) ?? .dafaultStatus }
        set { status = Int64(newValue.rawValue) }
    }
}
