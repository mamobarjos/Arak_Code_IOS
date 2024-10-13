//
//  AdsViewController.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//  
//

import UIKit
import Foundation


class AdsViewController: UIViewController {

    // MARK: - Outlets
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let inset: CGFloat = 15
    private let minimumLineSpacing: CGFloat = 10
    private let minimumInteritemSpacing: CGFloat = 10

    var viewModel: AdsViewModel = AdsViewModel()

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ads Type".localiz()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
      setupNavigation()
      fetchAds()
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      clearItemsBar()
    }

    private func setupNavigation() {
      //self.navigationController?.navigationBar.addShadow(position: .bottom)
    }

  override func rightTapped(itemBar: UIBarButtonItem) {
    if itemBar.tag == 1 {
      let vc = initViewControllerWith(identifier: SettingsViewController.className, and: "Settings".localiz()) as! SettingsViewController
      show(vc)
    }
  }
    // MARK: - Protected Methods
    private func setupUI() {
      collectionView.register(AdsTypeCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

  func fetchAds() {
   
    showLoading()
    viewModel.adsType { [weak self] (error) in

      defer {
        self?.stopLoading()
      }

      if error != nil {
        self?.showToast(message: error)
        return
      }
      self?.collectionView.reloadData()
    }
  }

}

extension AdsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.adsTypeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AdsTypeCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configeUI(adCategory: viewModel.itemType(at: indexPath.row))
        cell.onButtonAction = { [weak self] in
            guard let self else {return}
            let vc = self.initViewControllerWith(identifier: PackageViewController.className, and: "") as! PackageViewController

            vc.confige(adCategory:self.viewModel.itemType(at: indexPath.row))

            self.show(vc)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 2) - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
}
