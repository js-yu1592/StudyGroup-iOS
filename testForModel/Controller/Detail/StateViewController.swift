//
//  StateViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/26.
//

import UIKit

class StateViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    var date: Date?
    var completionHandler: ((Int64)->Void)?
    var completionHandlerDateAndState: ((Date, Int64)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20
    }
    
    @IBAction func dimmingButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pauseState(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandler {
                completionHandler(StateMemo.incompletion.rawValue)
            }
        }
      
    }
    
    @IBAction func postponeState(_ sender: Any) {
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "calendarVC") as? CalendarViewController else { return }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.completionHandler2 = { date in
                if let completionHandlerDateAndState = self.completionHandlerDateAndState {
                    completionHandlerDateAndState(date, StateMemo.postpone.rawValue)
                }
            }
            pvc.present(vc, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func ongoingState(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandler {
                completionHandler(StateMemo.ongoing.rawValue)
            }
        }
    }
    
    @IBAction func completionState(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandler {
                completionHandler(StateMemo.completion.rawValue)
            }
        }
    }
    


}
