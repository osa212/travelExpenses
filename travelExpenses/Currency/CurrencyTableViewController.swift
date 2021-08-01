//
//  CurrencyTableViewController.swift
//  report
//
//  Created by osa on 31.05.2021.
//

import UIKit

class CurrencyTableViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: CurrencyViewModelProtocol!
    
    var delegate: CurrencyDelegate!
    
    var isDismissed: (() -> Void)?
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel.fetchCurrency()
        setupSearchController()
    }

    deinit {
        print("currencies has been dealocated")
    }
    
    // MARK: -  Private methods
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.currencies.isEmpty {
            return isFiltering == true ? viewModel.filteredString.value.count : viewModel.currencyNames.count
        } else {
            return isFiltering == true ? viewModel.filteredCUR.value.count : viewModel.currencies.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        if viewModel.currencies.isEmpty {
            
            content.text = viewModel.currencyNames[indexPath.row]
            content.secondaryText = viewModel.currencyRussianNames[indexPath.row]
            
            if isFiltering == true {
                content.text = viewModel.filteredString.value[indexPath.row]
                content.secondaryText = ""
            }
            
        } else if !viewModel.currencies.isEmpty {
            content.text = viewModel.currencies[indexPath.row].CharCode
            content.secondaryText = viewModel.currencies[indexPath.row].Name
            
            if isFiltering == true {
                content.text = viewModel.filteredCUR.value[indexPath.row].CharCode
                content.secondaryText = viewModel.filteredCUR.value[indexPath.row].Name
            }
            
        }
        
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !viewModel.currencies.isEmpty {
            let choosenCurrency = isFiltering == true ? viewModel.filteredCUR.value[indexPath.row] : viewModel.currencies[indexPath.row]
            delegate.sendCurrency(currency: choosenCurrency)
            print(choosenCurrency)
        } else {
            let choosenCurrency = isFiltering == true ? viewModel.filteredString.value[indexPath.row] : viewModel.currencyNames[indexPath.row]
            
             delegate.sendStringCurrency(currency: choosenCurrency)
            print(choosenCurrency, "string")
        }
        searchController.isActive = false
        
        dismiss(animated: true) { [weak self] in
            self?.isDismissed?()
        }
    }
}

    // MARK: -  SearchResultsUpdating
extension CurrencyTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        if !viewModel.currencies.isEmpty {
            viewModel.filteredCUR.value = viewModel.currencies.filter { currency in
                guard let name = currency.CharCode else { fatalError() }
                return name.lowercased().contains(searchText.lowercased())
            }
            viewModel.filteredCUR.bind { [unowned self] _ in
                tableView.reloadData()
            }
        } else {
            viewModel.filteredString.value = viewModel.currencyNames.filter { name in
                return name.contains(searchText)
            }
            viewModel.filteredString.bind { [unowned self] _ in
                tableView.reloadData()
            }
        }
        tableView.reloadData()
    }
}
