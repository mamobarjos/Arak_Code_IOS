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
  @IBOutlet weak var adsTableView: UITableView!
  @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!


    var viewModel: AdsViewModel = AdsViewModel()

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
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
      adsTableView.register(AdsTypeCell.self)
      bottomTableConstraint.constant = Helper.hasTopNotch ? -50 : -80
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
      self?.adsTableView.reloadData()
    }
  }

}
extension AdsViewController : UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.adsTypeCount == 0 ?  self.adsTableView.setEmptyView(onClickButton: {
        self.fetchAds()
    }) : self.adsTableView.restore()
    return viewModel.adsTypeCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:AdsTypeCell = adsTableView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configeUI(adCategory: viewModel.itemType(at: indexPath.row))
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    let vc = initViewControllerWith(identifier: PackageViewController.className, and: "") as! PackageViewController

    vc.confige(adCategory:viewModel.itemType(at: indexPath.row))

    show(vc)
  }

}
