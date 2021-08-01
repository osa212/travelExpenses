//
//  NewOperationViewController.swift
//  report
//
//  Created by osa on 26.07.2021.
//

import UIKit

protocol UserInputDelegate {
    func getAmount(amount: String)
    func getDate(date: String)
}

protocol CurrencyDelegate {
    func sendCurrency(currency: CurrencyName)
    func sendStringCurrency(currency: String)
}

class NewOperationViewController: UITableViewController {

    var viewModel: NewOperationViewModelProtocol!
        
    private let segment = UISegmentedControl(items: ["Расход", "Поступление"])
    
    var userDate: String?
    var userAmount: String?
    var userCurrency: String?
    var convertedAmount: String?
    
    let appColor = UIColor(red: 0/255,
                       green: 140/255,
                       blue: 255/255,
                       alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewOperationViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = .gray
        
        initialize()
        setupTabBar()
    }
    
    

    private func initialize() {
        tableView.contentInset.top = 45
        title = "Расход"
        let width = UIScreen.main.bounds.size.width
        
        view.backgroundColor = .white
        view.addSubview(segment)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor(red: 181/255,
                                          green: 216/255,
                                          blue: 228/255,
                                          alpha: 0.4)
        
        segment.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.width.equalTo(width)
            make.height.equalTo(45)
        }
        
        segment.addTarget(self,
                          action: (#selector(segmentTapped)),
                          for: .valueChanged)
    }
    
    private func setupTabBar() {
        navigationController?.isToolbarHidden = false
        let toolBar = UIToolbar()
        toolBar.tintColor = .black
        
        let saveButton = UIButton(type: .custom)
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.backgroundColor = .gray
        cancelButton.layer.cornerRadius = 15
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: UIControl.Event.touchUpInside)
        let barCancelButton = UIBarButtonItem(customView: cancelButton)
        
        let widthCancel = barCancelButton.customView?.widthAnchor.constraint(equalToConstant: 150)
        widthCancel?.isActive = true
        let heightCancel = barCancelButton.customView?.heightAnchor.constraint(equalToConstant: 35)
        heightCancel?.isActive = true
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = appColor
        saveButton.layer.cornerRadius = 15
        saveButton.addTarget(self, action: #selector(saveOperation), for: UIControl.Event.touchUpInside)
        let barSaveButton = UIBarButtonItem(customView: saveButton)
        
        let widthSave = barSaveButton.customView?.widthAnchor.constraint(equalToConstant: 150)
        widthSave?.isActive = true
        let heightSave = barSaveButton.customView?.heightAnchor.constraint(equalToConstant: 35)
        heightSave?.isActive = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        setToolbarItems([barCancelButton, flexibleSpace, barSaveButton],
                        animated: true)
        
        view.addSubview(toolBar)
    }
    
    @objc func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveOperation() {
        guard let userAmount = userAmount else { return }
        
        switch title {
        case "Расход":
            viewModel.saveExpense(amount: userAmount, currency: "", category: "", date: "", convertedAmount: "", receipt: "", method: "", note: "")
        default:
            viewModel.saveIncome(amount: userAmount, currency: "", category: "", date: "")
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func segmentTapped(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            title = "Расход"
            tableView.reloadData()
        case 1:
            title = "Поступление"
            tableView.reloadData()
        default:
            break
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.selectedSegmentIndex {
        case 0:
            
            return viewModel.numberOfRowsExpenses
            
        default:
            
            return viewModel.numberOfRowsIncomes
            
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewOperationViewCell

        cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)

        cell.cellTextLabel.text = viewModel.array[indexPath.row]
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let dateView = DateView()
            dateView.modalPresentationStyle = .custom
            dateView.transitioningDelegate = self
            
            self.present(dateView, animated: true, completion: nil)
            
            if let date = userDate {
                dateView.textField.text = date
            }
            dateView.delegate = self
            dateView.isDismissed = { [unowned self] in
                if let date = userDate {
                    viewModel.array[0] = date
                }
                tableView.reloadData()
            }
        case 1:
            let amountView = AmountView()
            amountView.modalPresentationStyle = .custom
            amountView.transitioningDelegate = self
            
            self.present(amountView, animated: true, completion: nil)
            
            if let amount = userAmount {
                amountView.textField.text = amount
            }
            amountView.delegate = self
            
            amountView.isDismissed = { [unowned self] in
                if let amount = userAmount {
                    viewModel.array[1] = amount
                }
                tableView.reloadData()
            }
            
        case 2:
            let currencyVC = CurrencyTableViewController()
            
            guard let date = userDate else { return }
            let dateToFetch = viewModel.dateStringToString(date: date)

            currencyVC.viewModel = viewModel.currencyViewModel(date: dateToFetch)
            currencyVC.delegate = self
            
            navigationController?.present(UINavigationController(
                                            rootViewController: currencyVC),
                                          animated: true,
                                          completion: nil)
            
            currencyVC.isDismissed = { [unowned self] in
                if let currency = userCurrency {
                    viewModel.array[2] = currency
                }
                if let convertedAmount = convertedAmount {
                    viewModel.array[4] = convertedAmount
                }
                tableView.reloadData()
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    

    

}

    // MARK: -  PresentationController
extension NewOperationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        BottomSheetViewController(presentedViewController: presented,
                                  presenting: presenting)
    }
}

    
    // MARK: -  UserInputDelegate
extension NewOperationViewController: UserInputDelegate {
    func getDate(date: String) {
        userDate = date
    }
    
    func getAmount(amount: String) {
        userAmount = amount
    }
    
}

extension NewOperationViewController: CurrencyDelegate {
    func sendStringCurrency(currency: String) {
        userCurrency = currency
    }
    
    
    func sendCurrency(currency: CurrencyName) {
        userCurrency = currency.CharCode
        guard let userAmount = userAmount else { return }

        if segment.selectedSegmentIndex == 0 && currency.CharCode != "RUB" {
            convertedAmount = viewModel.convert(currency: currency, amount: userAmount)[0]
        } else if segment.selectedSegmentIndex == 0 {
            convertedAmount = userAmount
        }
    }
}

    // MARK: -  DatePicker
extension NewOperationViewController {
    
}
