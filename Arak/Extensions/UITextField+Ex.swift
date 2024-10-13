//
//  UITextField+Ex.swift
//
//  Created by Abed Qassim on 10/10/20.
//

import UIKit

@IBDesignable
extension UITextField {

  func setLeftImage(image:UIImage) {

      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
      imageView.image = image
      imageView.tintColor = .black
      self.leftView = imageView;
      self.leftViewMode = .always
  }

  func setRightImage(image:UIImage) {

      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
      imageView.tintColor = .black
      imageView.image = image
      self.rightView = imageView;
      self.rightViewMode = .always
  }
}

extension UITextView {
  func textAlignment() {
    self.textAlignment = Helper.appLanguage ?? "en" == "en" ? .left : .right
  }
}
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UITextView {
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}



extension UITextField {

    // Runtime key
    private struct AssociatedKeys {
        // Maximum length key
        static var maxlength: UInt8 = 0
        // Temporary string key
        static var tempString: UInt8 = 0
    }

    // Limit the maximum input length of the textfiled
    @IBInspectable var maxLength: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.maxlength) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maxlength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTarget(self, action: #selector(handleEditingChanged(textField:)), for: .editingChanged)
        }
    }

    // Temporary string
    private var tempString: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tempString) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempString, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // When the text changes, process the amount of text in the input
    // box so that its length is within the controllable range.
    @objc private func handleEditingChanged(textField: UITextField) {

        // Special processing for the Chinese input method
        guard markedTextRange == nil else { return }

        if textField.text?.count == maxLength {

            // Set lastQualifiedString where text length == maximum length
            tempString = textField.text
        } else if textField.text?.count ?? 0 < maxLength {

            // Clear lastQualifiedString when text length > maxlength
            tempString = nil
        }

        // Keep the current text range in arcgives
        let archivesEditRange: UITextRange?

        if textField.text?.count ?? 0 > maxLength {

            // If text length > maximum length, remove last range and to move to -1 postion.
            let position = textField.position(from: safeTextPosition(selectedTextRange?.start), offset: -1) ?? textField.endOfDocument
            archivesEditRange = textField.textRange(from: safeTextPosition(position), to: safeTextPosition(position))
        } else {

            // Just set current select text range
            archivesEditRange = selectedTextRange
        }

        // Main handle string maximum length
        textField.text = tempString ?? String((textField.text ?? "").prefix(maxLength))

        // Last configuration edit text range
        textField.selectedTextRange = archivesEditRange
    }

    // Get safe textPosition
    private func safeTextPosition(_ optionlTextPosition: UITextPosition?) -> UITextPosition {

        /* beginningOfDocument -> The end of the the text document. */
        return optionlTextPosition ?? endOfDocument
    }
}
