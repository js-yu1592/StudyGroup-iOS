//
//  PopUpViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/21.
//

import UIKit
import FSCalendar

class PopUpViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Outlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    // MARK: -Property
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var completionHandlerForStatus: ((Int64)->Void)?
    var completionHandlerForDate: ((String)->Void)?
    
    let calendarView: FSCalendar = {
       let view = FSCalendar()
        view.select(Date())
        view.appearance.headerTitleColor = UIColor.black
        view.appearance.headerMinimumDissolvedAlpha = 0.0
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.appearance.headerTitleFont = UIFont.systemFont(ofSize: 15, weight: .light)
        view.appearance.weekdayTextColor = UIColor.darkGray
        view.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .light)
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.titleTodayColor = .red
        view.appearance.todayColor = .clear
        view.appearance.todaySelectionColor = .darkGray
        view.appearance.selectionColor = .darkGray
        view.appearance.eventDefaultColor = .lightGray
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
    
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
    
        view.addSubview(calendarView)
        calendarView.isHidden = true
        calendarView.select(Date())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        calendarView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        calendarView.center.x = view.center.x
        calendarView.center.y = view.center.y
    }
    
    // MARK: -FSCalendar Delegate and DataSource
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
        let dateString = formatter.string(from: date)
        self.dismiss(animated: true) {
            
            self.navigationController?.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = 0
            
            
            if let completionHandlerForStatus = self.completionHandlerForStatus {
                completionHandlerForStatus(StatusMemo.postpone.rawValue)
            }
            
            if let completionHandlerForDate = self.completionHandlerForDate{
                completionHandlerForDate(dateString)
            }
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // MARK: -Button Action
    
    @IBAction func BackgroundButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func incompletionButtonTapped(_ sender: UIButton) {
        
        if let completionHandler = completionHandlerForStatus {
            completionHandler(StatusMemo.incompletion.rawValue)
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func postponeButtonTapped(_ sender: UIButton) {
        
        calendarView.isHidden = true
        buttonStackView.isHidden = false
        calendarView.alpha = 0
        buttonStackView.alpha = 1
        
        UIView.animate(withDuration: 0.5) {
            self.calendarView.isHidden = false
            self.buttonStackView.isHidden = true
            self.calendarView.alpha = 1
            self.buttonStackView.alpha = 0
            self.blurView.isHidden = true
        }
    }
    
    @IBAction func ongoingButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandlerForStatus {
                completionHandler(StatusMemo.ongoing.rawValue)
            }
        }
    }
    
    @IBAction func completionButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandlerForStatus {
                completionHandler(StatusMemo.completion.rawValue)
            }
        }
    }
}

enum STATUSMEMO {
    case incompletion
    case postpone
    case ongoing
    case completion
}
