//
//  floatingLabelTextField.swift
//  report
//
//  Created by osa on 26.05.2021.
//

import UIKit

// MARK: -  FloatingLabel and BottomLine
class Floating: UITextField {
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    
    var _placeholder: String?
    
    var floatingLabelColor: UIColor = UIColor(red: 0/255,
                                              green: 140/255,
                                              blue: 255/255,
                                              alpha: 1) {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    var activeBorderColor: UIColor = UIColor(red: 0/255,
                                             green: 140/255,
                                             blue: 255/255,
                                             alpha: 1)
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder
        
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder
        
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
        let bottomLine = CALayer()
        bottomLine.borderColor = UIColor(red: 181/255, green: 216/255, blue: 228/255, alpha: 1).cgColor
        bottomLine.borderWidth = 1
        self.borderStyle = .none
        bottomLine.frame = CGRect(x: 0,
                                  y: self.frame.size.height,
                                  width: self.frame.size.width,
                                  height: 1)
        self.layer.addSublayer(bottomLine)
        }
    
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(
                x: 0,
                y: 0,
                width: self.frame.size.width,
                height: self.floatingLabelHeight)
            
            self.layer.borderColor = self.activeBorderColor.cgColor
            self.addSubview(self.floatingLabel)
            
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor,
                                                       constant: -10).isActive = true
            self.placeholder = ""
        }
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach { $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
}
