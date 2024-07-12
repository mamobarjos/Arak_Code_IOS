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

    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!

    @IBOutlet weak var placeHolderImage: UIImageView!

    @IBOutlet weak var descTextField: UITextView!

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var priceTextField: UITextField!

    private var imagePicker = UIImagePickerController()

    private(set) var imageData: Data?
    private(set) var imageUrl: String?
    private(set) var data: [String:Any]?

    public var mode: ProductMode = .add
    public var product: StoreProduct?
    public var relatedProduct: RelatedProducts?

    private var viewModel: CreateServiceViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hiddenNavigation(isHidden: false)
    }
    private func setupUI() {
        trashButton.isHidden = true

        uploadImageButton.setTitle("action.Upload Image".localiz(), for: .normal)
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
        self.showLoading()
        viewModel.createService(data: content, completion: { [weak self] error in
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
    }

    @IBAction func removeImageAction(_ sender: Any) {
        trashButton.isHidden = true
        imageView.image = UIImage(named: "orangeFrame")
        uploadImageButton.isHidden = false
        placeHolderImage.isHidden = false
        imageUrl = nil
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

        guard let imageUrl = imageUrl else {
            self.showToast(message: "error.Please add Product Image".localiz())
            return nil
        }

        let data: [String: Any] = [
            "name":productName,
            "desc":desc,
            "price":price,
            "files[0][\(imageUrl)]":imageUrl,
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

extension AddServiceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            imageData = image.jpegData(compressionQuality: 0.8)
            imageView.image = nil
            imageView.image = image
            uploadToImageFirebase()

        }else if let image = info[.originalImage] as? UIImage {
            imageData = image.jpegData(compressionQuality: 0.8)
            imageView.image = nil
            imageView.image = image
            uploadToImageFirebase()
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

    private func uploadToImageFirebase() {
        showLoading()
        let url = (Helper.currentUser?.imgAvatar ?? "")
        if url.contains("firebasestorage") {
            UploadMedia.deleteMedia(dataArray: [url]) {
                self.compliationUpload()
            }
        } else {
            self.compliationUpload()
        }
    }

    private func compliationUpload() {
        let userId = Helper.currentUser?.id ?? -1

        if userId != -1  && imageData != nil {
            let id = "\(userId)"
            UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { [weak self] url in
                if let firstUrl: String = url.first {
                    self?.imageUrl = firstUrl
                    self?.trashButton.isHidden = false
                    self?.uploadImageButton.isHidden = true
                    self?.placeHolderImage.isHidden = true
                    self?.stopLoading()
                }
            })
        }
    }
}


