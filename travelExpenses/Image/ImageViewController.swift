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
    let cancelButton = UIButton()
    
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
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setButton() {
        view.addSubview(shareButton)
        view.addSubview(cancelButton)

        shareButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        shareButton.setImage(UIImage(
                                systemName: "square.and.arrow.up"),
                             for: .normal)
        shareButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(30)
            make.right.equalTo(view.snp.right).inset(30)
        }
        shareButton.contentVerticalAlignment = .fill
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        cancelButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        cancelButton.setImage(UIImage(
                                systemName: "multiply"),
                             for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(30)
            make.left.equalTo(view.snp.left).inset(30)
        }
        cancelButton.contentVerticalAlignment = .fill
        cancelButton.imageView?.contentMode = .scaleAspectFit
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
