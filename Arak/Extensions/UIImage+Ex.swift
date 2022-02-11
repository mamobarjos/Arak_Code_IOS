//
//  UIImage+Ex.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import UIKit

extension UIImage {
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension UITabBarItem {
    func downloaded(from urlString: String?, compliation: ((UIImage) -> Void)?) {
        if let url: URL = URL(string: urlString ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    compliation?(image)
                }
            }.resume()
        }
    }
}

@IBDesignable
class FlippableImage: UIImageView {

    @IBInspectable var isflippable: Bool = false {
        didSet {
            self.image = Helper.appLanguage ?? "en" == "ar" ? self.image?.imageFlippedForRightToLeftLayoutDirection() : image
            self.layoutIfNeeded()
        }
    }

}



@IBDesignable
class FlippableButton: UIButton {

    @IBInspectable var isflippable: Bool = false {
        didSet {
            self.setImage(Helper.appLanguage == "ar" ? imageView?.image?.imageFlippedForRightToLeftLayoutDirection() : imageView?.image, for: .normal)
            self.layoutIfNeeded()
        }
    }

}
