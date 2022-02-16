//
//  FavriteManagerDefault.swift
//  Arak
//
//  Created by Osama Abu hdba on 17/02/2022.
//

//import UIKit
//
//protocol FavoriteViewType: AnyObject {
//    func set(isFavorited: Bool)
//    func resetFavButton()
//}
//
//protocol FavoritesManagerType: AnyObject {
//
//    func favoriteOrUnfavorite(product: Product, sender: FavoriteViewType?)
//
//    func productIsFavorited(_ product: Product) -> Bool
//}
//
//class DefaultFavoritesManager: NSObject, FavoritesManagerType {
//
//    @Injected var authenticationManager: AuthenticationManagerType
//
//    fileprivate var cachedFavoritedPostIDs: [String: Bool] = [:]
//
//    override init() {
//        super.init()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(authStateDidChange),
//                                               name: AppNotifications.didChangeAuthStatusNotification,
//                                               object: nil)
//    }
//
//    var context: UIViewController? {
//        AppCoordinator.shared?.activeCoordinator.initialViewController
//    }
//
//    @objc func authStateDidChange() {
//        self.cachedFavoritedPostIDs = [:]
//    }
//
//    func favoriteOrUnfavorite(product: Product, sender: FavoriteViewType?) {
//        // try to find the topVC
//        if let topVC = UIApplication.topViewController(base: context) as? BaseViewController {
//            topVC.performIfAuthenticated {
//                self._favoriteOrUnfavorite(product: product, sender: sender)
//            }
//
//           if !topVC.authenticationManager.isAuthenticated {
//               sender?.resetFavButton()
//            }
//        }
//    }
//
//    private func _favoriteOrUnfavorite(product: Product, sender: FavoriteViewType?) {
//        if productIsFavorited(product) {
//            // inserting into the cache
//            self.cachedFavoritedPostIDs[product.id ?? ""] = false
//
//            // setting the view
//            sender?.set(isFavorited: false)
//
//            // performing the api
//            FavoriteRoutes.unfavorite(product.id ?? "").request(String.self).catch { [weak self] in
//                guard let self = self else { return }
//                print("received error for unvafovoriting: \($0)")
//
//                self.cachedFavoritedPostIDs[product.id ?? ""] = true
//                sender?.set(isFavorited: true)
//
//                self.context?.show(message: $0.localizedDescription, messageType: .failure)
//            }
//        } else {
//            self.cachedFavoritedPostIDs[product.id ?? ""] = true
//
//            sender?.set(isFavorited: true)
//
//            FavoriteRoutes.favorite(product.id ?? "").request(String.self).catch { [weak self] in
//                guard let self = self else { return }
//                print("received error for favoriting: \($0)")
//
//                self.cachedFavoritedPostIDs[product.id ?? ""] = false
//                sender?.set(isFavorited: false)
//
//                self.context?.show(message: $0.localizedDescription, messageType: .failure)
//            }
//        }
//    }
//
//    func productIsFavorited(_ product: Product) -> Bool {
//        if let cachedValue = cachedFavoritedPostIDs[product.id ?? ""] {
//            return cachedValue
//        }
//
//        return product.isFavorite ?? false
//    }
//}
