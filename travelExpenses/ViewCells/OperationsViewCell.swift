//
//  OperationsViewCell.swift
//  report
//
//  Created by osa on 26.07.2021.
//

import UIKit

class OperationsViewCell: UITableViewCell {
    let sumIncomeLabel = UILabel()
    let sumExpenseLabel = UILabel()
    
    var viewModel: OperationsCellViewModelProtocol! {
        
        didSet {
            var content = defaultContentConfiguration()
            content.secondaryTextProperties.color = .blue
            content.secondaryTextProperties.font = .boldSystemFont(ofSize: 16)
            
            content.text = viewModel.category
            content.secondaryText = viewModel.date
            
            self.addSubview(sumIncomeLabel)
            self.addSubview(sumExpenseLabel)
            
            sumIncomeLabel.snp.makeConstraints { make in
                make.right.equalTo(self.snp.right).inset(20)
                make.bottom.equalTo(self.snp.bottom)
                make.top.equalTo(self.snp.top)
            }
            
            sumExpenseLabel.snp.makeConstraints { make in
                make.right.equalTo(self.snp.right).inset(20)
                make.bottom.equalTo(self.snp.bottom)
                make.top.equalTo(self.snp.top)
            }
            
            sumIncomeLabel.text = viewModel.sum
            sumExpenseLabel.text = viewModel.sumExpense
            
            sumIncomeLabel.textColor = .systemGreen
            sumExpenseLabel.textColor = .red
            sumIncomeLabel.font = .boldSystemFont(ofSize: 16)
            sumExpenseLabel.font = .boldSystemFont(ofSize: 16)
            
            contentConfiguration = content
        }
    }
}
