//
//  Constants.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//

import Foundation
import UIKit

enum PlayBackSpeed: Float, CaseIterable {
    case speed1x =  1
    case speed1_5x = 1.5
    case speed2x = 2
    
    var title: String {
        return String(format: "%.2fx", rawValue).replacingOccurrences(of: ".00", with: "")
    }
    
    var next: PlayBackSpeed {
        let allCases = PlayBackSpeed.allCases
        guard let currentIndex = allCases.firstIndex(of: self) else { return .speed1x }
        let nextIndex = (currentIndex + 1) % allCases.count
        return allCases[nextIndex]
    }
}

let darkPurple = UIColor(red: 25/255, green: 0/255, blue: 50/255, alpha: 1.0)
