//
//  SortedViewController.swift
//  travelExpenses
//
//  Created by osa on 04.08.2021.
//

import UIKit

struct Sort: Codable {
    let sortIncomeBy: String
    let sortExpenseBy: String
    let sortDirection: Bool
}

class SortedViewController: UIViewController {
    
    @IBOutlet weak var firstSegment: UISegmentedControl!
    @IBOutlet weak var secondSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }
    
    @IBAction func saveAction() {
        var sortIncomeBy = "date"
        var sortExpenseBy = "date"
        var sortDirection = true
        
        if firstSegment.selectedSegmentIndex == 1 {
            sortIncomeBy = "amount"
            sortExpenseBy = "convertedAmount"
        }
        
        if secondSegment.selectedSegmentIndex == 1 {
            sortDirection = false
        }
        
        let sort = Sort(sortIncomeBy: sortIncomeBy,
                        sortExpenseBy: sortExpenseBy,
                        sortDirection: sortDirection)
        UserDefaultsManager.shared.save(sort: sort)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initialize() {
        let currentSort = UserDefaultsManager.shared.fetchSort()
        
        if currentSort.sortIncomeBy == "date" {
            firstSegment.selectedSegmentIndex = 0
        } else {
            firstSegment.selectedSegmentIndex = 1
        }
        
        if currentSort.sortDirection {
            secondSegment.selectedSegmentIndex = 0
        } else {
            secondSegment.selectedSegmentIndex = 1
        }
    }
    
    
    @IBAction func firstSegment(_ sender: UISegmentedControl) {
    }
    
    @IBAction func secondSegment(_ sender: UISegmentedControl) {
    }
    
    
}

