//
//  SettingsTableViewController.swift
//  travelExpenses
//
//  Created by osa on 03.08.2021.
//

import UIKit
import StoreKit

class SettingsViewController: UITableViewController {

    var settings = ["Сортировка", "О приложении", "Оставить отзыв в App Store", "Написать в Telegram"]
    var images = ["arrow.up.arrow.down", "info.circle", "star.circle", "textbox"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Настройки"
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = settings[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        cell.imageView?.image = UIImage(systemName: images[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let sortedVC = SortedViewController()
            self.navigationController?.pushViewController(sortedVC, animated: true)
        }
        
        if indexPath.row == 1 {
            let descriptionVC = DescriptionViewController()
            self.navigationController?.pushViewController(descriptionVC, animated: true)
        }
        
        if indexPath.row == 2 {
            let rateUrl = "itms-apps://itunes.apple.com/app/1580210411?action=write-review"
            if UIApplication.shared.canOpenURL(URL.init(string: rateUrl)!) {
                UIApplication.shared.open(URL.init(string: rateUrl)!, options: [:], completionHandler: nil)
            }
        }
        
        if indexPath.row == 3 {
            guard let url = URL(string: "https://t.me/\("travel_exp")") else {
                NewTripViewController().alert(title: "❌", message: "Проверьте пожалуйста ваше интернет-соединение")
                return }
            UIApplication.shared.open(url)
        }
    }

}
