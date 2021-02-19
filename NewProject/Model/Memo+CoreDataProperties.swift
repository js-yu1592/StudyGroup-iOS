//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 박형석 on 2021/02/18.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?

}
