//
//  StoreContentView.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

protocol StoreContentViewProtocol: AnyObject {
    func didTapOnProduct(id:Int)
    func didTapOnFav(id:Int)
    func didTapOnEdit(id: Int)
    func didTapViewAllProduct()
    func didTapOnAddProduct()
    func didTapOnBack()
}

class StoreContentView: UIView {

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var reviewrTableView: UITableView!
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var descreptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var backButoon: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var youTubeButton: UIButton!

    @IBOutlet weak var reviewTextView: UITextView!

    @IBOutlet weak var snabButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var viewAllProductAction: UILabel!

    var products: [StoreProduct] = [] {
        didSet {
            productsTableView.reloadData()
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

         reviewTextView.delegate = self

         productsTableView.delegate = self
         productsTableView.dataSource = self
         productsTableView.rowHeight = UITableView.automaticDimension
         productsTableView.estimatedRowHeight = 150
         productsTableView.register(ProductTableViewCell.self)
         productsTableView.separatorColor = .clear

         reviewrTableView.delegate = self
         reviewrTableView.dataSource = self
         reviewrTableView.rowHeight = UITableView.automaticDimension
         reviewrTableView.estimatedRowHeight = 150
         reviewrTableView.separatorColor = .clear
         reviewrTableView.register(ReviewTableViewCell.self)
    }

    private func updateUI(store: SingleStore) {

        if store.facebook == nil {
            faceButton.removeFromSuperview()
        } else if store.twitter == nil {
            faceButton.removeFromSuperview()
        } else if store.snapchat == nil {
            faceButton.removeFromSuperview()
        } else if store.linkedin == nil {
            linkedInButton.removeFromSuperview()
        } else if store.youtube == nil {
            youTubeButton.removeFromSuperview()
        } else if store.instagram == nil {
            instaButton.removeFromSuperview()
        }

        [faceButton, instaButton, youTubeButton, instaButton, twitterButton, linkedInButton].forEach {
            $0?.layer.cornerRadius = ($0?.frameWidth ?? 17) / 2
            $0?.clipsToBounds = true
        }
        self.titleLabel.text = store.name
        self.subtitleLabel.text = store.website
        self.descreptionLabel.text = store.desc
    }

    @IBAction func AddProductAction(_ sender: Any) {
        delegate?.didTapOnAddProduct()
    }

    @IBAction func faceBookAction(_ sender: Any) {
        guard let faceURL = storeDetails?.facebook else {
            return
        }
        let faceUrl = NSURL(string: faceURL)
        if UIApplication.shared.canOpenURL(faceUrl! as URL) {
            UIApplication.shared.openURL(faceUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://web.facebook.com/")! as URL)
        }
    }

    @IBAction func instaAction(_ sender: Any) {
        guard let instaURL = storeDetails?.instagram else {
            return
        }
        let instagramUrl = NSURL(string: instaURL)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        delegate?.didTapOnBack()
    }

    @IBAction func favAction(_ sender: Any) {
        delegate?.didTapOnFav(id: 1)
    }

    @IBAction func editAction(_ sender: Any) {
        delegate?.didTapOnEdit(id: 1)
    }

    @IBAction func twitterAction(_ sender: Any) {
        guard let twitterURL = storeDetails?.twitter else {
            return
        }
        let twitterUrl = NSURL(string: twitterURL)
        if UIApplication.shared.canOpenURL(twitterUrl! as URL) {
            UIApplication.shared.openURL(twitterUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://mobile.twitter.com/")! as URL)
        }
    }

    @IBAction func linkedInAction(_ sender: Any) {
        guard let instaURL = storeDetails?.linkedin else {
            return
        }
        let instagramUrl = NSURL(string: instaURL)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://www.linkedin.com/")! as URL)
        }
    }

    @IBAction func whatsAppAction(_ sender: Any) {
        let urlWhats = "whatsapp://send?phone=\(self.storeDetails?.phoneNo ?? "")"
          if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
              if let whatsappURL = URL(string: urlString) {
                  if UIApplication.shared.canOpenURL(whatsappURL){
                      if #available(iOS 10.0, *) {
                          UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                      } else {
                          UIApplication.shared.openURL(whatsappURL)
                      }
                  }
                  else {
                      print("Install Whatsapp")
                  }
              }
          }
    }

    @IBAction func youtubeAction(_ sender: Any) {
        guard let instaURL = storeDetails?.youtube else {
            return
        }
        let instagramUrl = NSURL(string: instaURL)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://www.youtube.com/")! as URL)
        }
    }
}

extension StoreContentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your review for this service provider..." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "Enter your review for this service provider..."
            textView.textColor = .lightGray
        }
    }
}

extension StoreContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productsTableView {
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let product = products[indexPath.row]
            cell.customize(product: product)
            return cell
        } else {
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setup()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        delegate?.didTapOnProduct(id: product.id)
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
