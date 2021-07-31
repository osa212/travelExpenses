//
//  OperationsViewController.swift
//  report
//
//  Created by osa on 22.05.2021.
//

import SnapKit
import RealmSwift

class OperationsViewController: UITableViewController {
    
    var viewModel: OperationsViewModelProtocol!
    
    let appColor = UIColor(red: 0/255,
                       green: 140/255,
                       blue: 255/255,
                       alpha: 0.7)
    private let button = UIButton()
    private let segmentedControl = UISegmentedControl(items:
                                                        ["Получено",
                                                         "Потрачено",
                                                         "Баланс"])
    let incomeLabel = UILabel()
    let expenseLabel = UILabel()
    let balanceLabel = UILabel()
    
    private let cellID = "list"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(OperationsViewCell.self, forCellReuseIdentifier: cellID)
        swipeAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
        tableView.reloadData()
        getBalance()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button.removeFromSuperview()
    }
    deinit {
        print("expenses has been dealocated")
    }
    
    // MARK: -  Private methods
    private func initialize() {
        let navBarAppearance = UINavigationBarAppearance()
        let widthLabel = Int(view.frame.width / 3)
        title = viewModel.trip.city
        tableView.contentInset.top = 60
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(exportCSV))
        
        segmentedControl.frame = CGRect(x: 10, y: 150, width: 300, height: 40)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.backgroundColor = UIColor(red: 181/255,
                                                   green: 216/255,
                                                   blue: 228/255,
                                                   alpha: 0.4)

        view.addSubview(segmentedControl)
        view.addSubview(incomeLabel)
        view.addSubview(expenseLabel)
        view.addSubview(balanceLabel)

        for label in [incomeLabel, expenseLabel, balanceLabel] {
            label.textAlignment = .center
            label.backgroundColor = .black.withAlphaComponent(0.9)
            label.textColor = .white
        }


        segmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(incomeLabel.snp.top)
            make.left.equalTo(view.snp.left)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(35)
        }
        incomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.width.equalTo(widthLabel)
            make.height.equalTo(25)
        }
        expenseLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.top)
            make.left.equalTo(incomeLabel.snp.right)
            make.width.equalTo(widthLabel)
            make.height.equalTo(25)
        }
        balanceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.top)
            make.left.equalTo(expenseLabel.snp.right)
            make.width.equalTo(widthLabel)
            make.height.equalTo(25)
        }

        segmentedControl.addTarget(self,
                                   action: #selector(segmentChanged(_:)),
                                   for: UIControl.Event.valueChanged)

        navigationController?.navigationBar.standardAppearance = navBarAppearance

        button.setTitle("＋", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false

        if let window = UIApplication.shared.windows.first {
            window.addSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.bottom.equalTo(window.snp.bottom).inset(90)
                make.right.equalTo(window.snp.right).inset(20)
            }

        }

        button.addTarget(self, action: #selector(addButton), for: UIControl.Event.touchUpInside)
    }
    // MARK: -  Get Balance
    private func getBalance() {
        tableView.reloadData()

        incomeLabel.text = viewModel.incomeLabelText
        expenseLabel.text = viewModel.expenseLabelText
        balanceLabel.text = viewModel.balanceLabelText
    }

    // MARK: -  Export CSV
    
    @objc private func exportCSV() {
        if let path = viewModel.exportCSV() {
            let exportSheet = UIActivityViewController(activityItems: [path as Any],
                                                       applicationActivities: nil)
            self.present(exportSheet, animated: true, completion: nil)
        }
    }

    // MARK: -  Button "Add"
    @objc private func addButton() {
//        let newTransactionVC = NewTransactionViewController()
//        let navigationController = UINavigationController(
//                                        rootViewController: newTransactionVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//
//        newTransactionVC.viewModel = viewModel.NewTransactionViewModelNew(trip: viewModel.trip)
//        newTransactionVC.isDismissed = { [weak self] in
//            self?.tableView.reloadData()
//            self?.getBalance()
//        }
        let newOperationVC = NewOperationViewController()
        navigationController?.pushViewController(newOperationVC, animated: true)
        newOperationVC.viewModel = viewModel.NewOperationViewModelNew(trip: viewModel.trip)

    }
    // MARK: -  Edit methods
    private func swiping(indexPath: IndexPath,
                         segmentIndex: Int) -> [UIContextualAction] {

        let deleteAction = UIContextualAction(
            style: .normal,
            title: "Удалить")
        { [unowned self] _, _, _ in
            
            viewModel.deleteTransaction(indexPath: indexPath,
                                        segmentIndex: segmentIndex)

            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.getBalance()
                }

        let editAction = UIContextualAction(
            style: .normal,
            title: "Изменить",
            handler: { [unowned self] _, _, isDone in
            if segmentIndex == 0 {
                editIncome(indexPath: indexPath)
            } else if segmentIndex == 1 {
                editExpense(indexPath: indexPath)
            }
            self.getBalance()
            isDone(true)
        })
        return [deleteAction, editAction]
    }

    // MARK: -  Edit Income
    private func editIncome(indexPath: IndexPath) {
//        let newTransactionVC = NewTransactionViewController()
//        newTransactionVC.viewModel = viewModel.NewTransactionViewModelIncome(indexPath: indexPath)
//
//        let navigationController = UINavigationController(
//                                        rootViewController: newTransactionVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//
//        newTransactionVC.isDismissed = { [weak self] in
//            self?.tableView.reloadData()
//            self?.getBalance()
//        }
        
        let newOperationVC = NewOperationViewController()
        navigationController?.pushViewController(newOperationVC, animated: true)
        
        newOperationVC.viewModel = viewModel.NewOperationViewModelIncome(indexPath: indexPath)
    }
    // MARK: -  Edit Expense
    private func editExpense(indexPath: IndexPath) {
//        let newTransactionVC = NewTransactionViewController()
//        newTransactionVC.viewModel = viewModel.NewTransactionViewModelExpense(indexPath: indexPath)
//
//        let navigationController = UINavigationController(
//                                        rootViewController: newTransactionVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//
//        newTransactionVC.isDismissed = { [weak self] in
//            self?.tableView.reloadData()
//            self?.getBalance()
//        }
        let newOperationVC = NewOperationViewController()
        navigationController?.pushViewController(newOperationVC, animated: true)
        
        newOperationVC.viewModel = viewModel.NewOperationViewModelExpense(indexPath: indexPath)
    }
    // MARK: -  Swipes
    private func swipeAction() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(swipedRight))
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(swipedLeft))
        swipeRight.direction = .right
        swipeLeft.direction = .left
        tableView.addGestureRecognizer(swipeLeft)
        tableView.addGestureRecognizer(swipeRight)
    }
    
    @objc private func swipedRight() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.sendActions(for: .valueChanged)
        default:
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.sendActions(for: .valueChanged)
        }
    }
    @objc private func swipedLeft() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.sendActions(for: .valueChanged)
        case 1:
            segmentedControl.selectedSegmentIndex = 2
            segmentedControl.sendActions(for: .valueChanged)
        default:
            break
        }
    }
    // MARK: -  SegmentChanged
    @objc private func segmentChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
        case 1:
            tableView.reloadData()
        default:
            tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return 1
        case 1: return 1
        default: return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return viewModel.incomes.count
        case 1: return viewModel.expenses.count
        default: return section == 0 ? viewModel.incomes.count : viewModel.expenses.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
            case 0: return ""
            case 1: return ""
            default: return section == 0 ? "Получено" : "Потрачено"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        
        header?.textLabel?.font = UIFont(name: "Helvetica", size: 16)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath) as! OperationsViewCell

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if (viewModel.saveIncome(indexPath.row)) != nil {
                cell.viewModel = viewModel.OperationsCellViewModelIncome(indexPath: indexPath)
                cell.sumExpenseLabel.text = ""
            }
        case 1:
            if (viewModel.saveExpense(indexPath.row)) != nil {
                cell.viewModel = viewModel.OperationsCellViewModelExpense(indexPath: indexPath)
                cell.sumIncomeLabel.text = ""
            }
        default:
            switch indexPath.section {
            case 0:
                if (viewModel.saveIncome(indexPath.row)) != nil {
                    cell.viewModel = viewModel.OperationsCellViewModelIncome(indexPath: indexPath)
                    cell.sumExpenseLabel.text = ""
                    
                }
            default:
                if (viewModel.saveExpense(indexPath.row)) != nil {
                    cell.viewModel = viewModel.OperationsCellViewModelExpense(indexPath: indexPath)
                    cell.sumIncomeLabel.text = ""

                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editIncome(indexPath: indexPath)
        case 1:
            editExpense(indexPath: indexPath)
        default:
            if indexPath.section == 0 {
                editIncome(indexPath: indexPath)
            } else if indexPath.section == 1 {
                editExpense(indexPath: indexPath)
            }
        }
    }

    // MARK: -  TrailingSwipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var deleteAction = UIContextualAction()
        var editAction = UIContextualAction()

        if indexPath.row < viewModel.incomes.count && segmentedControl.selectedSegmentIndex == 0 {
            
            deleteAction = swiping(indexPath: indexPath, segmentIndex: 0)[0]
            editAction = swiping(indexPath: indexPath, segmentIndex: 0)[1]

        } else if indexPath.row < viewModel.expenses.count && segmentedControl.selectedSegmentIndex == 1 {

            deleteAction = swiping(indexPath: indexPath, segmentIndex: 1)[0]
            editAction = swiping(indexPath: indexPath, segmentIndex: 1)[1]

        } else if indexPath.row < viewModel.expenses.count || indexPath.row < viewModel.trip.incomes.count {
            if indexPath.section == 0 {
                deleteAction = swiping(indexPath: indexPath, segmentIndex: 0)[0]
                editAction = swiping(indexPath: indexPath, segmentIndex: 0)[1]

            } else {
                deleteAction = swiping(indexPath: indexPath, segmentIndex: 1)[0]
                editAction = swiping(indexPath: indexPath, segmentIndex: 1)[1]

           }
        }

        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
