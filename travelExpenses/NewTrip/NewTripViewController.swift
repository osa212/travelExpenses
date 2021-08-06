//
//  NewTripViewController.swift
//  report
//
//  Created by osa on 21.05.2021.
//

import SnapKit

protocol CountryDelegate {
    func sendCountry(country: String)
}

class NewTripViewController: UIViewController {

    let cityTF = Floating(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    let countryTF = Floating(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    let dateTF = Floating(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    var isDismissed: (() -> Void)?
    
    var viewModel: NewTripViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setup()
        setDatePicker()
        setEditingTrip()
        
        cityTF.delegate = self
        countryTF.delegate = self
        dateTF.delegate = self
    }
    
    deinit {
        print("new trip has been dealocated")
    }
    
    private func setEditingTrip() {
        if let editingTrip = viewModel.editingTrip {
            countryTF.text = editingTrip.country
            cityTF.text = editingTrip.city
            dateTF.text = viewModel.dateFormatToString(dateFormat: "yyyy/MM/dd",
                                                       date: editingTrip.date)
        }
    }
    
    // MARK: -  Interface
    private func setup() {
        let appColor = UIColor(red: 0/255,
                               green: 140/255,
                               blue: 255/255,
                               alpha: 1)
        let navBarAppearance = UINavigationBarAppearance()
        
        view.backgroundColor = .white
        
        navBarAppearance.backgroundColor = appColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        title = "Добавить"
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveData))
        navigationController?.navigationBar.tintColor = UIColor.white
        
        view.addSubview(countryTF)
        view.addSubview(cityTF)
        
        countryTF.placeholder = "Страна"
        countryTF._placeholder = "Страна"
        cityTF.placeholder = "Город"
        cityTF._placeholder = "Город"
        
        countryTF.snp.makeConstraints { maker in
            maker.top.equalTo(100)
            maker.left.equalTo(40)
            maker.height.equalTo(30)
        }
        
        cityTF.snp.makeConstraints { maker in
            maker.top.equalTo(countryTF.snp.bottom).offset(40)
            maker.left.equalTo(40)
            maker.height.equalTo(30)
        }
    }
    // MARK: -  Saving Data
    @objc private func saveData() {
        guard let newCountry = countryTF.text else { return }
        guard let newCity = cityTF.text else { return }
        guard let dateString = dateTF.text else { return }
        
        if newCountry.isEmpty {
            alert(title: "Не заполнено название страны",
                  message: "Пожалуйста, введите страну")
            return
        } else if newCity.isEmpty {
            alert(title: "Не заполнено название города",
                  message: "Пожалуйста, введите город")
            return
        } else if dateString.isEmpty {
            alert(title: "Не введена дата начала поездки",
                  message: "Пожалуйста, введите дату начала поездки")
            return
        }
        
        let dateFormat = viewModel.dateFormatToDate(dateFormat: "yyyy/MM/dd",
                                          dateString: dateString)
        guard let dateFormat = dateFormat else { return }
        
        if let editingTrip = viewModel.editingTrip {
            viewModel.editTrip(trip: editingTrip,
                               newCountry: newCountry,
                               newCity: newCity,
                               newDate: dateFormat)
            } else {
                viewModel.saveTrip(country: newCountry,
                                   city: newCity,
                                   date: dateFormat)
            }
        
        dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
    // MARK: -  TextField
extension NewTripViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == countryTF {
            textField.resignFirstResponder()
            cityTF.becomeFirstResponder()
        } else if textField == cityTF {
            textField.resignFirstResponder()
            dateTF.becomeFirstResponder()
        } else if textField == dateTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let countriesVC = CountriesTableViewController()
        
        if textField == countryTF {
            textField.endEditing(true)
            navigationController?.present(UINavigationController(rootViewController: countriesVC), animated: true, completion: nil)
            countriesVC.delegate = self
        }
    }
    
}
    // MARK: -  DatePicker
extension NewTripViewController {
    private func setDatePicker() {
        view.addSubview(dateTF)
        
        dateTF.placeholder = "Дата начала"
        dateTF._placeholder = "Дата начала"
        dateTF.snp.makeConstraints { maker in
            maker.top.equalTo(cityTF.snp.bottom).offset(40)
            maker.left.equalTo(40)
            maker.height.equalTo(30)
            maker.width.equalTo(300)
        }
        dateTF.datePicker(target: self,
                          doneAction: #selector(dateDoneAction),
                          cancelAction: #selector(dateCancelAction),
                          datePickerMode: .date)
    }
    
    @objc
    func dateCancelAction() {
        dateTF.resignFirstResponder()
    }

    @objc
    func dateDoneAction() {
        if let datePickerView = dateTF.inputView as? UIDatePicker {
            
            dateTF.text = viewModel.dateFormatToString(
                dateFormat: "yyyy/MM/dd",
                date: datePickerView.date
            )
            dateTF.resignFirstResponder()
        }
    }
}
    // MARK: -  Alert
extension NewTripViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
    // MARK: -  Country delegate
extension NewTripViewController: CountryDelegate {
    func sendCountry(country: String) {
        countryTF.text = country
    }
}
