//
//  CountriesTableViewController.swift
//  report
//
//  Created by osa on 30.06.2021.
//

import UIKit

class CountriesTableViewController: UITableViewController {

    var choosenCountry = ""
    var delegate: CountryDelegate!
    var viewModel: CountriesViewModelProtocol!
    
    private var seacrhBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !seacrhBarIsEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CountriesViewModel()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupSearch()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? viewModel.filteredCountries.value.count : viewModel.countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if isFiltering {
            cell.textLabel?.text = viewModel.filteredCountries.value[indexPath.row].name
        } else {
            cell.textLabel?.text = viewModel.countries[indexPath.row].name
        }
    
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            choosenCountry = viewModel.filteredCountries.value[indexPath.row].name
            dismiss(animated: true, completion: nil)
        } else {
            choosenCountry = viewModel.countries[indexPath.row].name
        }
        
        delegate.sendCountry(country: choosenCountry)
        dismiss(animated: true, completion: nil)
    }
}
    // MARK: -  SearchResult
extension CountriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
    }
    
    private func filterContent(searchText: String) {

        viewModel.filteredCountries.value = viewModel.countries.filter { country in
            return country.name.lowercased().contains(searchText.lowercased())
        }
        
        viewModel.filteredCountries.bind { [unowned self] _ in
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
