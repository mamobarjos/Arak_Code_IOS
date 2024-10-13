//
//  FeedbackViewController.swift
//  Arak
//
//  Created by Abed Qassim on 15/06/2021.
//

import UIKit
import Cosmos
import StoreKit

class FeedbackViewController: UIViewController,UITextViewDelegate {
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
    
    private var feedbackViewModel = FeedbackViewModel()
    var error = ""
  override func viewDidLoad() {
        super.viewDidLoad()
    loclization()
    ratingView.didFinishTouchingCosmos = { [weak self] rating in
      self?.titleLabel.text = "Tell us a bit more about why you chose".localiz() + " \(Int(rating))"
    }
    ratingView.didTouchCosmos = { [weak self] rating in
        self?.titleLabel.text = "Tell us a bit more about why you chose".localiz() + " \(Int(rating))"
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    hiddenNavigation(isHidden: false)
  }

  private func loclization() {
    descriptionTextView.text = "Description".localiz()
    titleLabel.text = "Tell us a bit more about why you chose".localiz() + "\(Int(ratingView.rating))"
    submitButton.setTitle("Submit".localiz(), for: .normal)
    setupDescription()
  }
    
    func requestAppRating() {
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

  @IBAction func Close(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func Submit(_ sender: Any) {
    if !validation() {
      self.showToast(message: error)
      return
    }
    let data: [String: String] = ["content": descriptionTextView.text!,"rating": "\(ratingView.rating)"]
    showLoading()
    feedbackViewModel.arakFeedback(data: data) { [weak self] (error) in

      defer {
        self?.stopLoading()
      }
      self?.showToast(message: "Thank you, we appreciate your opinion".localiz())
        self?.requestAppRating()
        self?.navigationController?.popViewController(animated: true)
    }
  }

  private func setupDescription() {
    descriptionTextView.textColor = UIColor.lightGray
    descriptionTextView.text = "Description".localiz()
    descriptionTextView.textAlignment()
    descriptionTextView.delegate = self
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
          descriptionTextView.text = ""
          descriptionTextView.textColor = #colorLiteral(red: 0.1058823529, green: 0.1411764706, blue: 0.3607843137, alpha: 1)
      }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
          descriptionTextView.text = "Description".localiz()
          descriptionTextView.textColor = UIColor.lightGray
      }
  }
    private func validation() -> Bool {
      error = ""

      guard let description = descriptionTextView.text else {
        error = "Please insert your description".localiz()
        descriptionTextView.becomeFirstResponder()
        return error.isEmpty
      }
      if description.isEmpty {
        error = "Please insert your description".localiz()
        descriptionTextView.becomeFirstResponder()
        return error.isEmpty
      }

      return true
    }

}


extension UIApplication {
    var currentScene: UIWindowScene? {
        return connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
