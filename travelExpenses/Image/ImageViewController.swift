//
//  ImageViewController.swift
//  report
//
//  Created by osa on 05.07.2021.
//

import UIKit

class ImageViewController: UIViewController {
        
    var viewModel: ImageViewModelProtocol!
    var cellViewModel: ReceiptsViewCellModelProtocol!
    
    var imageScrollView: ImageScrollView!
    let shareButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setScrollView()
        setButton()
    }
    
    @objc func buttonTap() {
        guard let imageData = cellViewModel.imageData else { return }
        let image = UIImage(data: imageData)
        let imageShare = [image]
        let activityVC = UIActivityViewController(activityItems: imageShare as [Any],
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func setButton() {
        view.addSubview(shareButton)

        shareButton.setTitle("Отправить", for: .normal)
        shareButton.backgroundColor = .blue
        shareButton.layer.cornerRadius = 10
        shareButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        shareButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(20)
            make.right.equalTo(view.snp.right).inset(16)
            make.width.equalTo(100)
        }
    }
    private func setScrollView() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.isUserInteractionEnabled = true
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        guard let imageData = cellViewModel.imageData else { return }
        guard let image = UIImage(data: imageData) else { return }
        imageScrollView.set(image: image)
    }
}
