//
//  ProductDetailsViewController.swift
//  Arak
//
//  Created by Reham Khalil on 21/08/2024.
//

import UIKit
import DropDown
import Cosmos

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTypeLabel: UIButton!
    @IBOutlet weak var sizeExpandeImage: UIButton!
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var colorTypeLabel: UIButton!
    @IBOutlet weak var colorExpandeImage: UIButton!
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var quantityTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    private var selectedVariant: ProductVariant?
    private var cartManage: CartManagerProtocol?
    var quantity: Int = 1
    let sizeViewDropDown = DropDown()
    let colorViewDropDown = DropDown()
    var products: ArakProduct?
    private var viewModel: ArakStoreViewModel = ArakStoreViewModel()
    deinit {
          NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
      }
    
    override func viewDidLoad() {
        cartManage = CartManager()
      
        super.viewDidLoad()
        setupCollectionView()
        setupDropDown()
        connectActions()
//        showLoading()
        self.title = "Product details".localiz()
        addToCartButton.setTitle("Add To Cart".localiz(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: .cartUpdated, object: nil)
        addBarItem(itemPostion: .Right, icon: #imageLiteral(resourceName: "cart_nav_new") ,isNotification:  true, isLogo: true ,tag: 2, badgeCount: 2, leftCount: 0)
        getVariants()
        setupUI()
        updateQuantityLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        setupUI()
    }
    
    override func rightTapped(itemBar: UIBarButtonItem) {
        if itemBar.tag == 2 {
           let vc = CartViewController.loadFromNib()
           show(vc)
       }
    }
    
    
    private func getVariants() {
        showLoading()
        viewModel.getStoreProductsVariants(productId: products?.id ?? 0) {[weak self] error in
            guard let self else {return}
            defer {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.stopLoading()
                })
            }
            
            if error != nil {
                self.showToast(message: error)
                return
            }
            
            self.setupDropDown()
            self.selectedVariant = self.viewModel.getProductVariants().first
            self.products?.selectedVariant = self.viewModel.getProductVariants().first
            
            self.quantity = cartManage?.getProductQuantity(withId:  self.products?.id ?? 0, variant:  self.selectedVariant) ?? 0
            if self.quantity == 0 {
                self.quantity = 1
            }
            self.quantityLabel.text = "\(self.quantity)"
            
        }
    }
    
    private func setupUI() {
       
        clearItemsBar()
        addBarItem(itemPostion: .Right, icon: #imageLiteral(resourceName: "cart_nav_new") ,isNotification:  true, isLogo: true ,tag: 2, badgeCount: 2, leftCount: 0)
        let totalPrice  = ((Double(products?.price ?? "0.0") ?? 0.0) * Double(quantity))
        priceLabel.text = String(format: "%.2f", totalPrice) + " " + (Helper.currencyCode ?? "JD")
    }
    
    private func fillData(){
        quantityTitleLabel.text = "Quantity:".localiz()
        priceTitleLabel.text = "Price:".localiz()
        productTitleLabel.text = products?.name
        let totalPrice  = ((Double(products?.price ?? "0.0") ?? 0.0) * Double(quantity))
        priceLabel.text = String(format: "%.2f", totalPrice) + " " + (Helper.currencyCode ?? "JD")
        ratingLabel.text = "[\(products?.averageRating ?? "5.0")]"
        cosmosView.rating = Double(products?.averageRating ?? "5") ?? 5
        if let htmlDescription = products?.description {
            if let data = htmlDescription.data(using: .utf8) {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                    descriptionLabel.text = attributedString.string
                } else {
                    descriptionLabel.text = "Invalid HTML content"
                }
            } else {
                descriptionLabel.text = "Invalid HTML encoding"
            }
        } else {
            descriptionLabel.text = "No description available"
        }

    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerCollectionViewCell.self)
    }
    
    private func connectActions(){
        minusButton.addTapGestureRecognizer {
            [weak self] in
            guard let self else {return}
            if self.quantity > 1 {
                self.quantity -= 1
                self.updateQuantityLabel()
                setupUI()
//                self.cartManage?.decreaseProductQuantity(product: self.products!, variant: selectedVariant)
            }
        }
        plusButton.addTapGestureRecognizer {
            [weak self] in
            guard let self else {return}
            self.quantity += 1
            setupUI()
            self.updateQuantityLabel()
//            self.cartManage?.increaseProductQuantity(product: self.products!, variant: selectedVariant)
        }
        
        [sizeView, sizeExpandeImage,sizeTypeLabel].forEach{
            $0?.addTapGestureRecognizer {
                [weak self] in
                
                self?.sizeViewDropDown.show()
            }
        }
        
        [colorView, colorExpandeImage,colorTypeLabel].forEach{
            $0?.addTapGestureRecognizer {
                [weak self] in
                self?.colorViewDropDown.show()
            }
        }
    }
    
    func updateQuantityLabel() {
          quantityLabel.text = "\(quantity)"
      }
    
    func setupDropDown() {
        let variants = viewModel.getProductVariants()
        colorLabel.isHidden = true
        colorTypeLabel.isHidden = true
        self.colorView.isHidden = true
        
        sizeLabel.text = "Choose Type:".localiz()
        sizeTypeLabel.setTitle(variants.map({$0.name ?? ""}).first, for: .normal)

        Helper.setupDropDown(dropDownBtn: self.sizeView, dropDown: sizeViewDropDown, stringsArr: variants.map({$0.name ?? ""})) {[weak self] index, item in
            guard let self else {return}
            self.sizeTypeLabel.setTitle(item, for: .normal)
            guard let selectedVariant = variants.first(where: {$0.name == item}) else {return}
            self.selectedVariant = selectedVariant
            self.products?.selectedVariant = selectedVariant
            self.quantity = self.cartManage?.getProductQuantity(withId: self.products?.id ?? 0, variant: selectedVariant) ?? 0
            self.quantityLabel.text = "\(self.quantity)"
        }
    }

    @IBAction func addToCartButton(_ sender: Any) {
        if quantity == 0 {
            showToast(message: "Please selecte the quantity".localiz())
            return
        }
        
        cartManage?.addProduct(self.products!, variant: selectedVariant, quantity: quantity)
        showToast(message: "Products add to cart".localiz())
        
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.bannerView.bannerArray = products?.images?.map({$0.src ?? ""}) ?? []
              return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 200)
    }
}
