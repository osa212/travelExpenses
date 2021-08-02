//
//  NewOperationViewController.swift
//  report
//
//  Created by osa on 26.07.2021.
//

import UIKit

    // MARK: -  Protocols
protocol UserInputDelegate {
    func getAmount(amount: String)
    func getDate(date: String)
    func getConvertedAmount(amount: String)
    func getPaymentMethod(method: String)
}

protocol CurrencyDelegate {
    func sendCurrency(currency: CurrencyName)
    func sendStringCurrency(currency: String)
}

protocol CategoryDelegate {
    func sendCategory(category: String)
}

    // MARK: -  NewOperationViewController
class NewOperationViewController: UITableViewController {

    var viewModel: NewOperationViewModelProtocol!
        
    private let segment = UISegmentedControl(items: ["Расход", "Поступление"])
    
    var userDate: String?
    var userAmount: String?
    var userCurrency: String?
    var convertedAmount: String?
    var choosenCategory: String?
    var paymentMethod: String?
    var fileName: String?
    
    let appColor = UIColor(red: 0/255,
                       green: 140/255,
                       blue: 255/255,
                       alpha: 1)
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewOperationViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = .gray
        
        initialize()
        setupTabBar()
        initializeEditing()
    }
    
    
    // MARK: -  Setup UI
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
    
    // MARK: -  Save Operation
    @objc func saveOperation() {
        
        switch title {
        case "Расход":
            if let image = imageView.image {
                fileName = savePng(image: image)
                guard let fileName = fileName else { return }
                viewModel.array[5] = fileName
            }
            
            viewModel.saveExpense(amount: viewModel.array[1],
                                  currency: viewModel.array[2],
                                  category: viewModel.array[3],
                                  date: viewModel.array[0],
                                  convertedAmount: viewModel.array[4],
                                  receipt: viewModel.array[5],
                                  method: viewModel.array[6],
                                  note: "")
        default:
            viewModel.saveIncome(amount: viewModel.array[1],
                                 currency: viewModel.array[2],
                                 category: viewModel.array[3],
                                 date: viewModel.array[0])
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
    
    private func initializeEditing() {
        if let editingIncome = viewModel.income {
            userAmount = "\(editingIncome.amount)"
            let date = viewModel.dateFormatToString(dateFormat: "dd/MM/yyyy",
                                                    date: editingIncome.date)
            userDate = "\(date)"
            
            viewModel.array[0] = "\(date)"
            viewModel.array[1] = "\(editingIncome.amount)"
            viewModel.array[2] = "\(editingIncome.currency)"
            viewModel.array[3] = "\(editingIncome.category)"
            segment.selectedSegmentIndex = 1
            segment.setEnabled(false, forSegmentAt: 0)
        } else if let editingExpense = viewModel.expense {
            userAmount = "\(editingExpense.amount)"
            let date = viewModel.dateFormatToString(dateFormat: "dd/MM/yyyy",
                                                    date: editingExpense.date)
            userDate = "\(date)"
            
            convertedAmount = "\(editingExpense.convertedAmount)"
            
            viewModel.array[0] = "\(date)"
            viewModel.array[1] = "\(editingExpense.amount)"
            viewModel.array[2] = "\(editingExpense.currency)"
            viewModel.array[3] = "\(editingExpense.category)"
            viewModel.array[4] = "\(editingExpense.convertedAmount)"
            viewModel.array[5] = "Фото чека"
            viewModel.array[6] = "\(editingExpense.paymentMethod)"
            segment.selectedSegmentIndex = 0
            segment.setEnabled(false, forSegmentAt: 1)

            let receiptImage = loadPng(fileName: editingExpense.receipt)
            imageView.image = receiptImage
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.selectedSegmentIndex {
        case 0: return viewModel.numberOfRowsExpenses
        default: return viewModel.numberOfRowsIncomes
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewOperationViewCell

        cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)

        cell.cellTextLabel.text = viewModel.array[indexPath.row]
        
        if indexPath.row == 5 {
            cell.addSubview(imageView)
            imageView.backgroundColor = .gray
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(59)
                make.right.equalTo(cell.snp.right).offset(-16)
                make.top.equalTo(cell.snp.top)
            }
            
        }
        
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
            
            if segment.selectedSegmentIndex == 1 {
                userCurrency = "RUB"
                viewModel.array[2] = "RUB"
            } else {
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
                
            }
            tableView.reloadData()
            
        case 3:
            let categoryVC = CategoryTableViewController()
            categoryVC.delegate = self
            self.present(categoryVC, animated: true, completion: nil)
            categoryVC.isDismissed = { [unowned self] in
                if let category = choosenCategory {
                    viewModel.array[3] = category
                }
                tableView.reloadData()
            }
            
        case 4:
            let convertedView = ConvertedAmountView()
            convertedView.modalPresentationStyle = .custom
            convertedView.transitioningDelegate = self
            
            self.present(convertedView, animated: true, completion: nil)
            
            if let convertedAmount = convertedAmount {
                convertedView.amountTextField.text = convertedAmount
            }
            convertedView.delegate = self
            
            convertedView.isDismissed = { [unowned self] in
                if let convertedAmount = convertedAmount {
                    viewModel.array[4] = convertedAmount
                }
                tableView.reloadData()
            }
            
        case 5:
            attachTapped()
        case 6:
            let methodView = PaymentMethodViewController()
            methodView.delegate = self
            self.present(methodView, animated: true, completion: nil)
            methodView.isDismissed = { [unowned self] in
                if let method = paymentMethod {
                    viewModel.array[6] = method
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

    
    // MARK: -  Delegates
extension NewOperationViewController: UserInputDelegate {
    func getPaymentMethod(method: String) {
        paymentMethod = method
    }
    
    func getConvertedAmount(amount: String) {
        convertedAmount = amount
    }
    
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

extension NewOperationViewController: CategoryDelegate {
    func sendCategory(category: String) {
        choosenCategory = category
    }
}

    // MARK: -  Picker Camera
extension NewOperationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        
    }
    
    private func attachTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let actionAlert = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(
                                        title: "Сделать фото",
                                        style: .default
        ) { [unowned self] action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(
                                          title: "Выбрать из библиотеки",
                                          style: .default
        ) { [unowned self] action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        actionAlert.addAction(photoAction)
        actionAlert.addAction(libraryAction)
        actionAlert.addAction(UIAlertAction(title: "Отмена",
                                            style: .cancel,
                                            handler: nil))
        
        if imageView.image != nil {
            let deleteAction = UIAlertAction(
                                             title: "Удалить фото",
                                             style: .destructive
            ) { [unowned self] action in
                self.imageView.image = nil
            }
            actionAlert.addAction(deleteAction)
        }
        
        if viewModel.expense != nil  {
            let showAction = UIAlertAction(
                title: "Открыть фото",
                style: .default) { [unowned self] action in
                openImage()
            }
            actionAlert.addAction(showAction)
        }
        
        present(actionAlert, animated: true, completion: nil)
    }
    
    // MARK: -  Open Image
    private func openImage() {

        let imageVC = ImageViewController()
        
        imageVC.viewModel = viewModel.imageViewModel()
        imageVC.cellViewModel = viewModel.receiptCellViewModel()
            
        present(imageVC, animated: true, completion: nil)
        
    }
    
    // MARK: -  Save image to Directory
    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths.first
    }
    
    func savePng(image: UIImage) -> String {
        let fileName = UUID().uuidString
        if let pngData = image.pngData(),
           let path = getDocumentsDirectory()?.appendingPathComponent(fileName)
        {
            try? pngData.write(to: path)
        }
        return fileName
    }
    
    func loadPng(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                       userDomainMask,
                                                       true)
        if let directoryPath = path.first {
            let imageUrl = URL(fileURLWithPath: directoryPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
