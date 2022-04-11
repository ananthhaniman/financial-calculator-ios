//
//  UITextField+Validation.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-09.
//

import Foundation
import UIKit

extension UITextField{
    
    func isEmpty() -> Bool {
        return self.text!.count <= 0
    }
    
    
    func toDouble() -> Double {
        
        if isEmpty() {
            return 0
        }
        
        if let val = self.text {
            if let doubleVal = Double(val) {
                return doubleVal
            }
            return 0
        }
        return 0
    }
}
