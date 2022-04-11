//
//  CompoundSaveModel.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-10.
//

import Foundation


struct CompoundSaveModel: Codable {
    
    var principalAmount: Double
    var interest: Double
    var futureValue: Double
    var noOfPayments: Double
    var monthlyPayments: Double
    var isMonthlyPayments: Bool?
    
}
