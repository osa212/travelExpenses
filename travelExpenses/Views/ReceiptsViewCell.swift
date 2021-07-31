//
//  ReceiptsViewCell.swift
//  report
//
//  Created by osa on 18.07.2021.
//

import UIKit

class ReceiptsViewCell: UICollectionViewCell {
    var viewModel: ReceiptsViewCellModelProtocol! {
        didSet {
            let imageView = UIImageView()
            self.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.bottom.equalTo(self.snp.bottom)
            }
            guard let image = viewModel.imageData else { return }
            imageView.image = UIImage(data: image)
        }
    }
}
