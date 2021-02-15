//
//  SettingsViewController.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/14.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") else { return UITableViewCell() }
        
        return cell
    }

}
