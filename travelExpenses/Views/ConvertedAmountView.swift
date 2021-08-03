//
//  ConvertedAmountView.swift
//  travelExpenses
//
//  Created by osa on 02.08.2021.
//

import UIKit

class ConvertedAmountView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var isDismissed: (() -> Void)?
    var delegate: UserInputDelegate!

    @IBOutlet weak var amountTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amountTextField.becomeFirstResponder()

    }
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    private func setupUI() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(panGesture)
        
        amountTextField.placeholder = DataManager.shared.operationNames[4]
        amountTextField.inputAccessoryView = toolBar()
        amountTextField.resignFirstResponder()
        amountTextField.addBottomLine()
    }
    
    @objc func panAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1000 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 200)
                }
            }
        }
    }
}

    // MARK: -  ToolBar
extension ConvertedAmountView {
    func toolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(red: 0/255,
                                       green: 140/255,
                                       blue: 255/255,
                                       alpha: 1)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(tapDoneButton))
        let cancelButton = UIBarButtonItem(title: "Отмена",
                                           style: .plain,
                                           target: self,
                                           action: #selector(tapCancelButton))
        doneButton.tintColor = .white
        cancelButton.tintColor = .white
        
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func tapDoneButton() {
        if let amount = amountTextField.text {
            delegate.getConvertedAmount(amount: amount)
        }
        
        self.dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
    
    @objc func tapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

