//
//  InterestsViewController.swift
//  KHR
//
//  Created by Reham Khalil on 22/07/2024.
//

import UIKit

class InterestsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var viewModel: SignUpViewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = "Interests".localiz()
        headerTitleLabel.text = "Choose Your interests".localiz()
        continueButton.setTitle("Continue".localiz(), for: .normal)
        getInterests()
        
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCategoryCollectionViewCell.self)
    }
    
    private func getInterests() {
        showLoading()
        viewModel.getIntrest {[weak self] error in
            defer {
                self?.stopLoading()
            }
            
            if error == nil {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func updateInterset() {
      
        let interesteIDs: [Int] = viewModel.categories.filter({$0.selected == true}).map { $0.id ?? 1 }
        
        if interesteIDs.isEmpty {
            showToast(message: "Please select at least one Category".localiz())
            return
        }
        
        showLoading()
        viewModel.updateUserIntrest(intrests: interesteIDs) { [weak self] error in
            defer {
                self?.stopLoading()
            }
            
            if error == nil {
                let vc = self?.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
                self?.show(vc)
            }
        }
    }
   
    
    @IBAction func nextButtonAction(_ sender: Any) {
        updateInterset()
    }
}

extension InterestsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCategoryCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item = viewModel.categories[indexPath.item]
        cell.setupCell(category: item)
        cell.onAction = { [weak self] in
            if item.selected == true {
                self?.viewModel.categories[indexPath.item].selected = false
            } else {
                self?.viewModel.categories[indexPath.item].selected = true
            }
           
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: collectionView.bounds.width / 3.2, height: 120)
    }
}
