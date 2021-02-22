//
//  CalendarViewController.swift
//  Todo
//
//  Created by 유준상 on 2021/02/21.
//

import UIKit
import FSCalendar

// MARK:- FSCalendarDelegate, FSCalendarDataSource
extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    /// clickedDate을 키값으로 정해 tableView를 reload
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        clickedDate = dateFormatter.string(from: date)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = dateFormatter.string(from: date)
//        let keyTodoItemDic = Set(todoItemDic.keys)
//        let keyNoteContent = Set(noteContent.keys)
//        
//        let intersectionKey = keyTodoItemDic.intersection(keyNoteContent)
//        let exclusiveOrKey = (keyTodoItemDic.subtracting(keyNoteContent)).union(keyNoteContent.subtracting(keyTodoItemDic))
//        
//        if intersectionKey.contains(dateFormatter.string(from: date)) {
//            return 2
//        } else if exclusiveOrKey.contains(dateFormatter.string(from: date)){
//            return 1
//        } else {
//            return 0
//        }
        if todoItemDic.keys.contains(stringDate) && noteContent.keys.contains(stringDate) {
            return 2
        } else if todoItemDic.keys.contains(stringDate) {
            return 1
        } else if noteContent.keys.contains(stringDate) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,eventDefaultColorsFor date: Date) -> [UIColor]?
    {
        print("eventDefaultColorsFor called")
        let stringDate = dateFormatter.string(from: date)

        if todoItemDic.keys.contains(stringDate) && noteContent.keys.contains(stringDate) {
            
            return [UIColor.darkGray, UIColor.systemGray4]
        } else if todoItemDic.keys.contains(stringDate) {
            return [UIColor.systemGray4]
        } else if noteContent.keys.contains(stringDate) {
            return [UIColor.darkGray]
        } else {
            return [UIColor.clear]
        }

    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let stringDate = dateFormatter.string(from: date)

        if todoItemDic.keys.contains(stringDate) && noteContent.keys.contains(stringDate) {
            
            return [UIColor.darkGray, UIColor.systemGray4]
        } else if todoItemDic.keys.contains(stringDate) {
            return [UIColor.systemGray4]
        } else if noteContent.keys.contains(stringDate) {
            return [UIColor.darkGray]
        } else {
            return [UIColor.clear]
        }
    }
}
