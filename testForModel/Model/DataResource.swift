//
//  DataResource.swift
//  testForModel
//
//  Created by 박형석 on 2021/02/25.
//

import Foundation
import UIKit

struct Section {
    var title: String
}

enum StateMemo : Int64 {
    case incompletion
    case postpone
    case ongoing
    case completion
    case dafaultStatus
    
    var stateColor: UIColor {
        switch self {
        case .incompletion:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .postpone:
            return #colorLiteral(red: 0.8945541421, green: 0.6824823285, blue: 1, alpha: 1)
        case .ongoing:
            return #colorLiteral(red: 0.9764705896, green: 0.8496754634, blue: 0.7620139686, alpha: 1)
        case .completion:
            return #colorLiteral(red: 0.7429843822, green: 0.8851136387, blue: 0.9764705896, alpha: 1)
        case .dafaultStatus:
            return #colorLiteral(red: 0.7671154351, green: 0.8862745166, blue: 0.8110161144, alpha: 1)
        }
    }
    
    var stateString: String {
        switch self {
        case .incompletion:
            return "pause.circle.fill"
        case .postpone:
            return "arrowshape.turn.up.right.circle.fill"
        case .ongoing:
            return "infinity.circle.fill"
        case .completion:
            return "checkmark.circle.fill"
        case .dafaultStatus:
            return "paperplane.circle.fill"
        }
    }
}
