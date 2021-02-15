//
//  MemoViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/14.
//

import UIKit

class MemoViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var completionButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderSetting()
        titleLabel.title = DataManager.shared.formatter.string(from: Date())
       
        
        
    }
    
    
    func placeholderSetting() {
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.delegate = self
        textView.text = "기억할 것을 메모해보세요."
        textView.textColor = UIColor.lightGray
        completionButtonOutlet.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
        textView.text = "기억할 것을 메모해보세요."
        textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "기억할 것을 메모해보세요." || textView.text.isEmpty {
            completionButtonOutlet.isEnabled = false
            completionButtonOutlet.tintColor = .lightGray
        } else {
            completionButtonOutlet.isEnabled = true
            completionButtonOutlet.tintColor = .darkGray
        }
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButton(_ sender: Any) {
   
        
        var newText = ""
        newText = self.textView.text ?? ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
