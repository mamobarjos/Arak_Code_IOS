//
//  MyAdsViewController.swift
//  Arak
//
//  Created by Abed Qassim on 10/06/2021.
//

import UIKit
import DatePickerDialog

class MyAdsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var datePicker = DatePickerDialog()
    
    private var selectIndex = -1
    private var page = 1
    private var homeViewModel = HomeViewModel()
    private var isFilter: Bool = false
    private var dateFrom: String = ""
    private var dateTo: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AdsDetailCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        dateLabel.text = "Filter".localiz()
        activitiesLabel.text = "ACTIVITIES".localiz()
        datePicker = DatePickerDialog(font: UIFont(name: "DroidArabicKufi-Bold", size: 12)!, locale: Locale(identifier:  Helper.appLanguage ?? "en" == "en" ?  "en" : "ar"), showCancelButton: true)
        fetchUserAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    @IBAction func SelectDate(_ sender: Any) {
        
        datePicker.show("Select Date range".localiz()  ,
                        doneButtonTitle: "Done".localiz(),
                        cancelButtonTitle: "Cancel".localiz(),
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: dt)
                let dateToString = formatter.string(from: Date.now)
                self.dateLabel.text = dateString
                self.isFilter = true
                self.dateFrom = dateString
                self.dateTo = dateToString
                self.page = 1
                self.fetchUserAds()
            }
        }
    }
    
    func fetchUserAds() {
        showLoading()
        homeViewModel.getUserAds(page: page,isFilter: isFilter, date_from: dateFrom, date_to: dateTo,search: "") {[weak self] (error) in
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

extension MyAdsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.itemCount == 0 ?  self.tableView.setEmptyView(onClickButton: {
        }) : self.tableView.restore()
        return homeViewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AdsDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.section = indexPath.row
        cell.detailView.isHidden = self.selectIndex != cell.section
        cell.setup(ads: homeViewModel.item(at: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == homeViewModel.itemCount - 1 && homeViewModel.hasMore {
            page += 1
            fetchUserAds()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let refreshAlert = UIAlertController(title: "Delete Ad".localiz(), message: "Would you like to delete this ad?".localiz(), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: { (action: UIAlertAction!) in
                if let urlList = self.homeViewModel.item(at: indexPath.row)?.adImages?.map({ $0.path ?? ""}) , urlList.count > 0 {
                    UploadMedia.deleteMedia(dataArray: urlList) {
                        self.deleteAd(by: indexPath.row)
                    }
                } else {
                    self.deleteAd(by: indexPath.row)
                }
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: { (action: UIAlertAction!) in
                refreshAlert.dismissViewController()
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    private func deleteAd(by index: Int) {
        self.showLoading()
        self.homeViewModel.deleteAd(adId: self.homeViewModel.item(at: index)?.id ?? -1) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            if  self?.homeViewModel.removeIte(at: index) ?? false {
                self?.tableView.reloadData()
            }
        }
    }
}

extension MyAdsViewController: AdsDetailViewDelegate {
    func toggleSection(header: AdsDetailCell, section: Int) {
        if section == selectIndex {
            selectIndex = -1
        } else {
            selectIndex = section
        }
        
        tableView.reloadData()
    }
}
