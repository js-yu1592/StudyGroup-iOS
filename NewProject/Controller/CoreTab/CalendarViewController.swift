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

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    let dataManager = DataManager.shared
    var models : [String] = []
    
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
        
    }
    
    // MARK: - Function
    
    func initializeForCalendar(){
        self.calendar.select(Date())
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.scope = .week
        self.calendar.backgroundColor = .white
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
                let dateString = self.dataManager.formatter.string(from: self.calendar.selectedDate!)
                let text = vc.textView.text
                if self.dataManager.eventsDic[dateString] != nil {
                    self.dataManager.eventsDic[dateString]?.append(text!)
                } else {
                    self.dataManager.eventsDic.updateValue([], forKey: dateString)
                    self.dataManager.eventsDic[dateString]?.append(text!)
                }
                
                self.models = self.dataManager.eventsDic[dateString] ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        actionButton.addItem(title: "할 일 작성", image: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysTemplate)) { item in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDoVC") as? ToDoViewController else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.completionBlock = {
                let dateString = self.dataManager.formatter.string(from: self.calendar.selectedDate!)
                let text = vc.todoTextField.text
                
                if self.dataManager.eventsDic[dateString] != nil {
                    self.dataManager.eventsDic[dateString]?.append(text!)
                } else {
                    self.dataManager.eventsDic.updateValue([], forKey: dateString)
                    self.dataManager.eventsDic[dateString]?.append(text!)
                }
                
                self.models = self.dataManager.eventsDic[dateString] ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        view.addSubview(actionButton)
        actionButton.display(inViewController: self)
        
    }
    
    
    
    // MARK: - TableView DataSourse & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row]
        cell.detailTextLabel?.text = "생성일 : \(dataManager.formatter.string(from: Date()))"
        
        return cell
    }
    
    // MARK: - Calendar DataSource & Delegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateString = dataManager.formatter.string(from: date)
        models = dataManager.eventsDic[dateString] ?? []
        self.tableView.reloadData()
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = dataManager.formatter.string(from: date)
        
        for dic in dataManager.eventsDic {
            let eventdate = dic.key
            let newDate = eventdate
            if newDate.contains(dateString) {
                return dataManager.eventsDic[eventdate]!.count
            }
        }
        return 0
    }
    
    
    
    
}

