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
        backgroundColor = #colorLiteral(red: 0.9484953704, green: 0.9484953704, blue: 0.9484953704, alpha: 1)
    }
    
}
