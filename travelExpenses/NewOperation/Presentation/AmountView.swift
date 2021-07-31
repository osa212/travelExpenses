//
//  AmountView.swift
//  report
//
//  Created by osa on 29.07.2021.
//

import UIKit

class AmountView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    
    var isDismissed: (() -> Void)?
    var delegate: UserInputDelegate!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        textField.placeholder = DataManager.shared.operationNames[0]
        textField.inputAccessoryView = toolBar()
        textField.resignFirstResponder()
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

extension AmountView {
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
        if let amount = textField.text {
            delegate.getAmount(amount: amount)
        }
        
        self.dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
    
    @objc func tapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
