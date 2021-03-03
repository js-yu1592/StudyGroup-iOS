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
    @IBOutlet weak var tableVIewBottomConstraint: NSLayoutConstraint!
    
    
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
    
    let actionButton = JJFloatingActionButton()
    
    let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        calendar.select(Date())
        memoManager.memos = memoManager.readMemos(date: calendar.selectedDate!)
        noteManager.notes = noteManager.readNote(date: calendar.selectedDate!)
        actionButton.isHidden = true
        
        initializeForCalendar()
        floatingActionButton()
        tableViewInitialUISetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewdisappear")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func willShow(_ notification: Notification){
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        tableVIewBottomConstraint.constant = 0
       
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.tableVIewBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func willHide(_ notification: Notification){
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.tableVIewBottomConstraint.constant = keyboardHeight
       
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.tableVIewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func floatingActionButton(){
        
        actionButton.buttonColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        actionButton.addItem(title: "메모 작성", image: UIImage(systemName: "note.text.badge.plus")?.withRenderingMode(.alwaysTemplate)) { item in
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "noteVC") as? NoteViewController else { return }
           
            vc.title = self.formatter.string(from: self.calendar.selectedDate!)
            vc.completionBlock = {
                guard let content = vc.textView.text else { return }
                let date = self.calendar.selectedDate!
                self.noteManager.createNote(content: content, date: date)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                    
                }
            }
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
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
                    self.scrollToBottom()
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

