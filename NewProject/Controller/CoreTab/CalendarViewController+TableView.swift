//
//  CalendarViewController+TableView.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/18.
//

import UIKit

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSourse & Delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 2))
        sectionHeader.backgroundColor = .darkGray
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2 // my custom height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return sections[section].cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTalbeViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel?.text = sections[indexPath.section].cells.last?.content
            cell.subtitleLabel?.text = sections[indexPath.section].cells.last?.date
            cell.myImage.image = UIImage(systemName: "doc.circle.fill")
        } else {
            cell.titleLabel?.text = sections[indexPath.section].cells[indexPath.row].content
            cell.subtitleLabel?.text = sections[indexPath.section].cells[indexPath.row].date
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let date = self.calendar.selectedDate!
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let target = self.sections[indexPath.section].cells[indexPath.row]
            self.context.delete(target)
           
            try! self.context.save()
           
            if indexPath.section == 0 {
                self.fetchDateMemos(date: date, isNote: true)
            } else {
                self.fetchDateMemos(date: date, isNote: false)
            }
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler) in
        
            let alert = UIAlertController(title: "수정하기", message: "수정할 내용을 넣어주세요.", preferredStyle: .alert)
            alert.addTextField()
            let textField = alert.textFields?[0]
            
            textField?.text = self.sections[indexPath.section].cells.last?.content
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                let dateString = self.formatter.string(from: date)
                self.sections[indexPath.section].cells.last?.content = textField?.text
                self.sections[indexPath.section].cells.last?.date = "수정한 날짜 : \(dateString)"
                
                try! self.context.save()
                
                if indexPath.section == 0 {
                    self.fetchDateMemos(date: date, isNote: true)
                } else {
                    self.fetchDateMemos(date: date, isNote: false)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
}

struct Section {
    var title: String
    var cells: [Memo] = []
}

class CustomTalbeViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .thin)
    }
}
