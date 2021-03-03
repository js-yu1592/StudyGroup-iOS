//
//  UpdateViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/26.
//

import UIKit
import UserNotifications

class UpdateViewController: UIViewController {

    var memo: Memo?
    var completionHandler: ((Date?)->Void)?
    var myDate: Date?
    var myState: Int64?
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()

    @IBOutlet weak var updateTextField: UITextField!
    @IBOutlet weak var updateDateButton: UIButton!
    @IBOutlet weak var updateStateButton: UIButton!
    @IBOutlet weak var updateAlarmSwitch: UISwitch!
    @IBOutlet weak var updateAlarmDatePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTextField.text = memo?.content
        updateDateButton.setTitle(formatter.string(for: memo?.date), for: .normal)
        updateStateButton.setImage(UIImage(systemName: (memo?.STATEMEMO.stateString)!), for: .normal)
        updateStateButton.tintColor = memo?.STATEMEMO.stateColor
        
        checkDataForSwitch()
        checkSwitchForDatePicker()
    }
    
    private func checkDataForSwitch(){
        // 메모의 알람 데이터 여부에 따른 알림스위치 온오프여부
        if memo?.alarmDate == nil {
            updateAlarmSwitch.isOn = false
        } else {
            updateAlarmSwitch.isOn = true
        }
    }
    
    private func checkSwitchForDatePicker(){
        // 알림스위치 온오프 여부에 따른 데이터픽커 사용가능여부
        if updateAlarmSwitch.isOn {
            updateAlarmDatePicker.isEnabled = true
            guard let memoAlarmDate = memo?.alarmDate else { return }
            updateAlarmDatePicker.date = memoAlarmDate
        } else {
            updateAlarmDatePicker.isEnabled = false
        }
    }
    
    
    @IBAction func updateAlarmSwitchTapped(_ sender: UISwitch) {
        if updateAlarmSwitch.isOn {
            updateAlarmDatePicker.isEnabled = true
        } else {
            let oldMemoAlarmDate = self.memo?.alarmDate
            let oldDateString = "id_\(String(describing: oldMemoAlarmDate))"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldDateString])
            updateAlarmDatePicker.isEnabled = false
            memo?.alarmDate = nil
        }
    }
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateDateButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "calendarVC") as? CalendarViewController else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.completionHandler = { date in
            self.myDate = date
            DispatchQueue.main.async {
                self.updateDateButton.setTitle(self.formatter.string(from: date), for: .normal)
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateStateButtonTapped(_ sender: UIButton) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "stateVC") as? StateViewController else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.completionHandler = { state in
            self.myState = state
            DispatchQueue.main.async {
                guard let statememo = StateMemo.init(rawValue: state) else { return }
                self.updateStateButton.setImage(UIImage(systemName: (statememo.stateString)), for: .normal)
                self.updateStateButton.tintColor = statememo.stateColor
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func completionButton(_ sender: UIBarButtonItem) {
        let oldMemoAlarmDate = self.memo?.alarmDate
        
        if updateAlarmSwitch.isOn {
            MemoManager.shared.updateMemo(memo: memo!, content: updateTextField.text, state: myState, alarmDate: updateAlarmDatePicker.date, newDate: myDate)
        } else {
            MemoManager.shared.updateMemo(memo: memo!, content: updateTextField.text, state: myState, newDate: myDate)
        }
       
        self.dismiss(animated: true) {
            if let completionHandler = self.completionHandler {
                completionHandler(oldMemoAlarmDate)
            }
        }
    }
    
    
    


}
