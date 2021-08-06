//
//  TripsViewController.swift
//  report
//
//  Created by osa on 21.05.2021.
//

import UIKit

class TripsViewController: UITableViewController {

    var viewModel: TripsViewModelProtocol!
    
    private let cellID = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        viewModel = TripsViewModel()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    deinit {
        print("trips has been dealocated")
    }
    
    // MARK: -  Private methods
    private func initialize() {
        let appColor = UIColor(red: 0/255,
                           green: 140/255,
                           blue: 255/255,
                           alpha: 1)
        let NBAppearance = UINavigationBarAppearance()
        
        title = "Командировки"
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        NBAppearance.largeTitleTextAttributes = [.foregroundColor: appColor]
        NBAppearance.titleTextAttributes = [.foregroundColor: appColor]
        navigationController?.navigationBar.standardAppearance = NBAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = NBAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTrip))
        navigationController?.navigationBar.tintColor = appColor
                
        }
    
    @objc private func addNewTrip() {
        let newtripVC = NewTripViewController()
        newtripVC.viewModel = viewModel.newTripViewModel()
        navigationController?.present(UINavigationController(
                                        rootViewController: newtripVC),
                                        animated: true,
                                        completion: nil)
        
        newtripVC.isDismissed = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    private func editTrip(trip: Trip? = nil) {
        let newtripVC = NewTripViewController()
        if let trip = trip {
            newtripVC.viewModel = viewModel.newTripEditingViewModel(trip: trip)
        }
        
        navigationController?.present(UINavigationController(
                                        rootViewController: newtripVC),
                                        animated: true,
                                        completion: nil)
        
        newtripVC.isDismissed = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let mainImage = UIImageView()
        mainImage.image = UIImage(named: "CityTrafficSocialGraphic")
        headerView.addSubview(mainImage)
        mainImage.snp.makeConstraints { make in
            make.edges.equalTo(headerView)
        }
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.trips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath)
        cell.layer.cornerRadius = 20
        
        var content = cell.defaultContentConfiguration()
        
        let trip = viewModel.trips[indexPath.row]
        let dateString = viewModel.dateFormatToString(dateFormat: "dd/MM/yyyy",
                                                      date: trip.date)
        
        content.text = trip.city
        content.secondaryText = String(dateString)
        content.image = UIImage(data: viewModel.getImage(index: indexPath.row))
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        content.secondaryTextProperties.font = .italicSystemFont(ofSize: 14)
        content.textProperties.color = .darkGray
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expensesVC = OperationsViewController()

        expensesVC.viewModel = viewModel.expensesViewModel(indexPath: indexPath)
        navigationController?.pushViewController(expensesVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: -  TrailingSwipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trip = viewModel.trips[indexPath.row]
        
        let deleteAction = UIContextualAction(
            style: .normal,
            title: "Удалить"
        ) { [unowned self] _, _, _ in
            self.viewModel.deleteTrip(trip: trip)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Изменить"
        ) { [unowned self] _, _, isDone in
            self.editTrip(trip: trip)
            isDone(true)
        }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
