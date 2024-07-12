//
//  ArakServiceViewController.swift
//  Arak
//
//  Created by Abed Qassim on 13/06/2021.
//

import UIKit

class ArakServiceViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
    
    private var serviceViewModel = ServiceViewModel()
    private var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
      getService()
        tableView.rowHeight = UITableView.automaticDimension

      tableView.register(ServiceCell.self)
        title = "Arak Service".localiz()
    }
    
    private func getService() {
        showLoading()
        serviceViewModel.getServices(page: page)  { [weak self] (error) in
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            self?.tableView.reloadData()
        }
    }
    
}
extension ArakServiceViewController : UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    serviceViewModel.itemCount == 0 ?  self.tableView.setEmptyView(onClickButton: {
        self.getService()
    }) : self.tableView.restore()
    return serviceViewModel.itemCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:ServiceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
    cell.setup(service: serviceViewModel.item(at: indexPath.row ))
    return cell
  }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == serviceViewModel.itemCount - 1 && serviceViewModel.hasMore {
            page += 1
            getService()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
        let popUp = self.initViewControllerWith(identifier: ArakServiceDetailsPopUpViewController.className, and: "") as! ArakServiceDetailsPopUpViewController
        popUp.serviceDesc = serviceViewModel.item(at: indexPath.row ).desc
        popUp.onButtonAction = {[weak self] in
            popUp.dismiss(animated: false)
            let vc = self?.initViewControllerWith(identifier: ServicePopUpViewController.className, and: "") as! ServicePopUpViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.confige(serviceId: self?.serviceViewModel.item(at: indexPath.row).id ?? -1) {
                vc.dismiss(animated: true, completion: nil)
            }
            self?.present(vc, animated: true, completion: nil)
        }
        self.present(popUp, modalPresentationStyle: .pageSheet)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
