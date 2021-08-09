//
//  TripsViewController.swift
//  report
//
//  Created by osa on 21.05.2021.
//

import UIKit

class TripsViewController: UITableViewController {

    var viewModel: TripsViewModelProtocol!
    
    private var seacrhBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !seacrhBarIsEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let cellID = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        viewModel = TripsViewModel()
        initialize()
        setupSearch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
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

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.trips.isEmpty ? UIScreen.main.bounds.height - 100 : 0
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if viewModel.trips.isEmpty {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100))
            let beginImage = UIImageView()
            beginImage.image = UIImage(named: "beginImage")
            footerView.addSubview(beginImage)
            beginImage.contentMode = .scaleAspectFit
            beginImage.snp.makeConstraints { make in
                make.edges.equalTo(footerView)
            }
            return footerView
        } else {
            return UIView()
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? viewModel.filteredTrips.value.count : viewModel.trips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath)
        cell.layer.cornerRadius = 20
        
        var content = cell.defaultContentConfiguration()
        
        var trip = Trip()
        if isFiltering {
            trip = viewModel.filteredTrips.value[indexPath.row]
        } else {
            trip = viewModel.trips[indexPath.row]
        }
        
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
        let operationsVC = OperationsViewController()

        if isFiltering {
            operationsVC.viewModel = viewModel.expensesViewModelFilter(indexPath: indexPath)
        } else {
            operationsVC.viewModel = viewModel.expensesViewModel(indexPath: indexPath)
        }
        
        navigationController?.pushViewController(operationsVC, animated: true)
        
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

// MARK: -  SearchResult
extension TripsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
}

    private func filterContent(searchText: String) {

        viewModel.filteredTrips.value = viewModel.trips.filter({ trip in
            return trip.city.lowercased().contains(searchText.lowercased())
        })
        viewModel.filteredTrips.bind { [unowned self] _ in
            tableView.reloadData()
        }
}

    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
