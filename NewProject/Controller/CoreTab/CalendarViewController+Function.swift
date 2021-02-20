//
//  CalendarViewController+extension.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/18.
//

import Foundation
import CoreData

extension CalendarViewController {
    
    func saveMemo() {
        do {
            try self.context.save()
        }
        catch {
            print("save error")
        }
    }
    
    ///fetch memos filtering date
    /// - date : Date
    func fetchDateMemos(date: Date, isNote: Bool){
        let dateString = formatter.string(from: date)
        if isNote == true {
            let request = Memo.fetchRequest() as NSFetchRequest
            let datePredicate = NSPredicate(format: "date CONTAINS '\(dateString)'")
            let notePredicate = NSPredicate(format: "isNote == '1'")
            let myPredicateCompound1 = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, notePredicate])
            request.predicate = myPredicateCompound1
            sections[0].cells = try! context.fetch(request)
        } else {
            let request = Memo.fetchRequest() as NSFetchRequest
            let datePredicate = NSPredicate(format: "date CONTAINS '\(dateString)'")
            let notePredicate = NSPredicate(format: "isNote == '0'")
            let myPredicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, notePredicate])
            request.predicate = myPredicateCompound
            sections[1].cells = try! context.fetch(request)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.calendar.reloadData()
        }
        
    }
}
