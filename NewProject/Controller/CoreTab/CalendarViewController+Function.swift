//
//  CalendarViewController+extension.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/18.
//

import UIKit
import CoreData
import FSCalendar
import JJFloatingActionButton

extension CalendarViewController {
    
    // MARK: - Function
    
    func initializeForCalendar() {
        //utility
        calendar.select(Date())
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        calendar.backgroundColor = .white
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // header
        calendar.headerHeight = 70
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24, weight: .light)
        
        // week
        calendar.appearance.weekdayTextColor = UIColor.darkGray
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .light)
        calendar.locale = Locale(identifier: "ko_KR")
        
        //body
        calendar.appearance.titleTodayColor = .red
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .darkGray
        calendar.appearance.selectionColor = .darkGray
        calendar.appearance.eventDefaultColor = .lightGray
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            default:
                return true
            }
        }
        return shouldBegin
    }
    
    func floatingActionButton(){
        let actionButton = JJFloatingActionButton()
        
        actionButton.buttonColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        actionButton.addItem(title: "메모 작성", image: UIImage(systemName: "note.text.badge.plus")?.withRenderingMode(.alwaysTemplate)) { item in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "memoVC") as? MemoViewController else { return }
            vc.completionBlock = {
                let date = self.calendar.selectedDate!
                let dateString = self.formatter.string(from: date)
                let text = vc.textView.text
                
                // create Memo
                let memo = Memo(context: self.context)
                memo.content = text
                memo.date = dateString
                memo.isNote = true
                memo.STATUSMEMO = .dafaultStatus
                
                self.saveMemo()
                self.fetchDateMemos(date: date, isNote: true)
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        actionButton.addItem(title: "할 일 작성", image: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysTemplate)) { item in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDoVC") as? ToDoViewController else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.completionBlock = {
                let date = self.calendar.selectedDate!
                let dateString = self.formatter.string(from: date)
                let text = vc.todoTextField.text
                
                // create Memo
                let memo = Memo(context: self.context)
                memo.content = text
                memo.date = dateString
                memo.isNote = false
                memo.STATUSMEMO = .dafaultStatus
                
                self.saveMemo()
                self.fetchDateMemos(date: date, isNote: false)
            }
            self.present(vc, animated: true, completion: nil)
        }
        view.addSubview(actionButton)
        actionButton.display(inViewController: self)
    }
    
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
