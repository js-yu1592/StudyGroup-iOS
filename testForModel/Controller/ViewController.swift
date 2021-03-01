//
//  ViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit
import FSCalendar
import JJFloatingActionButton

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    let memoManager = MemoManager.shared
    let noteManager = NoteManager.shared
    let sections: [Section] = [
        Section(title: "note"),
        Section(title: "memo")
    ]
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        calendar.select(Date())
        memoManager.memos = memoManager.readMemos(date: calendar.selectedDate!)
        noteManager.notes = noteManager.readNote(date: calendar.selectedDate!)
        
        initializeForCalendar()
        floatingActionButton()
        tableViewInitialUISetUp()
        
    }
    
    func floatingActionButton(){
        let actionButton = JJFloatingActionButton()
        
        actionButton.buttonColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        actionButton.addItem(title: "메모 작성", image: UIImage(systemName: "note.text.badge.plus")?.withRenderingMode(.alwaysTemplate)) { item in
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "noteVC") as? NoteViewController else { return }
            vc.completionBlock = {
                guard let content = vc.textView.text else { return }
                let date = self.calendar.selectedDate!
                self.noteManager.createNote(content: content, date: date)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            self.present(vc, animated: true, completion: nil)
            
        }
        
        actionButton.addItem(title: "할 일 작성", image: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysTemplate)) { item in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "todoVC") as! TodoViewController
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler = {
                let content = vc.todoTextField.text!
                let date = self.calendar.selectedDate!
                let state = StateMemo.dafaultStatus
                self.memoManager.createMemo(content: content, date: date, state: state.rawValue)
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


}

