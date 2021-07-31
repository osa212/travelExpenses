//
//  NewOperationViewController.swift
//  report
//
//  Created by osa on 26.07.2021.
//

import UIKit



class NewOperationViewController: UITableViewController {

    var viewModel: NewOperationViewModelProtocol!
        
    private let segment = UISegmentedControl(items: ["Расход", "Поступление"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewOperationViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = .gray
        
        initialize()
    }
    
    

    private func initialize() {
        tableView.contentInset.top = 45
        
        let width = UIScreen.main.bounds.size.width
        
        view.backgroundColor = .white
        view.addSubview(segment)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor(red: 181/255,
                                          green: 216/255,
                                          blue: 228/255,
                                          alpha: 0.4)
        
        segment.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.width.equalTo(width)
            make.height.equalTo(45)
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewOperationViewCell

        cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let amountView = AmountView()
            amountView.modalPresentationStyle = .custom
            amountView.transitioningDelegate = self
            self.present(amountView, animated: true, completion: nil)
            
            amountView.delegate = NewOperationCellViewModel(indexPath: indexPath)
            
            amountView.isDismissed = {
                tableView.reloadData()
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    

}

extension NewOperationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        BottomSheetViewController(presentedViewController: presented,
                                  presenting: presenting)
    }
}

    
    

