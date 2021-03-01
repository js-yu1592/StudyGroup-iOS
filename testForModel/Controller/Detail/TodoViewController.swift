//
//  TodoViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import UIKit

class TodoViewController: UIViewController {
    
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let sendButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    let textFieldRightView: UIView = {
       let view = UIView()
        return view
    }()
    
    var completionHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        textFieldRightView.frame = CGRect(x: 0, y: 0, width: todoTextField.frame.size.width / 8, height: todoTextField.frame.height)
        sendButton.center.y = textFieldRightView.center.y
        sendButton.center.x = textFieldRightView.center.x
        textFieldRightView.addSubview(sendButton)
      
        todoTextField.rightViewMode = .always
        todoTextField.rightView = textFieldRightView
        
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        todoTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func sendButtonTapped() {
        print("TodoViewController - sendButtonTapped()")
        if let completionHandler = completionHandler {
            completionHandler()
        }
        
        todoTextField.text = nil
    }
    
    @objc func willShow(_ notification: NSNotification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let margin: CGFloat = view.safeAreaInsets.bottom
        bottomConstraint.constant = 0
       
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.bottomConstraint.constant = keyboardHeight - margin
            self.view.layoutIfNeeded()
        }
    }

    @objc func willHide(_ notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let margin: CGFloat = view.safeAreaInsets.bottom
        bottomConstraint.constant = keyboardHeight - margin
       
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dimmingButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
