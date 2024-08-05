//
//  MyWalletViewController.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import UIKit
import DatePickerDialog

class MyWalletViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitesLabeel: UILabel!
    @IBOutlet weak var makeAdButton: UIButton!
    @IBOutlet weak var withDrawButton: UIButton!
    @IBOutlet weak var earningValueLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var earningView: UIView!
    @IBOutlet weak var couponCodeButton: UIButton!
    
    private var myWalletViewModel: MyWalletViewModel = MyWalletViewModel()
    private var datePicker = DatePickerDialog()
    private var refreshControl = UIRefreshControl()
    private var isFilter: Bool = false
    private var year: String = ""
    private var month: String = ""
    private var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = DatePickerDialog(font: UIFont(name: "DroidArabicKufi-Bold", size: 12)!, locale: Locale(identifier:  Helper.appLanguage ?? "en" == "en" ?  "en" : "ar"), showCancelButton: true)
        localization()
        setupRefershControl()
        loadTransaction()
    }
    
    override func onClickButton() {
        print("retry")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
        getBalance()
        if HomeViewController.goToMyAds {
            HomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        } 
    }
    
    private func getBalance() {
        fetchBalance { error in
            if error == nil {
                self.earningValueLabel.text = "\(Helper.currentUser?.balance ?? 0)" + " " + "JOD".localiz()
            }
        }
    }
    
    private func setupRefershControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        refreshControl.endRefreshing()
        loadTransaction()
    }
    
    private func loadTransaction() {
        showLoading()
        getBalance()
        myWalletViewModel.getTransactions(page: page, isFilter: isFilter, year: year, month: month) {[weak self] (error) in
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
    
    
    @IBAction func AddAd(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    
    private func localization() {
        earningLabel.text = "Earning".localiz()
        activitesLabeel.text = "ACTIVITIES".localiz()
        withDrawButton.setTitle("Withdraw".localiz(), for: .normal)
        makeAdButton.setTitle("Make An Ad".localiz(), for: .normal)
        couponCodeButton.setTitle("Enter Coupon Code".localiz(), for: .normal)
        dateLabel.text = "Filter".localiz()
        tableView.register(TransactionCell.self)
        earningView.addShadow(position: .all)
    }
    
    @IBAction func EnterCopune(_ sender: Any) {
        let vc = self.initViewControllerWith(identifier: CouponViewController.className, and: "") as! CouponViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.confige { [weak self]  code in
            self?.showLoading()
            self?.myWalletViewModel.createCoupon(code: code) { [weak self] (error) in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                self?.showToast(message: "Coupon code has been entered successfully".localiz())
                self?.getBalance()
                vc.dismiss(animated: true, completion: nil)
            }
        } showArakService: {
            let arakService = self.initViewControllerWith(identifier: ArakServiceViewController.className, and: "Arak Service".localiz()) as! ArakServiceViewController
            self.show(arakService)
            vc.dismiss(animated: true, completion: nil)
            
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func WithDraw(_ sender: Any) {
        let vc = initViewControllerWith(identifier: WithDrawViewController.className, and: "Withdraw".localiz()) as! WithDrawViewController
        show(vc)
    }
    
    @IBAction func MakeAd(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    
    @IBAction func SelectDate(_ sender: Any) {
        datePicker.show("Select Date range".localiz()  ,
                        doneButtonTitle: "Done".localiz(),
                        cancelButtonTitle: "Cancel".localiz(),
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"
                let dateString = formatter.string(from: dt)
                self.dateLabel.text = dateString
                self.isFilter = true
                self.page = 1
                self.year = String(dateString.split(separator: "-")[0])
                self.month = String(dateString.split(separator: "-")[1])
                self.loadTransaction()
            }
        }
    }
}

extension MyWalletViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(transaction: myWalletViewModel.item(at: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myWalletViewModel.itemCount == 0 ?  self.tableView.setEmptyView(onClickButton: {
            self.loadTransaction()
        }) : self.tableView.restore()
        return myWalletViewModel.itemCount
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if myWalletViewModel.hasMore && myWalletViewModel.itemCount - 1 == indexPath.row {
            page += 1
            loadTransaction()
        }
    }
}
