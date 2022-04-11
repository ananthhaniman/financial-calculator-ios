//
//  LoanModel.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-08.
//

import Foundation


struct LoanModel: Codable{
    var loanAmount: Double
    var interest: Double
    var monthlyPayment: Double
    var noOfPayment: Double
    var isMonthlyPayments: Bool?
}
