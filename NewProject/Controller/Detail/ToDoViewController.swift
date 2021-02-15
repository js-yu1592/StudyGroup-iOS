//
//  ToDoViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/14.
//

import UIKit
import IQKeyboardManagerSwift

class ToDoViewController: UIViewController {
    
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
    
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        rightButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        todoTextField.becomeFirstResponder()
    }
  
    
    func rightButton() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.todoTextField.bounds.height))
        addbutton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        rightView.addSubview(addbutton)
        todoTextField.layer.masksToBounds = true
        todoTextField.roundCorners([.topLeft, .topRight], radius: 20)
        todoTextField.rightView = rightView
        todoTextField.rightViewMode = .always
        addbutton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
     
    }
    
    @objc func didTapAddButton(){
        // 데이터 처리 및 테이블뷰 리로드
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
