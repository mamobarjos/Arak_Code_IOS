//
//  CartManager.swift
//  Arak
//
//  Created by Osama Abu Hdba on 27/08/2024.
//

import Foundation

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}

protocol CartManagerProtocol {
    func clearCart()
    func getCartCount()
    func addProduct(_ product: ArakProduct, variant: ProductVariant?, quantity: Int)
    func insertProduct(_ product: ArakProduct, variant: ProductVariant?)
    func deleteProduct(_ product: ArakProduct, variant: ProductVariant?)
    func increaseProductQuantity(product: ArakProduct, variant: ProductVariant?)
    func decreaseProductQuantity(product: ArakProduct, variant: ProductVariant?)
    func getCartProducts() -> [ArakProduct]
    func isProductInCart(withId id: Int, variant: ProductVariant?) -> Bool
    func getProductQuantity(withId id: Int, variant: ProductVariant?) -> Int
}

class CartManager: CartManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let cartKey = "cart"

    func getCartCount() {
        guard let data = userDefaults.data(forKey: cartKey),
              let products = try? JSONDecoder().decode([ArakProduct].self, from: data) else {
            Helper.CartItemsCount = 0
            notifyCartUpdate()
            return
        }
            Helper.CartItemsCount = products.count
        notifyCartUpdate()
        
        
    }
    
    func getCartProducts() -> [ArakProduct] {
       
        guard let data = userDefaults.data(forKey: cartKey),
              let products = try? JSONDecoder().decode([ArakProduct].self, from: data) else {
            return []
        }
        return products
    }

    func isProductInCart(withId id: Int, variant: ProductVariant?) -> Bool {
           let cart = getCartProducts()
        return cart.contains {$0.id == id && $0.selectedVariant == variant}
       }
    
    func addProduct(_ product: ArakProduct, variant: ProductVariant?, quantity: Int) {
        var cart = getCartProducts()

        if let index = cart.firstIndex(where: { $0.id == product.id && $0.selectedVariant == variant }) {
            cart[index].quantity! = quantity
            cart[index].selectedVariant = variant!
        } else {
            var product = product
            product.quantity = quantity
            product.selectedVariant = variant!
            cart.append(product)
        }
        
        saveCart(cart)
        notifyCartUpdate()
    }


    func insertProduct(_ product: ArakProduct, variant: ProductVariant?) {
        var cart = getCartProducts()
        cart.append(product)
        saveCart(cart)
        notifyCartUpdate()
    }

    func deleteProduct(_ product: ArakProduct, variant: ProductVariant?) {
        var cart = getCartProducts()
        cart.removeAll { $0.id == product.id && $0.selectedVariant == variant }
        saveCart(cart)
        notifyCartUpdate()
    }

    func increaseProductQuantity(product: ArakProduct, variant: ProductVariant?) {
        updateProductQuantity(product: product, increment: 1, variant: variant)
    }

    func decreaseProductQuantity(product: ArakProduct, variant: ProductVariant?) {
        updateProductQuantity(product: product, increment: -1, variant: variant)
    }
    
    func getProductQuantity(withId id: Int, variant: ProductVariant?) -> Int {
        let cart = getCartProducts()
        return cart.first(where: {$0.id == id && $0.selectedVariant == variant })?.quantity ?? 0
    }
    
    func clearCart() {
        var cart = getCartProducts()
        cart.removeAll()
        saveCart(cart)
        notifyCartUpdate()
    }

    private func updateProductQuantity(product: ArakProduct, increment: Int, variant: ProductVariant?) {
        var cart = getCartProducts()
//        print(cart)
        if let index = cart.firstIndex(where: { $0.id == product.id && $0.selectedVariant == variant }) {
            cart[index].quantity! += increment
            cart[index].selectedVariant = variant!
            if cart[index].quantity! <= 0 {
                cart.remove(at: index)
            }
            saveCart(cart)
            notifyCartUpdate()
        } else {
            var newProduct = product
            newProduct.quantity = 1
            newProduct.setVariant(variant!)
            print(newProduct)
            cart.append(newProduct)
            print(cart)
            saveCart(cart)
            notifyCartUpdate()
        }
    }
    
  

    private func saveCart(_ cart: [ArakProduct]) {
        if let data = try? JSONEncoder().encode(cart) {
            userDefaults.set(data, forKey: cartKey)
            Helper.CartItemsCount = cart.count
        }
    }
    
    
    private func notifyCartUpdate() {
        let totalProducts = getCartProducts().reduce(0) { $0 + $1.quantity! }
           NotificationCenter.default.post(name: .cartUpdated, object: nil, userInfo: ["totalProducts": totalProducts])
       }
}
