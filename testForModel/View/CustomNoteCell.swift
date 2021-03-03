//
//  CustomNoteCell.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import Foundation
import UIKit

class CustomNoteCell: UITableViewCell {
    
    @IBOutlet weak var noteLabel: UILabel!
    
    let noteManager = NoteManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(note: Note){
        noteLabel.text = note.content
        backgroundView = UIImageView(image: UIImage(named: "gra"))
        backgroundView?.contentMode = .scaleAspectFill
        backgroundView?.alpha = 0.5
    }
    
}
