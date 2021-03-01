//
//  NoteViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/03/01.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var note: Note?
    var completionBlock: (()->Void)?
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var completionButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
        titleLabel.title = formatter.string(from: Date())
    }
    
    func placeholderSetting() {
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.delegate = self
        if let note = note {
            textView.text = note.content
        } else {
            textView.text = "기억할 것을 메모해보세요."
            textView.textColor = UIColor.lightGray
            completionButtonOutlet.isEnabled = false
        }
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
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: UIBarButtonItem) {
        if let completionBlock = completionBlock {
            completionBlock()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
