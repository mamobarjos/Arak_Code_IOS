//
//  SignUpStoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import UIKit
import CoreLocation

class SignUpStoreViewController: UIViewController {

    enum ImageType {
        case personalPhoto
        case coverPhoto
    }

    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var storeDesTextField: UITextView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var chooseCategoryView: UIView!

    private var imagePicker = UIImagePickerController()
    private var currentLocation: CLLocation?
    private var currentLocatioTitle: String?
    private(set) var imageData: Data?
    private(set) var imageUrl: String?
    private(set) var coverImageData: Data?
    private(set) var coverImageUrl: String?
    private(set) var categoryId: Int?
    private(set) var imageType: ImageType = .personalPhoto

    override func viewDidLoad() {
        super.viewDidLoad()
        chooseCategoryView.addTapGestureRecognizer {[weak self] in
            let vc = CategoriesViewController()
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        coverImageView.contentMode = .scaleToFill
        imageView.contentMode = .scaleToFill
    }

    @IBAction func locatioAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: MapViewController.className, and: "") as! MapViewController
        vc.configue {
        } confrimLocation: { (currentLocation, city) in
            self.currentLocation = currentLocation
            self.currentLocatioTitle = city
            self.locationTextField.text = city?.isEmpty ?? false == true ? "\(currentLocation?.coordinate.latitude ?? 0.0) ,\(currentLocation?.coordinate.longitude ?? 0.0) " : city ?? ""
        }
        show(vc)
    }
    @IBAction func picPhotoAction(_ sender: Any) {
        imageType = .personalPhoto
        fetchImage()
    }

    @IBAction func coverPhotoAction(_ sender: Any) {
        imageType = .coverPhoto
        fetchImage()
    }

    @IBAction func submitAction(_ sender: Any) {
        guard let content = validateContent() else {
            return
        }
        let vc = initViewControllerWith(identifier: SocialMediaSignUPViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as!
        SocialMediaSignUPViewController
        vc.getData(data: content)
        show(vc)
    }

    private func validateContent() -> [String:Any]? {
        guard let companyName = companyNameTextField.text else {
            self.showToast(message: "Please Enter Store Name")
            return nil
        }
        guard let description = storeDesTextField.text else {
            self.showToast(message: "Please Enter Store Description")
            return nil
        }

        if storeDesTextField.text == "Description" {
            self.showToast(message: "Please Enter Store Description")
            return nil
        }

        guard let phoneNumber = phoneNumberTextField.text else {
            self.showToast(message: "Please Enter Store Phone Number")
            return nil
        }
        guard let currentLocation = currentLocation else {
            self.showToast(message: "Please Enter your Store Location")
            return nil
        }

        guard let categoryId = categoryId else {
            self.showToast(message: "Please Choose Store Category Type")
            return nil
        }

        guard let imageUrl = imageUrl else {
            self.showToast(message: "Please Add Your Store Image")
            return nil
        }

        guard let coverImageUrl = coverImageUrl else {
            self.showToast(message: "Please Add Your Store Cover Image")
            return nil
        }



        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude

        let data: [String: Any] = [
            "name":companyName,
            "desc":description,
            "website":websiteTextField.text ?? "",
            "phone_no":phoneNumber,
            "store_category_id":categoryId,
            "lon":"\(lon)",
            "lat":"\(lat)",
            "img":imageUrl,
            "cover":coverImageUrl
        ]
        return data
    }
}

// MARK: - Fetch image methods

extension SignUpStoreViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {

            if imageType == .personalPhoto {
                imageView.image = nil
                imageData = image.jpegData(compressionQuality: 0.8)
                imageView.image = image
            } else {
                coverImageView.image = nil
                coverImageData = image.jpegData(compressionQuality: 0.8)
                coverImageView.image = image
            }
            uploadToImageFirebase()

        }else if let image = info[.originalImage] as? UIImage {


            if imageType == .personalPhoto {
                imageView.image = nil
                imageData = image.jpegData(compressionQuality: 0.8)
                imageView.image = image
            } else {
                coverImageView.image = nil
                coverImageData = image.jpegData(compressionQuality: 0.8)
                coverImageView.image = image
            }
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
        if imageType == .personalPhoto {
            if userId != -1  && imageData != nil {
                let id = "\(userId)"
                UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { [weak self] url in
                    if let firstUrl: String = url.first {
                        self?.imageUrl = firstUrl
                        self?.stopLoading()
                    }
                })
            }
        } else {
            if userId != -1  && coverImageData != nil {
                let id = "\(userId)"
                UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: coverImageData!)], completionHandler: { [weak self] url in
                    if let firstUrl: String = url.first {
                        self?.coverImageUrl = firstUrl
                        self?.stopLoading()
                    }
                })
            }
        }
    }
}

extension SignUpStoreViewController: CategoriesViewControllerDelegate {
    func didFinishWithCategory(categoryId: Int, categoryName: String) {
        self.categoryId = categoryId
    }

}

