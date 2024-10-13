//
//  AllReviewsViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 24/08/2024.
//

import UIKit

class AllReviewsViewController: UIViewController {
    
    enum ReviewsType {
        case store(Store?)
        case product(StoreProduct?)
        case Ad(Adverisment?)
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var storeViewModel: StoreViewModel = StoreViewModel()
    private var productViewModel = ProductViewModel()
    private var adViewModel = DetailViewModel()
    var reviewsType: ReviewsType = .store(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "label.Reviews".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
        tableView.separatorColor = .clear
        tableView.register(ReviewTableViewCell.self)
    }
    
    private func getStoreDetails() {
        switch reviewsType {
        case .store(let store):
            storeViewModel.getStore(stroeId: store?.id ?? 0, complition: {[weak self] error in
                defer {
                    self?.stopLoading()
                }
                
                if let error = error {
                    self?.showToast(message: error)
                }
                
                if let storeDetails = self?.storeViewModel.getStoreDetails() {
                    self?.reviewsType = .store(storeDetails)
                    self?.tableView.reloadData()
                }
            })
        case .product(let product):
            productViewModel.getProduct(productId: product?.id ?? 0, complition:  {[weak self] error in
                defer {
                    self?.stopLoading()
                }
                
                if let error = error {
                    self?.showToast(message: error)
                }
                
                self?.reviewsType = .product(self?.productViewModel.getStoreProduct())
                self?.tableView.reloadData()
            })
            
            tableView.reloadData()
            
        case .Ad(let ad):
            adViewModel.adsDetail(id: ad?.id ?? 0) { [weak self] (error) in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                self?.reviewsType = .Ad(self?.adViewModel.ad)
                self?.tableView.reloadData()
            }
        }
       
    }
                                
    private func deleteReview(id: Int) {
        self.showLoading()
        
        switch reviewsType {
        case .store(let store):
            self.storeViewModel.deleteStoreReview(reviewId: id) { [weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                    return
                }

    //            self?.contentView.addReviewContainer.isHidden = false
                self?.showToast(message: "Review deleted successfully".localiz())
                self?.getStoreDetails()
            }
        case .product(let storeProduct):
            self.storeViewModel.deleteProductReview(reviewId: id) { [weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                    return
                }

    //            self?.contentView.addReviewContainer.isHidden = false
                self?.showToast(message: "Review deleted successfully".localiz())
                self?.getStoreDetails()
            }
        case .Ad(let ad):
            adViewModel.deleteReview(reviewId: ad?.id ?? 0) { [weak self] (error) in
                defer {
                    self?.stopLoading()
                }
                
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                
                self?.showToast(message: "Review deleted successfully".localiz())
                self?.getStoreDetails()
            }
        }
    }
}

extension AllReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        switch reviewsType {
        case .store(let store):
            if let review = store?.storeReviews?[indexPath.row] {
                cell.storeNameLabel.text = store?.name
                cell.cosumizeCell(review: review)
                cell.onDeleteAction = { [weak self] in
                    self?.deleteReview(id: review.id ?? 0)
                }
            }
        case .product(let product):
            if let review = product?.storeProductReviews?[indexPath.row] {
                cell.storeNameLabel.text = product?.store?.name
                cell.cosumizeCell(review: review)
                cell.onDeleteAction = { [weak self] in
                    self?.deleteReview(id: review.id ?? 0)
                }
            }
        case .Ad(let ad):
            if let review = ad?.reviews?[indexPath.row] {
                cell.storeNameLabel.text = ""
                cell.cosumizeCell(review: review)
                cell.onDeleteAction = { [weak self] in
                    self?.deleteReview(id: review.id ?? 0)
                }
            }
        }
        
        
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch reviewsType {
        case .store(let store):
            return store?.storeReviews?.count ?? 0
        case .product(let product):
            return product?.storeProductReviews?.count ?? 0
        case .Ad(let ad):
            return ad?.reviews?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

