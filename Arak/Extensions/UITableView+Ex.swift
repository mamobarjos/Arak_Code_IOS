//
//  UITableView.swift
//
//  Created by Abed Qassim on 10/10/20.
//

import UIKit
extension UITableView {
    
    func register<T:UITableViewCell>(_: T.Type){
        let bundle = Bundle(for: T.self)
        let nib =  UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.nibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath)-> T{
        
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nibName)")
        }
        return cell
    }
    
}

extension UITableViewCell:NibLoadableView{
    static var nibName:String {
        return String(describing: self)
    }
}

extension NSObject {
    class var className: String {
        return "\(self)"
    }
}
extension UIScrollView {
    
    func setEmptyGeneralView(title: String, message: String, messageImage: UIImage,onClickButton: @escaping (()-> Void)) -> UIView {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let retryButton = UIButton()

        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Retry".localiz(), for: .normal)
        retryButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        retryButton.addRoundedCorners(cornerRadius: 12)
        retryButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        titleLabel.textColor = UIColor.black
        if let font = UIFont(name: "DroidArabicKufi-Bold", size: 17) {
         titleLabel.font = font
        }
        messageLabel.textColor = UIColor.lightGray
        if let font = UIFont(name: "DroidArabicKufi-Bold", size: 14) {
            messageLabel.font = font
        }

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        //emptyView.addSubview(retryButton)

        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//        retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
//        retryButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//        retryButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        retryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        retryButton.actionHandler(controlEvents: .touchUpInside) {
            onClickButton()
        }
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        return emptyView
    }
    
    
}

extension UIViewController {
    func setEmptyGeneralView(title: String, message: String, messageImage: UIImage) -> UIView {
        
        let emptyView = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let retryButton = UIButton()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Retry".localiz(), for: .normal)
        retryButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        retryButton.addRoundedCorners(cornerRadius: 12)
        retryButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        titleLabel.textColor = UIColor.black
        if let font = UIFont(name: "DroidArabicKufi-Bold", size: 17) {
         titleLabel.font = font
        }
        messageLabel.textColor = UIColor.lightGray
        if let font = UIFont(name: "DroidArabicKufi-Bold", size: 14) {
            messageLabel.font = font
        }
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        //emptyView.addSubview(retryButton)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//        retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
//        retryButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//
//        retryButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        retryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        retryButton.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        emptyView.backgroundColor = .white
        return emptyView
    }
    
    @objc func onClickButton() {}
}

extension UITableView {
    func setEmptyView(title: String = "No Data Found".localiz(), message: String = "", messageImage: UIImage = #imageLiteral(resourceName: "Page not found"),onClickButton: @escaping (()-> Void)) {
        self.backgroundView = setEmptyGeneralView(title: title, message: message, messageImage: messageImage, onClickButton: onClickButton)
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
}

extension UICollectionView {
    func setEmptyView(title: String = "No Data Found".localiz(), message: String = "", messageImage: UIImage = #imageLiteral(resourceName: "Page not found"),onClickButton: @escaping (()-> Void)) {
        self.backgroundView = setEmptyGeneralView(title: title, message: message, messageImage: messageImage,onClickButton:onClickButton)
        
    }
    func restore() {
        self.backgroundView = nil
    }
    
}
import UIKit
extension UIButton {
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}
