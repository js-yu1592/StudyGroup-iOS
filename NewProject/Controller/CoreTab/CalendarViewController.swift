//
//  CalendarViewController.swift
//  StudyPlanner
//
//  Created by 박형석 on 2021/02/14.
//

import UIKit
import FSCalendar
import SnapKit
import JJFloatingActionButton
import CoreData

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
   
    // MARK: - Property
    
    var sections : [Section] = [
        Section(title: "note"),
        Section(title: "todo")
    ]
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        floatingActionButton()
        initializeForCalendar()
        fetchDateMemos(date: Date(),isNote: true)
        fetchDateMemos(date: Date(),isNote: false)
        
    }
    
    // MARK: - Calendar DataSource & Delegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = formatter.string(from: date)
        let request = Memo.fetchRequest() as NSFetchRequest
        let datePredicate = NSPredicate(format: "date CONTAINS '\(dateString)'")
        let notePredicate = NSPredicate(format: "isNote == '1'")
        let myPredicateCompound1 = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, notePredicate])
        request.predicate = myPredicateCompound1
        sections[0].cells = try! context.fetch(request)
        
        let request2 = Memo.fetchRequest() as NSFetchRequest
        let datePredicate2 = NSPredicate(format: "date CONTAINS '\(dateString)'")
        let notePredicate2 = NSPredicate(format: "isNote == '0'")
        let myPredicateCompound2 = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate2, notePredicate2])
        request2.predicate = myPredicateCompound2
        sections[1].cells = try! context.fetch(request2)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = formatter.string(from: date)
        let request = Memo.fetchRequest() as NSFetchRequest
        let datePredicate = NSPredicate(format: "date CONTAINS '\(dateString)'")
        let notePredicate = NSPredicate(format: "isNote == '1'")
        let myPredicateCompound1 = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, notePredicate])
        request.predicate = myPredicateCompound1
        let section1 = try! context.fetch(request)

        
        let request2 = Memo.fetchRequest() as NSFetchRequest
        let datePredicate2 = NSPredicate(format: "date CONTAINS '\(dateString)'")
        let notePredicate2 = NSPredicate(format: "isNote == '0'")
        let myPredicateCompound2 = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate2, notePredicate2])
        request2.predicate = myPredicateCompound2
        let section2 = try! context.fetch(request2)
        
        if !section1.isEmpty {
            if !section2.isEmpty {
                return 2
            } else {
                return 1
            }
        } else if !section2.isEmpty {
            return 1
        } else {
            return 0
        }
    }
}

