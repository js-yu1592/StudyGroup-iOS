//
//  PopUpViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/21.
//

import UIKit

class PopUpViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // MARK: -Property
    
    let backgoundImage : UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "image")
        view.alpha = 0.8
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgoundImage.frame = contentView.bounds
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 20
        contentView.addSubview(backgoundImage)

    }
    
    
    // MARK: -Button Action
    
    @IBAction func BackgroundButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func incompletionButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postponeButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ongoingButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    

}
