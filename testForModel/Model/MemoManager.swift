//
//  MemoManager.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit
import CoreData

class MemoManager {
    static let shared = MemoManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var memos = [Memo]()
    
    private func saveMemo() {
        do {
            try context.save()
        }
        catch {
            print("-----> save error : \(error)")
        }
    }
    
    public func createMemo(content: String, date: Date, state: Int64, alarmDate: Date? = nil) {
        let newMemo = Memo(context: context)
        newMemo.content = content
        newMemo.date = date
        newMemo.state = state
        
        if let alarmDate = alarmDate {
            newMemo.alarmDate = alarmDate
        }
        saveMemo()
        memos = readMemos(date: date)
    }
    
    public func readMemos(date: Date) -> [Memo] {
        let request = Memo.fetchRequest() as NSFetchRequest<Memo>
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        request.predicate = predicate
        do {
            let newMemo = try context.fetch(request)
            return newMemo
        }
        catch {
            print("-----> fetch error : \(error)")
            return []
        }
    }
    
    public func updateMemo(memo: Memo, content: String? = nil, state: Int64? = nil, alarmDate: Date? = nil, newDate: Date? = nil) {
        
        if let content = content {
            memo.content = content
        }
        if let state = state {
            memo.state = state
        }
        
        if let alarmDate = alarmDate {
            memo.alarmDate = alarmDate
        }
        
        if let newDate = newDate {
            memo.date = newDate
        }
        saveMemo()
    }
    
    public func deleteMemo(memo : Memo) {
        context.delete(memo)
        saveMemo()
    }
}
