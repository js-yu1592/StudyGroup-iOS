//
//  DetailViewController.swift
//  Todo
//
//  Created by 유준상 on 2021/02/13.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailCompleteBtn: UIButton!
    
    @IBOutlet weak var contentTF: UITextField!
    
    @IBOutlet weak var detailDateLabel: UILabel!
    
    var stringHolder: String = ""
    var detailDateString = ""
    var completeDelegate: CompleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad() called")
        
        detailCompleteBtn.tag = 2
        
        contentTF.text = stringHolder
        
        contentTF.delegate = self
        
        
        detailDateLabel.text = detailDateString
    }
    
    @IBAction func onCloseBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCompleteBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    
        completeDelegate?.onCompleteButtonClicked(noteData: contentTF.text!, sender: detailCompleteBtn)
    }
    
}

extension DetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let text = (contentTF.text! as NSString).replacingCharacters(in: range, with: string)
    if text.isEmpty {
        detailCompleteBtn.isEnabled = false
        detailCompleteBtn.alpha = 0.5
    } else {
        detailCompleteBtn.isEnabled = true
        detailCompleteBtn.alpha = 1.0
    }
     return true
    }
}
