//
//  CardCellView.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-05.
//

import UIKit

class CardCellView: UIView {
    
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        setup()
    }
    
   
    
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 10
        
        
        if #available(iOS 13.0, *) {
            backgroundColor = .tertiarySystemGroupedBackground
        } else {
            backgroundColor = UIColor.init("#eee8d5")
            
        }
    
    }

    

}
