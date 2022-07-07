//
//  Ex_String.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/07.
//

import Foundation
import SnapKit

extension String {
    
    // 환전
    func USDToKRW() -> String {
        
        var rawDollar = self.components(separatedBy: ["$", "."]).joined()
        rawDollar.append("0")
        
        let changingDollar = Int(rawDollar)!
        
        let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
        
        var result = numberFormatter.string(from: NSNumber(value: changingDollar))!

        result.append("원")
        
        return result
    }
}
