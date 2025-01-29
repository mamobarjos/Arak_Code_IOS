//
//  PackageViewController.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit

class PackageViewController: UIViewController {

  @IBOutlet weak var packageCollectionView: UICollectionView!

    @IBOutlet weak var arakServicesLabel: UILabel!
    private let inset: CGFloat = 10
  private let minimumLineSpacing: CGFloat = 10
  private let minimumInteritemSpacing: CGFloat = 10
  private let cellsPerRow = 2
  private var packageList: [Package] = []
  private var adCategory:AdCategory?
    var viewModel: AdsViewModel = AdsViewModel()
  private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
      setupUI()
    }

  func confige(adCategory: AdCategory) {
    self.adCategory = adCategory
      showLoading()
      viewModel.getPackages(adCategoryId: adCategory.id ?? 1) {[weak self] error in
          defer {
              self?.stopLoading()
          }
          
          if error != nil {
              self?.showToast(message: error)
          }
          
          self?.packageList = self?.viewModel.packages ?? []
          self?.packageCollectionView.reloadData()
      }

  }

  // MARK: - Protected Methods
  private func setupUI() {
    arakServicesLabel.text = "Arak Service".localiz()
    arakServicesLabel.addTapGestureRecognizer {
        let vc = self.initViewControllerWith(identifier: ArakServiceViewController.className, and: "") as! ArakServiceViewController
        self.show(vc)
    }
    title = adCategory?.categoryTitle
    packageCollectionView.contentInsetAdjustmentBehavior = .always
    packageCollectionView.register(PackageCell.self)
    packageCollectionView.register(CustomCell.self)
   
  }

}
extension PackageViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return packageList.count
//    return packageList.count + 1 // for custom package
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if packageList.count == indexPath.row {
        let cell:CustomCell = packageCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup { [weak self] in
            guard let self = self else { return }
            let vc = self.initViewControllerWith(identifier: CustomPackageViewController.className, and: "") as! CustomPackageViewController
            vc.confige(adCategory: self.adCategory)
            self.show(vc)
        }
        return cell
    }
    let cell:PackageCell = packageCollectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.setup(package: packageList[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if packageList.count == indexPath.row {
        let vc = self.initViewControllerWith(identifier: CustomPackageViewController.className, and: "") as! CustomPackageViewController
        vc.confige(adCategory: self.adCategory)
        self.show(vc)
        return
    }
      
      if adCategory?.id == 4 {
          let vc = self.initViewControllerWith(identifier: CheckoutViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! CheckoutViewController
          Ad_category_id = 4
          Ad_package_id = packageList[indexPath.row].id ?? 0
          package_Price = packageList[indexPath.row].price ?? ""
          package_reach = packageList[indexPath.row].reach ?? 0
          
          self.show(vc)
      } else {
          let vc = initViewControllerWith(identifier: DetailAdsViewController.className, and: "") as! DetailAdsViewController
          vc.confige(adCategory: adCategory, packageSelect: packageList[indexPath.row])
          show(vc)
      }
  
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

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
          let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
          return CGSize(width: itemWidth, height: 165)
      }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            //packageCollectionView.collectionViewLayout.invalidateLayout()
            super.viewWillTransition(to: size, with: coordinator)
        }

}
