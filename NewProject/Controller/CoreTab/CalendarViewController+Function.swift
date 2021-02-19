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
    func fetchDateMemos(date: Date){
        
        let dateString = formatter.string(from: date)
        
        let request = Memo.fetchRequest() as NSFetchRequest<Memo>
        let predict = NSPredicate(format: "date CONTAINS '\(dateString)'")
        request.predicate = predict
        
        do {
            self.memos = try self.context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
        }
        catch {
            print("fetch error")
        }
    }
}
