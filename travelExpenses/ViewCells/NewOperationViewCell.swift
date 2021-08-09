//
//  NewOperationViewCell.swift
//  report
//
//  Created by osa on 29.07.2021.
//

import UIKit

class NewOperationViewCell: UITableViewCell {
    let cellImageView = UIImageView()
    let cellNameLabel = UILabel()
    let cellTextLabel = UILabel()
    
    var viewModel: NewOperationCellViewModelProtocol! {

        didSet {
            
            self.addSubview(cellImageView)
            self.addSubview(cellTextLabel)
            self.addSubview(cellNameLabel)

            cellImageView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top).inset(15)
                make.left.equalTo(self.snp.left).inset(16)
                make.width.height.equalTo(30)
            }
            
            cellNameLabel.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top).inset(20)
                make.left.equalTo(cellImageView.snp.right).inset(-10)
            }

            cellTextLabel.snp.makeConstraints { make in
                make.right.equalTo(self.snp.right).inset(20)
                make.top.equalTo(self.snp.top).inset(20)
            }
            cellImageView.image = UIImage(systemName: viewModel.image)
            cellImageView.tintColor = UIColor(red: 0/255,
                                          green: 140/255,
                                          blue: 255/255,
                                          alpha: 1)

            cellTextLabel.textColor = .black
            cellNameLabel.textColor = .darkGray

        }
    }
    
    
}
