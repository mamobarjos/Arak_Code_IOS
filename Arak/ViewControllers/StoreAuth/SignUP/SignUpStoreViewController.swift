//
//  SignUpStoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import UIKit
import CoreLocation

class SignUpStoreViewController: UIViewController {

    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var storeDesTextField: UITextView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    private var imagePicker = UIImagePickerController()
    private var currentLocation: CLLocation?
    private var currentLocatioTitle: String?
    private var imageData: Data?
    private var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
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
            return nil
        }
        guard let description = storeDesTextField.text else {
            return nil
        }
        guard let storeWebsit = websiteTextField.text else {
            return nil
        }
        guard let phoneNumber = phoneNumberTextField.text else {
            return nil
        }
        guard let currentLocation = currentLocation else {
            return nil
        }
//        guard let imageUrl = imageUrl else {
//            return nil
//        }


        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude

        let data: [String: Any] = [
            "name":companyName,
            "desc":description,
            "website":storeWebsit,
            "phone_no":phoneNumber,
            "store_category_id":1,
            "lon":"\(lon)",
            "lat":"\(lat)",
            "img":"https://firebasestorage.googleapis.com/v0/b/arak-d1392.appspot.com/o/B0012A83-F42B-4AEA-BB36-98AD01029290.jpg?alt=media&token=78216f3f-8f82-4eab-bbf6-6b6af44f3003",
            "cover":"https://firebasestorage.googleapis.com/v0/b/arak-d1392.appspot.com/o/B0012A83-F42B-4AEA-BB36-98AD01029290.jpg?alt=media&token=78216f3f-8f82-4eab-bbf6-6b6af44f3003"
        ]
        return data
    }
}

// MARK: - Fetch image methods

extension SignUpStoreViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
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
                    self?.stopLoading()
                }
            })
        }
    }
}

