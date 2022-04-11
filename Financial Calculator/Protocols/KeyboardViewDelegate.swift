//
//  KeyboardViewDelegate.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-08.
//

import Foundation


protocol KeyboardViewDelegate{
    
    func didPressNumber(_ number: String)
    func didPressDelete()
    func didPressDone()
    
}
