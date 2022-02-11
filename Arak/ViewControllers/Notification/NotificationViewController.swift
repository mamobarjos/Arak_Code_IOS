//
//  NotificationViewController.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//  
//

import UIKit
import Foundation
import ExpandableLabel
class NotificationViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    // MARK: - Properties
    
    
    var viewModel: NotificationViewModel = NotificationViewModel()
    var page = 1
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        setupUI()
    }
    
    // MARK: - Protected Methods
    private func setupUI() {
        tableView.register(NotificationCell.self)
        title = "Notifications".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotification()
    }
    
    @IBAction func NewAdd(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    func fetchNotification() {
        showLoading()
        viewModel.getNotifications(page: page) { [weak self] (error) in
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

extension NotificationViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notificationItemCount == 0 ?  self.tableView.setEmptyView(onClickButton: {
            self.fetchNotification()
        }) : self.tableView.restore()
        return viewModel.notificationItemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(notification: viewModel.notification(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.notificationItemCount - 1 && viewModel.hasPage {
            page += 1
            fetchNotification()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
