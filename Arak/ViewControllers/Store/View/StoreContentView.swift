//
//  StoreContentView.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit
import Cosmos

protocol StoreContentViewProtocol: AnyObject {
    func didTapOnProduct(id:Int)
    func didTapOnFav(id:Int)
    func didTapOnEdit(id: Int)
    func didTapViewAllProduct()
    func didTapOnAddProduct()
    func didTapOnBack()
    func submiteReview(_ message: String, _ rating: Int)
    func showTostMessage(with error: String)
    func deleteReview(id: Int)
}

class StoreContentView: UIView {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var addProductButtonContainerview: UIView!
    @IBOutlet weak var addProductButton: UIButton!
    
    //    @IBOutlet var contentView: UIView!

    @IBOutlet weak var descreptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var reviewrTableView: UITableView!
    @IBOutlet weak var productsStoreTiltleLabel: UILabel!
    @IBOutlet weak var reviewStoreTitleLabel: UILabel!
//    @IBOutlet weak var rateThisProviderTitleLabel: UILabel!
//    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var backButoon: UIButton!
//    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

//    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var faceButton: UIButton!
//    @IBOutlet weak var instaButton: UIButton!
//    @IBOutlet weak var twitterButton: UIButton!
//    @IBOutlet weak var linkedInButton: UIButton!
//    @IBOutlet weak var youTubeButton: UIButton!

    @IBOutlet weak var viewAllProductsButton: UIButton!
    @IBOutlet weak var seeAllReviewsButton: UIButton!
    @IBOutlet weak var viewAllReviewsStackView: UIStackView!
    @IBOutlet weak var viewAllProductsStackView: UIStackView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
//    @IBOutlet weak var reviewsContainerView: UIView!
//    @IBOutlet weak var addReviewContainer: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var addReviewButton: UIButton!
    //    @IBOutlet weak var reviewTextView: UITextView!

//    @IBOutlet weak var snabButton: UIButton!
//    @IBOutlet weak var addButton: UIButton!
//
//    @IBOutlet weak var viewAllProductAction: UILabel!

    private(set) var rating: Int?
    var products: [StoreProduct] = [] {
        didSet {
            productsTableView.reloadData()
            if products.isEmpty {
                heightConst.constant = 0
                viewAllProductsStackView.alpha = 0
                self.layoutIfNeeded()
            } else if products.count == 1 {
                heightConst.constant = 175
                viewAllProductsStackView.alpha = 1
                viewAllProductsButton.isHidden = true
                self.layoutIfNeeded()
            } else if products.count == 2 {
                heightConst.constant = 350
                viewAllProductsStackView.alpha = 1
                viewAllProductsButton.isHidden = true
                self.layoutIfNeeded()
            }
            if products.count > 3 {
                viewAllProductsStackView.alpha = 1
                viewAllProductsButton.isHidden = false
            } else {
                viewAllProductsButton.isHidden = true
            }
        }
    }

    var reviews: [ReviewResponse] = [] {
        didSet {
            if reviews.isEmpty {
                viewAllReviewsStackView.isHidden = true
                reviewrTableView.isHidden = true
            } else {
                viewAllReviewsStackView.isHidden = false
                reviewrTableView.isHidden = false
            }
            reviewrTableView.reloadData()
        }
    }

    var storeDetails: SingleStore? {
        didSet {
            guard let storeDetails = storeDetails else {
                return
            }
            self.updateUI(store: storeDetails)
        }
    }

    weak var delegate: StoreContentViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


     func setup() {
        guard let view = self.loadViewFromNip(nipName: "StroreContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)

         productsStoreTiltleLabel.text = "label.Products Store".localiz()
         reviewStoreTitleLabel.text = "label.Review".localiz()
         callButton.setTitle("Call".localiz(), for: .normal)
//         rateThisProviderTitleLabel.text = "label.Rate this service Provider".localiz()
//         submitButton.setTitle("action.Submit".localiz(), for: .normal)
//         reviewTextView.text = "placeHolder.Enter your review for this service provider...".localiz()

//         reviewTextView.textAlignment = Helper.appLanguage ?? "en" == "en" ? .left : .right
//         addButton.setTitle("action.Add Your Store".localiz(), for: .normal)
//         addButton.isHidden = true
//         reviewTextView.delegate = self
//         favButton.isHidden = true
//         backButoon.isHidden = true

         productsTableView.delegate = self
         productsTableView.dataSource = self
         productsTableView.rowHeight = 90
         productsTableView.estimatedRowHeight = 90
         productsTableView.register(ProductTableViewCell.self)
         productsTableView.separatorColor = .clear

         reviewrTableView.delegate = self
         reviewrTableView.dataSource = self
         reviewrTableView.rowHeight = 150
         reviewrTableView.estimatedRowHeight = 150
         reviewrTableView.separatorColor = .clear
         reviewrTableView.register(ReviewTableViewCell.self)
         cosmosView.rating = 0
         cosmosView.didFinishTouchingCosmos = { [weak self] rating in
             self?.rating = Int(rating)
         }

    }
    
    func makePhoneCall(to phoneNumber: String) {
        // Ensure the phone number is properly formatted
        let formattedPhoneNumber = phoneNumber.filter { "0123456789".contains($0) }
        
        // Create the URL with the tel scheme
        if let phoneURL = URL(string: "tel://\(formattedPhoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            // Open the URL to initiate the phone call
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            // Handle the error (e.g., device cannot make phone calls)
            print("Error: Cannot make phone call")
        }
    }

    @IBAction func addProductButtonAction(_ sender: Any) {
        delegate?.didTapOnAddProduct()
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        makePhoneCall(to: storeDetails?.phoneNo ?? "")
    }
    
    @IBAction func viewAllProductAction(_ sender: Any) {
        self.delegate?.didTapViewAllProduct()
    }
    
    @IBAction func addReviewButtonAction(_ sender: Any) {
        let vc = UIApplication.shared.topViewController?.initViewControllerWith(identifier: RateViewController.className, and: "", storyboardName: "Main") as! RateViewController
        vc.delegate = self
        UIApplication.shared.topViewController?.present(vc)
       
    }
    
    private func updateUI(store: SingleStore) {

//        if store.facebook == nil || store.facebook == "" {
//            faceButton.removeFromSuperview()
//        }
//
//        if store.twitter == nil || store.twitter == "" {
//            twitterButton.removeFromSuperview()
//        }
//
//        if store.snapchat == nil || store.snapchat == "" {
//            snabButton.removeFromSuperview()
//        }
//
//        if store.linkedin == nil || store.linkedin == "" {
//            linkedInButton.removeFromSuperview()
//        }
//
//        if store.youtube == nil || store.youtube == "" {
//            youTubeButton.removeFromSuperview()
//        }
//
//        if store.instagram == nil || store.instagram == "" {
//            instaButton.removeFromSuperview()
//        }

//        [faceButton, instaButton, youTubeButton, instaButton, twitterButton, linkedInButton].forEach {
//            $0?.layer.cornerRadius = ($0?.frameWidth ?? 17) / 2
//            $0?.clipsToBounds = true
//        }
        if let url = URL(string:store.img ?? "") {
            self.storeImageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }
        
        if Helper.currentUser?.id == store.userid {
            editButton.isHidden = false
            addProductButtonContainerview.isHidden = false
        } else {
            editButton.isHidden = true
            addProductButtonContainerview.isHidden = true
        }
        addProductButton.setTitle("Add Product".localiz(), for: .normal)
        backgroundImage.getAlamofireImage(urlString: store.cover ?? "")
        cosmosView.rating = store.totalRates ?? 0
        rateLabel.text = String(format: "%.2f", store.totalRates ?? 0.0)
        storeImageView.contentMode = .scaleToFill
        storeImageView.layer.cornerRadius = 40
        storeImageView.clipsToBounds = true
        addReviewButton.isHidden = store.isReviewed == 0 ? false : true
        self.titleLabel.text = store.name
        if let index = (store.createdAt?.range(of: "T")?.lowerBound){
            let dateBeforeT = String(store.createdAt?.prefix(upTo: index) ?? "")
            self.subtitleLabel.text = "Member Since: \(dateBeforeT) "
        } else {
            self.subtitleLabel.text = ""
        }

        self.descreptionLabel.text = store.desc
    }

//
//    @IBAction func submiteReviewAction(_ sender: Any) {
//        if reviewTextView.text == "placeHolder.Enter your review for this service provider...".localiz() || reviewTextView.text.isEmpty {
//            self.delegate?.showTostMessage(with: "error.please add your review".localiz())
//            return
//        }
//
//        guard let rating = rating else {
//            self.delegate?.showTostMessage(with: "error.please rate this store".localiz())
//            return
//        }
//
//        delegate?.submiteReview(reviewTextView.text, rating)
//    }
//
//    @IBAction func faceBookAction(_ sender: Any) {
//        guard let faceURL = storeDetails?.facebook else {
//            return
//        }
//        let faceUrl = NSURL(string: faceURL)
//        if UIApplication.shared.canOpenURL(faceUrl! as URL) {
//            UIApplication.shared.openURL(faceUrl! as URL)
//        } else {
//          //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: "https://web.facebook.com/")! as URL)
//        }
//    }
//
//    @IBAction func instaAction(_ sender: Any) {
//        guard let instaURL = storeDetails?.instagram else {
//            return
//        }
//        let instagramUrl = NSURL(string: instaURL)
//        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
//            UIApplication.shared.openURL(instagramUrl! as URL)
//        } else {
//          //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
//        }
//    }
    @IBAction func backAction(_ sender: Any) {
        delegate?.didTapOnBack()
    }
//
//    @IBAction func favAction(_ sender: Any) {
//        delegate?.didTapOnFav(id: 1)
//    }

    @IBAction func editAction(_ sender: Any) {
        delegate?.didTapOnEdit(id: self.storeDetails?.id ?? 0)
    }

//    @IBAction func twitterAction(_ sender: Any) {
//        guard let twitterURL = storeDetails?.twitter else {
//            return
//        }
//        let twitterUrl = NSURL(string: twitterURL)
//        if UIApplication.shared.canOpenURL(twitterUrl! as URL) {
//            UIApplication.shared.openURL(twitterUrl! as URL)
//        } else {
//          //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: "https://mobile.twitter.com/")! as URL)
//        }
//    }
//
//    @IBAction func linkedInAction(_ sender: Any) {
//        guard let instaURL = storeDetails?.linkedin else {
//            return
//        }
//        let instagramUrl = NSURL(string: instaURL)
//        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
//            UIApplication.shared.openURL(instagramUrl! as URL)
//        } else {
//          //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: "https://www.linkedin.com/")! as URL)
//        }
//    }
//
//    @IBAction func whatsAppAction(_ sender: Any) {
//        let urlWhats = "whatsapp://send?phone=\(self.storeDetails?.phoneNo ?? "")"
//          if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
//              if let whatsappURL = URL(string: urlString) {
//                  if UIApplication.shared.canOpenURL(whatsappURL){
//                      if #available(iOS 10.0, *) {
//                          UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
//                      } else {
//                          UIApplication.shared.openURL(whatsappURL)
//                      }
//                  }
//                  else {
//                      print("Install Whatsapp")
//                  }
//              }
//          }
//    }
//
//    @IBAction func youtubeAction(_ sender: Any) {
//        guard let instaURL = storeDetails?.youtube else {
//            return
//        }
//        let instagramUrl = NSURL(string: instaURL)
//        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
//            UIApplication.shared.openURL(instagramUrl! as URL)
//        } else {
//          //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: "https://www.youtube.com/")! as URL)
//        }
//    }
}

extension StoreContentView: RateViewControllerDelegate {
    func submiteReview(_ sender: RateViewController, context: String, rating: Double) {
        sender.dismiss(animated: true)
        delegate?.submiteReview(context, Int(rating))
    }
}

extension StoreContentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "placeHolder.Enter your review for this service provider...".localiz() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "placeHolder.Enter your review for this service provider...".localiz()
            textView.textColor = .lightGray
        }
    }
}

extension StoreContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productsTableView {
            if products.count < 4 {
                return products.count
            } else {
                return 3
            }

        } else {
            return reviews.count
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productsTableView {
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let product = products[indexPath.row]
            cell.customize(product: product)
            return cell
        } else {
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let review = reviews[indexPath.row]
            cell.cosumizeCell(review: review)
            cell.onDeleteAction = { [weak self] in
                self?.delegate?.deleteReview(id: review.id ?? 0)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == productsTableView {
        let product = products[indexPath.row]
        delegate?.didTapOnProduct(id: product.id)
        }
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    func loadViewFromNip(nipName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nip = UINib(nibName: nipName, bundle: bundle)
        return nip.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
