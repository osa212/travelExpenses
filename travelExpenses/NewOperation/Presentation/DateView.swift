//
//  CurrencyView.swift
//  travelExpenses
//
//  Created by osa on 01.08.2021.
//

import UIKit

class DateView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var isDismissed: (() -> Void)?
    var delegate: UserInputDelegate!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
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

    // MARK: -  DatePicker
extension DateView {
    private func setDatePicker() {
        textField.datePicker(target: self,
                          doneAction: #selector(dateDoneAction),
                          cancelAction: #selector(dateCancelAction),
                          datePickerMode: .date)
    }

    @objc private func dateCancelAction() {
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func dateDoneAction() {
        if let datePickerView = textField.inputView as? UIDatePicker {
    
            textField.text = dateFormatToString(dateFormat: "dd/MM/yyyy",
                                                date: datePickerView.date)
        
            textField.resignFirstResponder()
            
            guard let date = textField.text else { return }
            delegate.getDate(date: date)
            
            self.dismiss(animated: true) { [weak self] in
                self?.isDismissed?()
            }
        }
    }
    
    func dateFormatToString(dateFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
