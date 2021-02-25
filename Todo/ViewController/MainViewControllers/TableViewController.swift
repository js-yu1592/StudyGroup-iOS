//
//  TableViewController.swift
//  Todo
//
//  Created by 유준상 on 2021/02/21.
//

import UIKit

// MARK:- UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if noteContentStatus() == false {
            return nil
        }
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 2))
        sectionHeader.layer.cornerRadius = 8
        
        sectionHeader.backgroundColor = .darkGray
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt : \(indexPath.row)")
        
        cellClickedIndex = indexPath.row
        if indexPath.section == 0 {
            let noteVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
            noteVC.stringHolder = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
            noteVC.noteDateString = clickedDateLabelString
            noteVC.completeDelegate = self
            self.present(noteVC, animated: true, completion: nil)
        } else {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.stringHolder = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
            detailVC.detailDateString = clickedDateLabelString
            detailVC.completeDelegate = self
            self.present(detailVC, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    
}

// MARK:- UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noteContentStatus() == true && todoItemDic[clickedDate] != nil {
            return [1,todoItemDic[clickedDate]!.count][section]
        } else if noteContentStatus() == false && todoItemDic[clickedDate] != nil {
            return [0,todoItemDic[clickedDate]!.count][section]
        } else if noteContentStatus() == true && todoItemDic[clickedDate] == nil {
            return [1,0][section]
        } else {
            return [0,0][section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell")!
            cell.textLabel?.text = noteContent[clickedDate]
            cell.textLabel?.numberOfLines = 0
            cell.layer.cornerRadius = 8
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
            cell.textLabel?.text = todoItemDic[clickedDate]![indexPath.row]
            cell.layer.cornerRadius = 8
            return cell
        }
    }
    
    
}

