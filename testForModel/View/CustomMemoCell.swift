//
//  CustomMemoCell.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit

class CustomMemoCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    
    var completionHandler: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(memo: Memo) {
        contentLabel.text = memo.content
        stateButton.setImage(UIImage(systemName: memo.STATEMEMO.stateString), for: .normal)
        stateButton.tintColor = memo.STATEMEMO.stateColor
    }
    
    @IBAction func stateButtonTapped(_ sender: UIButton) {
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    
}
