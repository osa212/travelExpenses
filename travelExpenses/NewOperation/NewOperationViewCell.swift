//
//  NewOperationViewCell.swift
//  report
//
//  Created by osa on 29.07.2021.
//

import UIKit


class NewOperationViewCell: UITableViewCell {
    
    var viewModel: NewOperationCellViewModelProtocol! {
        
        didSet {
            let imageView = UIImageView()
            let textLabel = UILabel()
            
            self.addSubview(imageView)
            self.addSubview(textLabel)
            
            imageView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top).inset(15)
                make.left.equalTo(self.snp.left).inset(16)
                make.width.height.equalTo(30)
            }
            
            textLabel.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-20)
                make.top.equalTo(self.snp.top).inset(20)
            }
            imageView.image = UIImage(systemName: viewModel.image)
            imageView.tintColor = UIColor(red: 0/255,
                                          green: 140/255,
                                          blue: 255/255,
                                          alpha: 1)
            
            textLabel.textColor = .gray
            textLabel.text = viewModel.getText()
            
        }
    }
}
