//
//  UIImageView+Ex.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import AVKit
import SDWebImage
import Alamofire
import Kingfisher

extension UIImageView {
    
    public func imageFromVideo(videoURL: String?, at time: TimeInterval = 1,compliation: (()-> Void)? = nil) {
        self.image = #imageLiteral(resourceName: "Summery Image-2")
        
        if let urlString = videoURL , let url = URL(string:(urlString)) , url.description.contains("mp4") {
            AVAsset(url: url).generateThumbnail { [weak self] (image) in
                DispatchQueue.main.async {
                    guard let image = image else {
                        return
                    }
                    self?.image = image
                }
            }
        }
    }
    
    func getAlamofireImage(urlString: String?,compliation: (()-> Void)? = nil) {
        DispatchQueue.main.async {
            if let url = URL(string:  (urlString ?? "")) {
                print(url)
                self.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Summery Image"), options: .highPriority, completed: {_,_,_,_ in
                    compliation?()
                })
            } else {
                self.image = #imageLiteral(resourceName: "Summery Image")
            }
        }
        
    }
}

extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}


// MARK: - UIImageView extension to easily replicate Instagram zooming feature
public extension UIImageView {
    /// Key for associated object
    private struct AssociatedKeys {
        static var ImagePinchKey: Int8 = 0
        static var ImagePinchGestureKey: Int8 = 1
        static var ImagePanGestureKey: Int8 = 2
        static var ImageScaleKey: Int8 = 3
    }

    /// The image should zoom on Pinch
  var isPinchable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ImagePinchKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ImagePinchKey, newValue, .OBJC_ASSOCIATION_RETAIN)

            if pinchGesture == nil {
                inititialize()
            }

            if newValue {
                isUserInteractionEnabled = true
                pinchGesture.map { addGestureRecognizer($0) }
                panGesture.map { addGestureRecognizer($0) }
            } else {
                pinchGesture.map { removeGestureRecognizer($0) }
                panGesture.map { removeGestureRecognizer($0) }
            }
        }
    }

    /// Associated image's pinch gesture
    private var pinchGesture: UIPinchGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ImagePinchGestureKey) as? UIPinchGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ImagePinchGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Associated image's pan gesture
    private var panGesture: UIPanGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ImagePanGestureKey) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ImagePanGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Associated image's scale -- there might be no need
    private var scale: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.ImageScaleKey) as? CGFloat) ?? 1.0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ImageScaleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }


    /// Initialize pinch & pan gestures
    private func inititialize() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(imagePinched(_:)))
        pinchGesture?.delegate = self
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePanned(_:)))
        panGesture?.delegate = self
    }

    /// Perform the pinch to zoom if needed.
    ///
    /// - Parameter sender: UIPinvhGestureRecognizer
    @objc private func imagePinched(_ pinch: UIPinchGestureRecognizer) {
        if pinch.scale >= 1.0 {
            scale = pinch.scale
            transform(withTranslation: .zero)
        }

        if pinch.state != .ended { return }

        reset()
    }

    /// Perform the panning if needed
    ///
    /// - Parameter sender: UIPanGestureRecognizer
    @objc private func imagePanned(_ pan: UIPanGestureRecognizer) {
        if scale > 1.0 {
            transform(withTranslation: pan.translation(in: self))
        }

        if pan.state != .ended { return }

        reset()
    }

    /// Set the image back to it's initial state.
    private func reset() {
        scale = 1.0
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }

    /// Will transform the image with the appropriate
    /// scale or translation.
    ///
    /// Parameter translation: CGPoint
    private func transform(withTranslation translation: CGPoint) {
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, scale, scale, 1.01)
        transform = CATransform3DTranslate(transform, translation.x, translation.y, 0)
        layer.transform = transform
    }
}

extension UIImageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
