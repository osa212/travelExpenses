//
//  TestViewController.swift
//  report
//
//  Created by osa on 21.05.2021.
//

import UIKit
import RealmSwift

class ReceiptsViewController: UICollectionViewController {

    var viewModel: ReceiptsViewModelProtocol!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ReceiptsViewModel()
        initialize()
        
        collectionView.register(ReceiptsViewCell.self,
                                forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder hasn't been implemented")
    }
    
    deinit {
        print("settings has been dealocated")
    }
    
    private func initialize() {
        title = viewModel.title
        collectionView.backgroundColor = .white
      
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.expenses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReceiptsViewCell
        
        cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = ImageViewController()
        imageVC.viewModel = viewModel.imageViewModel(indexPath: indexPath)
        imageVC.cellViewModel = viewModel.cellViewModel(indexPath: indexPath)
        present(imageVC, animated: true, completion: nil)
    }
}

// MARK: -  UICollectionViewDelegateFlowLayout
extension ReceiptsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (UIScreen.main.bounds.width - 10) / 2, height: (UIScreen.main.bounds.width - 10) / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    }
}
