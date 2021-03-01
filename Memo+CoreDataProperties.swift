//
//  Memo+CoreDataProperties.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var alarmDate: Date?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var state: Int64

}

extension Memo : Identifiable {

}
