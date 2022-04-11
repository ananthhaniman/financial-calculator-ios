//
//  LoansViewController.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-08.
//

import UIKit

class LoansViewController: UITableViewController {
    
    
    
    @IBOutlet weak var loanAmountTxt: UITextField!
    @IBOutlet weak var interestTxt: UITextField!
    @IBOutlet weak var monthlyPaymentTxt: UITextField!
    
    @IBOutlet weak var noOfPaymentsTxt: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentActiveTextField: UITextField?
    
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    
    private var saveKey = "loanForm"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self
        
        loanAmountTxt.delegate = self
        interestTxt.delegate = self
        monthlyPaymentTxt.delegate = self
        noOfPaymentsTxt.delegate = self
        
        loanAmountTxt.inputView = keyboardView
        interestTxt.inputView = keyboardView
        monthlyPaymentTxt.inputView = keyboardView
        noOfPaymentsTxt.inputView = keyboardView
        fetchLocalData()
        
    }
    
    // Change Payments methods Months to Years or Years to Months
    func toggleYearCell() {
        if paymentSegment.selectedSegmentIndex == 0 {
            timeLabel.text = "No of Payment"
            if !noOfPaymentsTxt.isEmpty(){
                let N = Double(noOfPaymentsTxt.text!)
                let value = N!*12
                noOfPaymentsTxt.text = String(value)
            }
        }else{
            timeLabel.text = "No of Years"
            if !noOfPaymentsTxt.isEmpty(){
                let N = Double(noOfPaymentsTxt.text!)
                let value = N!/12
                noOfPaymentsTxt.text = String(value)
            }
        }
        saveInputs()
    }
    
    
    @IBAction func onChangePaymentMethod(_ sender: UISegmentedControl) {
        toggleYearCell()
    }
    
    // Validate every fields
    func validate() {
        // if it's any text field is empty it will return 0 value
        let loanAmount:Double = loanAmountTxt.toDouble()
        let interest:Double = interestTxt.toDouble()
        let noOfPayments:Double = noOfPaymentsTxt.toDouble()
        let monthlyPayments:Double = monthlyPaymentTxt.toDouble()
        
        // find empty text field
        if let field:UITextField = findEmptyField() {
            calculate(LoanModel(loanAmount: loanAmount, interest: interest, monthlyPayment: monthlyPayments, noOfPayment: noOfPayments), field)
        }
    }
    
    
    func findEmptyField() -> UITextField? {
        
        var count = 0
        var field:UITextField?
        
        if !loanAmountTxt.isEmpty() {
            count += 1
        }else{
            field = loanAmountTxt
        }
        
        if !interestTxt.isEmpty() {
            count += 1
        }else{
            field = interestTxt
        }
        
        if !noOfPaymentsTxt.isEmpty() {
            count += 1
        }else{
            field = noOfPaymentsTxt
        }
        
        if !monthlyPaymentTxt.isEmpty() {
            count += 1
        }else{
            field = monthlyPaymentTxt
        }
        
        if count == 3 {
            return field
        }
        
        return nil
        
    }
    
    // find empty property and calculate value
    func calculate(_ data: LoanModel,_ field: UITextField) {
        let interestDivided = data.interest / 100
        var result:Double = 0
        let interestRate = interestDivided / 12
        var missingValue = 0.0
        
        if data.loanAmount == 0 {
            
            let PMT = data.monthlyPayment
            let I = data.interest / 100.0 / 12;
            let N = data.noOfPayment
            result = Double((PMT / I) * (1 - (1 / pow(1 + I, N))))
            
            field.text = String(format: "%.2f",result.rounded())
        }
        
        if data.interest == 0 {
            
            var x = 1 + (((data.monthlyPayment * data.noOfPayment / data.loanAmount) - 1) / 12)
            
            let financilaPrecision = Double(0.000001)
            
            func F(_ x: Double) -> Double {
                
                return Double(data.monthlyPayment * x * pow(1 + x, data.noOfPayment) / (pow(1+x, data.noOfPayment) - 1) - data.monthlyPayment);
                
            }
            
            func FPrime(_ x: Double) -> Double { // f'(x)
                let cDerivative = pow(x+1, data.noOfPayment)
                return Double(data.monthlyPayment * pow(x+1, data.noOfPayment-1) *
                              (x * cDerivative + cDerivative - (data.noOfPayment*x) - x - 1)) / pow(cDerivative - 1, 2)
                
            }
            
            while(abs(F(x)) > financilaPrecision) {
                x = x - F(x) / FPrime(x)
                
            }
            
            let R = Double(12 * x * 100)
            
            if R.isNaN || R.isInfinite || R < 0 {
                
                missingValue = 0.00;
                
            } else {
                
                
                missingValue = R
                
            }
            
            result = missingValue
            field.text = String(format: "%.1f",result)
            
        }
        
        if data.noOfPayment == 0 {
        
            let PMT = data.monthlyPayment
            let P = (data.monthlyPayment / interestRate) * (1 - (1 / pow(1 + interestRate, 1)))
            
            missingValue = P
            
            let minMonthlyPayment = missingValue - P
            if Int(PMT) <= Int(minMonthlyPayment) {
                print("error")
            }
            
            let PMT1 = data.monthlyPayment
            let P1 = data.loanAmount
            let I1 = interestRate
            let D1 = PMT1 / I1
            let N1 = (log(D1 / (D1 - P1)) / log(1 + I1))
  
            result = N1
            
            field.text = String(format: "%.f",result.rounded())
        }
        
        
        if data.monthlyPayment == 0 {
            
            
            let I = (data.interest / 100.0) / 12
            let PV = data.loanAmount
            let N = data.noOfPayment
            result = (PV * (I * pow(1 + I, N))) / (pow(1 + I, N) - 1)
            
            field.text = String(result.rounded())
        }
        
        saveInputs()
        
        
    }
    
    // Reset all text fields
    @IBAction func onPressReset(_ sender: UIBarButtonItem) {
        loanAmountTxt.text = ""
        interestTxt.text = ""
        noOfPaymentsTxt.text = ""
        monthlyPaymentTxt.text = ""
        saveInputs()
    }
    
    // Save all current state text fields inputs
    func saveInputs() {
        let store:DataLocalStore = DataLocalStore()
        let data = LoanModel(loanAmount: loanAmountTxt.toDouble(), interest: interestTxt.toDouble(), monthlyPayment: monthlyPaymentTxt.toDouble(), noOfPayment: noOfPaymentsTxt.toDouble(),isMonthlyPayments: paymentSegment.selectedSegmentIndex == 0)
        
        // convert object to json and save it
        if let encoded = try? JSONEncoder().encode(data) {
            store.saveForm(encoded,saveKey)
        }
        
    }
    
    // retrive saved text fields values
    func fetchLocalData() {
        let store:DataLocalStore = DataLocalStore()
        if let data = store.getForm(saveKey) {
            
            if let values = try? JSONDecoder().decode(LoanModel.self, from: data) {
                
                if values.loanAmount > 0 {
                    loanAmountTxt.text = String(values.loanAmount)
                }
                
                if values.interest > 0 {
                    interestTxt.text = String(values.interest)
                }
                
                if let payMethod = values.isMonthlyPayments {
                    paymentSegment.selectedSegmentIndex = payMethod ? 0 : 1
                }
                
                if values.noOfPayment > 0 {
                    noOfPaymentsTxt.text = String(values.noOfPayment)
                    
                }
                
                if values.monthlyPayment > 0 {
                    monthlyPaymentTxt.text = String(values.monthlyPayment)
                }
                
                
            }
        }
    }
    
    
}


// MARK: - Handle Keyboard events and Textfield events
extension LoansViewController: KeyboardViewDelegate,UITextFieldDelegate{
    func didPressNumber(_ number: String) {
        if currentActiveTextField != nil  {
            currentActiveTextField?.insertText(number)
        }
    }
    
    func didPressDelete() {
        if currentActiveTextField != nil  {
            currentActiveTextField?.deleteBackward()
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentActiveTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveInputs()
    }
    
    
    func didPressDone() {
        if currentActiveTextField != nil  {
            currentActiveTextField?.resignFirstResponder()
        }
        
        validate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    
    
}
