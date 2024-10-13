//
//  ArakStoreViewModel.swift
//  Arak
//
//  Created by Osama Abu Hdba on 19/08/2024.
//

import Foundation
class ArakStoreViewModel {
    
    private(set) var products: [ArakProduct] = []
    private(set) var productVariants: [ProductVariant] = []
    private(set) var categories: [ArakCategory] = []
    
    func getProducts() -> [ArakProduct] {
        return self.products
    }
    
    func getProductVariants() -> [ProductVariant] {
        return self.productVariants
    }
    
    func getcategories() -> [ArakCategory] {
        return self.categories
    }
    
    func getStoreProducts(by category: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getArakProducts(categotyId: category), decodable: [ArakProduct].self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            
            self?.products = response?.data ?? []
            complition(nil)
        }
    }
    
    func getStoreProductsCategories(complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getArakProductsCatigores, decodable: [ArakCategory].self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            
            self?.categories = response?.data ?? []
            complition(nil)
        }
    }
    
    func getStoreProductsVariants(productId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getArakProductVariants(productId: productId), decodable: [ProductVariant].self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            
            self?.productVariants = response?.data ?? []
            complition(nil)
        }
    }
}


struct ArakCategory: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let parent: Int?
    let description: String?
    let display: String?
    let image: Image? // Assuming image is a URL or String; it was null in the response
    let menuOrder: Int?
    let count: Int?
//    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, parent, description, display, image
        case menuOrder = "menu_order"
        case count
//        case links = "_links"
    }
}
