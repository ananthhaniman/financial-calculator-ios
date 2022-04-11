//
//  SimpleSaveModel.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-09.
//

import Foundation

struct SimpleSaveModel: Codable {
    
    var principalAmount: Double
    var interest: Double
    var futureValue: Double
    var noofPayments: Double
    var isMonthlyPayments: Bool?
    
}
