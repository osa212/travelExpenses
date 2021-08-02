//
//  PaymentMethodViewController.swift
//  travelExpenses
//
//  Created by osa on 02.08.2021.
//

import UIKit

class PaymentMethodViewController: UITableViewController {

    var delegate: UserInputDelegate!
    var isDismissed: (() -> Void)?
    let methods = ["Оплачено наличными", "Оплачено картой"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return methods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = methods[indexPath.row]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getPaymentMethod(method: methods[indexPath.row])
        
        self.dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
}
