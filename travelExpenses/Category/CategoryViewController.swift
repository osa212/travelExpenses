//
//  CategoryTableViewController.swift
//  report
//
//  Created by osa on 01.06.2021.
//

import UIKit

class CategoryTableViewController: UITableViewController {
 
    var isIncome: Bool?
    var delegate: CategoryDelegate!
    
    var viewModel: CategoryViewModelProtocol!
    
    var isDismissed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = CategoryViewModel()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    deinit {
        print("categories has been dealocated")
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        content.text = viewModel.categories[indexPath.row]

        let imageNames = DataManager.shared.categoriesImages
        content.image = UIImage(systemName: imageNames[indexPath.row])
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category = viewModel.categories[indexPath.row]
        delegate.sendCategory(category: category)
        
        dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
}
