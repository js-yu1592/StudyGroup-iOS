//
//  ViewController + TableView.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func scrollToBottom(){
        let lastRowInLastSection = memoManager.memos.count - 1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: lastRowInLastSection, section: 1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableViewInitialUISetUp(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "NOTE"
        } else {
            return "MEMO"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return memoManager.memos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let note = noteManager.notes.last else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! CustomNoteCell
            cell.updateUI(note: note)
            return cell
        } else {
            let memo = memoManager.memos[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as! CustomMemoCell
            cell.updateUI(memo: memo)
            cell.completionHandler = {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "stateVC") as? StateViewController else { return }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.completionHandler = { state in
                    self.memoManager.updateMemo(memo: memo, state: state)
                    self.memoManager.memos = self.memoManager.readMemos(date: self.calendar.selectedDate!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.calendar.reloadData()
                    }
                }
                vc.completionHandlerDateAndState = { date, state in
                    self.memoManager.updateMemo(memo: memo, state: state, newDate: date)
                    self.memoManager.memos = self.memoManager.readMemos(date: self.calendar.selectedDate!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.calendar.reloadData()
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let date = self.calendar.selectedDate!
        let notes = self.noteManager.notes
        
        if indexPath.section == 0 {
            guard !notes.isEmpty else { return UISwipeActionsConfiguration(actions: [])}
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
                
                for note in notes {
                    self.noteManager.deleteNote(note: note)
                }
                self.noteManager.notes = self.noteManager.readNote(date: date)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
                let memo = self.memoManager.memos[indexPath.row]
                self.memoManager.deleteMemo(memo: memo)
                self.memoManager.memos = self.memoManager.readMemos(date: date)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let note = noteManager.notes.last else { return }
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "noteVC") as? NoteViewController else { return }
            vc.note = note
            vc.title = self.formatter.string(from: self.calendar.selectedDate!)
            vc.completionBlock = {
                self.noteManager.updateNote(note: note, content: vc.textView.text)
                self.noteManager.notes = self.noteManager.readNote(date: self.calendar.selectedDate!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        } else {
            let memo = memoManager.memos[indexPath.row]
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "updateVC") as? UpdateViewController else { return }
            vc.memo = memo
            vc.completionHandler = { oldMemoAlarmDate in
                // 나름 고유 identifier
                let selectDate = self.calendar.selectedDate!
                let oldDateString = "id_\(String(describing: oldMemoAlarmDate))"
                let newDateString = "id_\(String(describing: vc.memo?.alarmDate))"
                guard vc.updateAlarmSwitch.isOn else { return }
                print("alarm1")
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            if oldDateString != newDateString {
                                // 알림 제거하기 (첫 추가는 그냥 스킵, 수정시 이전 알림 제거)
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldDateString])
                                // 알림 추가하기 (첫 추가 및 수정시 새로운 알림 추가)
                                let content = UNMutableNotificationContent()
                                content.title = "TODAY'S MEMO"
                                content.body = vc.updateTextField.text ?? ""
                                content.sound = .default
                                // 로직상  memo.alarmDate nil 값이 들어오지 않음
                                let targetDate = vc.memo?.alarmDate
                                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate!), repeats: false)
                                let request = UNNotificationRequest(identifier: newDateString, content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request) { (error) in
                                    if let error = error {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }
                self.memoManager.memos = self.memoManager.readMemos(date: selectDate)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
}
