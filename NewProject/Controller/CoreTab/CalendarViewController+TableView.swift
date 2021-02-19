//
//  CalendarViewController+TableView.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/18.
//

import UIKit

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSourse & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = memos[indexPath.row].content
        cell.detailTextLabel?.text = memos[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            let target = self.memos[indexPath.row]
            self.context.delete(target)
            
            do {
                try self.context.save()
            }
            catch {
                print("error : save")
            }
            
            self.fetchDateMemos(date: self.calendar.selectedDate!)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler) in
        
            let alert = UIAlertController(title: "수정하기", message: "수정할 내용을 넣어주세요.", preferredStyle: .alert)
            alert.addTextField()
            let textField = alert.textFields?[0]
            
            textField?.text = self.memos[indexPath.row].content
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                
                let date = self.calendar.selectedDate!
                let dateString = self.formatter.string(from: date)
                self.memos[indexPath.row].content = textField?.text
                self.memos[indexPath.row].date = "수정한 날짜 : \(dateString)"
                
                do {
                    try self.context.save()
                }
                catch {
                    print("update error")
                }
                
                self.fetchDateMemos(date: date)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
}
