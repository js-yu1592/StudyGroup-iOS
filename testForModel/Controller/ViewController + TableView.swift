//
//  ViewController + TableView.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableViewInitialUISetUp(){
        tableView.rowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return noteManager.notes.count
        } else {
            return memoManager.memos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let note = noteManager.notes[indexPath.row]
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
        if indexPath.section == 0 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
                let note = self.noteManager .notes[indexPath.row]
                self.noteManager.deleteNote(note: note)
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
            let note = noteManager.notes[indexPath.row]
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "noteVC") as? NoteViewController else { return }
            vc.note = note
            vc.completionBlock = {
                self.noteManager.updateNote(note: note, content: vc.textView.text)
                self.noteManager.notes = self.noteManager.readNote(date: self.calendar.selectedDate!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            present(vc, animated: true, completion: nil)
            
        } else {
            let memo = memoManager.memos[indexPath.row]
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "updateVC") as? UpdateViewController else { return }
            vc.memo = memo
            vc.completionHandler = {
                self.memoManager.memos = self.memoManager.readMemos(date: self.calendar.selectedDate!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
}
