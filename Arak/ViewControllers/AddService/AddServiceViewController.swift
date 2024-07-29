//
//  AddServiceViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 07/03/2022.
//

import UIKit

class AddServiceViewController: UIViewController {

    enum ProductMode {
        case add
        case edit
    }

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!

    @IBOutlet weak var placeHolderImage: UIImageView!

    @IBOutlet weak var descTextField: UITextView!

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var discountPriceTextField: UITextField!
    
    private var imagePicker = UIImagePickerController()

    private(set) var imageData: Data?
    private(set) var uplaoadedImages: [String] = []
    private(set) var data: [String:Any]?

    public var mode: ProductMode = .add
    public var product: StoreProduct?
    public var relatedProduct: RelatedProducts?

    private var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var viewModel: CreateServiceViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavigation(isHidden: false)
    }
    private func setupUI() {

        descTextField.text = "placeHolder.Description".localiz()
        titleTextField.placeholder = "placeHolder.Title".localiz()
        priceTextField.placeholder = "placeHolder.Price".localiz()
        continueButton.setTitle("action.Continue".localiz(), for: .normal)

        descTextField.textColor = UIColor.lightGray
        descTextField.delegate = self
        descTextField.font = .font(for: .regular, size: 17)

        if mode == .edit {
            fillViewWithMyProduct()
        }

    }
    
    private func setupCollectionView() {
        let layout = CenteredCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Initialize the collection view with the layout
        collectionView.isPagingEnabled = false
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddedProductImageCollectionViewCell.self)
        collectionView.reloadData()
    }

    private func fillViewWithMyProduct() {
        if let product = product {
            titleTextField.text = product.name
            descTextField.text = product.desc
            priceTextField.text = "\(product.price ?? 0.0)"
        }

        if let relatedProduct = relatedProduct {
            titleTextField.text = relatedProduct.name
            descTextField.text = relatedProduct.desc
            priceTextField.text = "\(relatedProduct.price ?? 0.0)"
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: StoreViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func uploadImageAction(_ sender: Any) {
        fetchImage()
    }

    @IBAction func continueAction(_ sender: Any) {
        guard let content = getValidatedData() else {
            return
        }
        self.compliationUpload(content: content)
        
    }


    private func getValidatedData() -> [String:Any]? {
        guard let productName = titleTextField.text else {
            self.showToast(message: "error.Please Enter your Product Name".localiz())
            return nil
        }

        guard let desc = descTextField.text else {
            self.showToast(message: "error.Please Enter your Product Description".localiz())
            return nil
        }

        guard let price = priceTextField.text else {
            self.showToast(message: "error.Please Enter your Product Price".localiz())
            return nil
        }

        if images.isEmpty {
            self.showToast(message: "error.Please add Product Image".localiz())
            return nil
        }

        var data: [String: Any] = [
            "name":productName,
            "desc":desc,
            "price":price,
        ]
        
        
        
        return data
    }
}

 // MARK: - Text View Methods
extension AddServiceViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descTextField.textColor == UIColor.lightGray {
            descTextField.text = nil
            descTextField.textColor = UIColor.text
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descTextField.text.isEmpty {
            descTextField.text = "placeHolder.Description".localiz()
            descTextField.textColor = UIColor.lightGray
        }
    }
}

extension AddServiceViewController: UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell: AddedProductImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
          let item = images[indexPath.item]
          cell.imageView.image = item
          cell.onDeleteImage = { [weak self] productImage in
              self?.images.removeAll(where: {$0 == productImage})
          }
          return cell
      }
      
      // MARK: - UICollectionViewDelegateFlowLayout
      

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 72, height: 60)
      }
}

extension AddServiceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            images.append(image)
            
        } else if let image = info[.originalImage] as? UIImage {
            images.append(image)
        }
    }

    func fetchImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            print("Galeria Image")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        }
    }


    private func compliationUpload(content: [String : Any]) {
        let userId = Helper.currentUser?.id ?? -1
        showLoading()
        if userId != -1 {
            let id = "\(userId)"
            UploadMedia.saveImages(userId: id, imagesArray: images, completionHandler: { [weak self] url in
                    self?.uplaoadedImages = url
                var data = content
                
                for (index, string) in url.enumerated() {
                    data["files[\(index)][\(string)]"] = string
                }
                
                print(data)
                self?.viewModel.createService(data: data, completion: {  error in
                    defer {
                        self?.stopLoading()
                    }
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
                    let vc = self?.initViewControllerWith(identifier: CongretsStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! CongretsStoreViewController
                    vc.configure(for: .service)
                    self?.show(vc)
                })
            })
        } else {
            self.stopLoading()
        }
    }
}
