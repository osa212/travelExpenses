//
//  PaymentMethodViewController.swift
//  travelExpenses
//
//  Created by osa on 02.08.2021.
//

import UIKit

class PaymentMethodViewController: UITableViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var delegate: UserInputDelegate!
    var isDismissed: (() -> Void)?
    let methods = ["Наличными", "Картой"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(panGesture)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
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
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return methods.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let images = DataManager.shared.paymentImages
        cell.textLabel?.text = methods[indexPath.row]
        cell.imageView?.image = UIImage(systemName: images[indexPath.row])
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getPaymentMethod(method: methods[indexPath.row])
        
        self.dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
}
