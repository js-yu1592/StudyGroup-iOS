//
//  Note+CoreDataProperties.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?

}

extension Note : Identifiable {

}
