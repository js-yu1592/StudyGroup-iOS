//
//  ToDoViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/14.
//

import UIKit

class ToDoViewController: UIViewController, UITextFieldDelegate {
    
    var completionBlock : (()->Void)?
    
    @IBOutlet weak var todoTextField: UITextField!
    
    let addbutton : UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        rightButton()
        todoTextField.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        todoTextField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            self.todoTextField.frame.origin.y =
            self.view.frame.height - self.todoTextField.frame.height - keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.todoTextField.frame.origin.y = self.view.frame.height - self.todoTextField.frame.height
    }
  
    
    func rightButton() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.todoTextField.bounds.height))
        addbutton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        rightView.addSubview(addbutton)
        todoTextField.layer.masksToBounds = true
        todoTextField.roundCorners([.topLeft, .topRight], radius: 25)
        todoTextField.rightView = rightView
        todoTextField.rightViewMode = .always
        addbutton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
     
    }
    
    @objc func didTapAddButton(){
        // 테이블뷰 리로드 컴플리션 블럭
        if let completionBlock = completionBlock {
            completionBlock()
        }
        
        // nil로 초기화
        todoTextField.text = nil
      
    }
    
    @IBAction func dimmingButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
