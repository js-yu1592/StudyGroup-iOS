//
//  CalendarViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/26.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var completionHandler: ((Date)->Void)?
    var completionHandler2: ((Date)->Void)?
    
    @IBOutlet weak var updateCalendar: FSCalendar!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeForUpdateCalendar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewwillDisappear")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if let completionHandler2 = completionHandler2 {
            completionHandler2(date)
        }
      
        if let completionHandler = completionHandler {
            completionHandler(date)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dimmingButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initializeForUpdateCalendar() {
        //utility
        updateCalendar.select(Date())
        updateCalendar.delegate = self
        updateCalendar.dataSource = self
        updateCalendar.scope = .month
        updateCalendar.backgroundColor = .white
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // header
        updateCalendar.headerHeight = 70
        updateCalendar.appearance.headerTitleColor = UIColor.black
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        updateCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        updateCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24, weight: .light)
        
        // week
        updateCalendar.appearance.weekdayTextColor = UIColor.darkGray
        updateCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .light)
        updateCalendar.locale = Locale(identifier: "ko_KR")
        
        //body
        updateCalendar.layer.masksToBounds = true
        updateCalendar.layer.cornerRadius = 20
        updateCalendar.appearance.titleTodayColor = .red
        updateCalendar.appearance.todayColor = .clear
        updateCalendar.appearance.todaySelectionColor = .darkGray
        updateCalendar.appearance.selectionColor = .darkGray
        updateCalendar.appearance.eventDefaultColor = .lightGray
    }
    

}
