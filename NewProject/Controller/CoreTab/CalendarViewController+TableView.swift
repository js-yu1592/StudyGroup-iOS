//
//  CalendarViewController+TableView.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/18.
//

import UIKit

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - TableView DataSourse & Delegate
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 2))
//        sectionHeader.backgroundColor = .opaqueSeparator
//        return sectionHeader
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
   
    
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTalbeViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel?.text = sections[indexPath.section].cells.last?.content
            cell.backgroundColor = #colorLiteral(red: 0.9642801167, green: 0.9693287037, blue: 0.9693287037, alpha: 1)
            cell.statusButtonOutlet.setImage(UIImage(systemName: "doc.circle.fill"), for: .normal)
            cell.statusButtonOutlet.tintColor = .darkGray
            cell.statusButtonOutlet.backgroundColor = .clear
        } else {
            let target = sections[indexPath.section].cells[indexPath.row]
            cell.titleLabel?.text = target.content
            cell.statusButtonOutlet.setImage(UIImage(systemName: target.STATUSMEMO.statusString), for: .normal)
            cell.statusButtonOutlet.tintColor = target.STATUSMEMO.statusColor
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            cell.cellCompletionClosure = {
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: "popup") as? PopUpViewController else { return }
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                
                vc.completionHandlerForDate = { date in
                    target.date = date
                    try! self.context.save()
                    self.tableView.reloadSections([indexPath.section], with: .automatic)
                    self.calendar.reloadData()
                }
                
                vc.completionHandlerForStatus = { status in
                    target.status = status
                    try! self.context.save()
                    self.tableView.reloadSections([indexPath.section], with: .automatic)
                }
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let date = self.calendar.selectedDate!
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let target = self.sections[indexPath.section].cells
            if indexPath.section == 0 {
                for arr in target {
                    self.context.delete(arr)
                }
            } else {
                self.context.delete(target[indexPath.row])
            }
            
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
                self.sections[indexPath.section].cells.last?.date = dateString
                
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
    
    var cellCompletionClosure: (()->Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var statusButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        statusButtonOutlet.backgroundColor = .white
    }
    
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        if let cellCompletionClosure = self.cellCompletionClosure {
            cellCompletionClosure()
        }
    }
}

enum StatusMemo : Int64 {
    case incompletion
    case postpone
    case ongoing
    case completion
    case dafaultStatus
    
    var statusColor: UIColor {
        switch self {
        case .incompletion:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .postpone:
            return #colorLiteral(red: 0.8945541421, green: 0.6824823285, blue: 1, alpha: 1)
        case .ongoing:
            return #colorLiteral(red: 0.9764705896, green: 0.8496754634, blue: 0.7620139686, alpha: 1)
        case .completion:
            return #colorLiteral(red: 0.7429843822, green: 0.8851136387, blue: 0.9764705896, alpha: 1)
        case .dafaultStatus:
            return #colorLiteral(red: 0.7671154351, green: 0.8862745166, blue: 0.8110161144, alpha: 1)
        }
    }
    
    var statusString: String {
        switch self {
        case .incompletion:
            return "pause.circle.fill"
        case .postpone:
            return "arrowshape.turn.up.right.circle.fill"
        case .ongoing:
            return "infinity.circle.fill"
        case .completion:
            return "checkmark.circle.fill"
        case .dafaultStatus:
            return "paperplane.circle.fill"
        }
    }
}
