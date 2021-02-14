//
//  DataManager.swift
//  NewProject
//
//  Created by 박형석 on 2021/02/14.
// 가능하면 리마인더? https://www.youtube.com/watch?v=E6Cw5WLDe-U

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    // 이벤트 자료구조
    var eventsDic = [String:[String]]()
    
}
