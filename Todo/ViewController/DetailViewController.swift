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
    var stringHolder: String = ""
    var completeDelegate: CompleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad() called")
        
        detailCompleteBtn.tag = 2
        contentTF.text = stringHolder
    }
    
    @IBAction func onCloseBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCompleteBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    
        completeDelegate?.onCompleteButtonClicked(noteData: contentTF.text!, sender: detailCompleteBtn)
    }
    
}
