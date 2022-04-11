//
//  SimpleSavingController.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-09.
//

import UIKit

class CompoundInterestViewController: UITableViewController {
    
    
    @IBOutlet weak var principalAmountTxt: UITextField!
    @IBOutlet weak var interestTxt: UITextField!
    @IBOutlet weak var futureValueTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    
    private var saveKey = "SimpleSaveForm"
    
    
    
    
    
    
    var currentActiveTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self
        
        principalAmountTxt.delegate = self
        interestTxt.delegate = self
        futureValueTxt.delegate = self
        timeTxt.delegate = self
        
        principalAmountTxt.inputView = keyboardView
        interestTxt.inputView = keyboardView
        futureValueTxt.inputView = keyboardView
        timeTxt.inputView = keyboardView
        fetchLocalData()
        
        
        
        
    }
    
    
    
    // Change Payments methods Months to Years or Years to Months
    func toggleYearCell() {
        if paymentSegment.selectedSegmentIndex == 0 {
            timeLabel.text = "No of Payment"
            if !timeTxt.isEmpty(){
                let N = Double(timeTxt.text!)
                let value = N!*12
                timeTxt.text = String(value)
            }
        }else{
            timeLabel.text = "No of Years"
            if !timeTxt.isEmpty(){
                let N = Double(timeTxt.text!)
                let value = N!/12
                timeTxt.text = String(value)
            }
        }
        saveInputs()
    }
    
    
    
    @IBAction func onChangePayment(_ sender: UISegmentedControl) {
        toggleYearCell()
    }
    
    
    // Validate every fields
    func validate() {
        // if it's any text field is empty it will return 0 value
        let principalAmount:Double = principalAmountTxt.toDouble()
        let interest:Double = interestTxt.toDouble()
        let futureValue:Double = futureValueTxt.toDouble()
        let noOfPayments:Double = timeTxt.toDouble()
        
        // find empty text field
        if let field:UITextField = findEmptyField() {
            calculate(SimpleSaveModel(principalAmount: principalAmount, interest: interest, futureValue: futureValue, noofPayments: noOfPayments), field)
        }
    }
    
    
    func findEmptyField() -> UITextField? {
        
        var count = 0
        var field:UITextField?
        
        if !principalAmountTxt.isEmpty() {
            count += 1
        }else{
            field = principalAmountTxt
        }
        
        if !interestTxt.isEmpty() {
            count += 1
        }else{
            field = interestTxt
        }
        
        if !futureValueTxt.isEmpty() {
            count += 1
        }else{
            field = futureValueTxt
        }
        
        if !timeTxt.isEmpty() {
            count += 1
        }else{
            field = timeTxt
        }
        
        if count == 3 {
            return field
        }
        
        return nil
        
    }
    
    
    
    // find empty property and calculate value
    func calculate(_ data: SimpleSaveModel,_ field: UITextField) {
        var result:Double = 0
        if data.principalAmount == 0 {
            let N = data.noofPayments
            let r = (data.interest / 100.0)
            let A = data.futureValue
            
            let second = pow(1+r/N, N*12)

            result = A/second
            field.text = String(format: "%.2f",result)
        }
        
        if data.interest == 0 {
            let N = data.noofPayments
            let P = data.principalAmount
            let A = data.futureValue
            
            result = N*(pow(A/P,1/N*12) - 1)
            
            field.text = String(format: "%.1f",result)
            
        }
        
        if data.noofPayments == 0 {
            let r = (data.interest / 100.0)
            let P = data.principalAmount
            let A = data.futureValue
            let CPY = 12.0
            result = Double(log(A / P) / (CPY * log(1 + (r / CPY))))
           
            field.text = String(format: "%.f",result)
        }
        
        if data.futureValue == 0 {
            let N = data.noofPayments
            let r = (data.interest / 100.0)
            let P = data.principalAmount
            result = P * pow(1+r/N, N*12)
            
            field.text = String(format: "%.f",result)
        }
        
        saveInputs()
        
        
    }
    
    
    
    
    // Reset all text fields
    @IBAction func onPressReset(_ sender: UIBarButtonItem) {
        principalAmountTxt.text = ""
        interestTxt.text = ""
        timeTxt.text = ""
        futureValueTxt.text = ""
        saveInputs()
    }
    
    // Save all current state text fields inputs
    func saveInputs() {
        let store:DataLocalStore = DataLocalStore()
        let data = SimpleSaveModel(principalAmount: principalAmountTxt.toDouble(), interest: interestTxt.toDouble(), futureValue: futureValueTxt.toDouble(), noofPayments: timeTxt.toDouble(),isMonthlyPayments: paymentSegment.selectedSegmentIndex == 0)
        
        // convert object to json and save it
        if let encoded = try? JSONEncoder().encode(data) {
            store.saveForm(encoded,saveKey)
        }
        
    }
    
    // retrive saved text fields values
    func fetchLocalData() {
        let store:DataLocalStore = DataLocalStore()
        if let data = store.getForm(saveKey) {
            
            if let values = try? JSONDecoder().decode(SimpleSaveModel.self, from: data) {
                
                if values.principalAmount > 0 {
                    principalAmountTxt.text = String(values.principalAmount)
                }
                
                if values.interest > 0 {
                    interestTxt.text = String(values.interest)
                }
                
                if let payMethod = values.isMonthlyPayments {
                    paymentSegment.selectedSegmentIndex = payMethod ? 0 : 1
                }
                
                if values.futureValue > 0 {
                    futureValueTxt.text = String(values.futureValue)
                }
                
                if values.noofPayments > 0 {
                    timeTxt.text = String(values.noofPayments)
                }
                
                
            }
        }
    }
    
}


// MARK: - Handle Keyboard events and Textfield events
extension CompoundInterestViewController: KeyboardViewDelegate,UITextFieldDelegate {
    
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
