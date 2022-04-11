//
//  KeyboardView.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-08.
//

import UIKit

class KeyboardView: UIView {

    var delegate: KeyboardViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        guard let view = loadNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    private func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "KeyboardView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    // MARK: - Handle Button Events
    @IBAction func onBtnPress(_ sender: UIButton) {
        if let value = sender.currentTitle {
            delegate?.didPressNumber(value)
            
        }
        
    }
    
    
    @IBAction func onDeletePress(_ sender: UIButton) {
        delegate?.didPressDelete()
    }
    
    @IBAction func onDonePress(_ sender: UIButton) {
        delegate?.didPressDone()
    }
    

}


extension UIButton{
    
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        layer.cornerRadius = 5
    }
    
}
