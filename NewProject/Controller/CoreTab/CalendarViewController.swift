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
    
    private lazy var scopeGesture: UIPanGestureRecognizer = {
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
                
                self.saveMemo()
                self.fetchDateMemos(date: date, isNote: false)
            }
            self.present(vc, animated: true, completion: nil)
        }
        view.addSubview(actionButton)
        actionButton.display(inViewController: self)
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
        } else {
            return 0
        }
    }
}

