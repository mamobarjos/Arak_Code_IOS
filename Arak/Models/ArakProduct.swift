//
//  ArakProduct.swift
//  Arak
//
//  Created by Osama Abu Hdba on 19/08/2024.
//

import Foundation
// MARK: - Datum

struct ArakProduct: Codable {
    
    let id: Int?
    let name, slug: String?
    let permalink: String?
    let dateCreated, dateCreatedGmt: String?
    let dateModified, dateModifiedGmt, type, status: String?
    let featured: Bool?
    let catalogVisibility, description, shortDescription, sku: String?
    let price, regularPrice, salePrice: String?
    let dateOnSaleFrom, dateOnSaleFromGmt, dateOnSaleTo, dateOnSaleToGmt: JSONNull?
    let onSale, purchasable: Bool?
    let totalSales: Int?
    let virtual, downloadable: Bool?
//    let downloads: [JSONAny]?
    let downloadLimit, downloadExpiry: Int?
    let externalURL, buttonText, taxStatus, taxClass: String?
    let manageStock: Bool?
//    let stockQuantity: JSONNull?
    let backorders: String?
    let backordersAllowed, backordered: Bool?
//    let lowStockAmount: JSONNull?
    let soldIndividually: Bool?
    let weight: String?
//    let dimensions: Dimensions?
    let shippingRequired, shippingTaxable: Bool?
    let shippingClass: String?
    let shippingClassID: Int?
    let reviewsAllowed: Bool?
    let averageRating: String?
    let ratingCount: Int?
//    let upsellIDS, crossSellIDS: [JSONAny]?
    let parentID: Int?
    let purchaseNote: String?
//    let categories, tags: [JSONAny]?
    let images: [Image]?
//    let attributes: [Attribute]?
//    let defaultAttributes: [JSONAny]?
//    let variations: [Int]?
//    let groupedProducts: [JSONAny]?
//    let menuOrder: Int?
//    let priceHTML: String?
//    let relatedIDS: [JSONAny]?
//    let metaData: [MetaDatum]?
//    let stockStatus: String?
//    let hasOptions: Bool?
//    let postPassword: String?
//    let jetpackSharingEnabled: Bool?
    let links: Links?
    var quantity: Int? = 1
    var selectedVariant: ProductVariant? = ProductVariant(id: 1, attributes: [], name: "", parentID: 1)
  
    
    mutating func setVariant(_ variant: ProductVariant) {
        selectedVariant = variant
    }
//    var selectedSize: String = ""
    
//    {
//        if let attributes = attributes {
//            let sortedAttributes = attributes.sorted { $0.position ?? 0 < $1.position ?? 0}
//            if sortedAttributes.count > 0 {
//                return sortedAttributes.first?.options?.first
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
    
//    var selectedColor: String = ""
//    {
//        if let attributes = attributes {
//            let sortedAttributes = attributes.sorted { $0.position ?? 0 < $1.position ?? 0}
//            
//            if sortedAttributes.count > 1 {
//                return sortedAttributes[1].options?.first
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }

    enum CodingKeys: String, CodingKey {
        case id, name, slug, permalink
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case type, status, featured
        case catalogVisibility = "catalog_visibility"
        case description
        case shortDescription = "short_description"
        case sku, price
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case dateOnSaleFrom = "date_on_sale_from"
        case dateOnSaleFromGmt = "date_on_sale_from_gmt"
        case dateOnSaleTo = "date_on_sale_to"
        case dateOnSaleToGmt = "date_on_sale_to_gmt"
        case onSale = "on_sale"
        case purchasable
        case totalSales = "total_sales"
        case virtual, downloadable
        case downloadLimit = "download_limit"
        case downloadExpiry = "download_expiry"
        case externalURL = "external_url"
        case buttonText = "button_text"
        case taxStatus = "tax_status"
        case taxClass = "tax_class"
        case manageStock = "manage_stock"
//        case stockQuantity = "stock_quantity"
        case backorders
        case backordersAllowed = "backorders_allowed"
        case backordered
//        case lowStockAmount = "low_stock_amount"
        case soldIndividually = "sold_individually"
        case weight
        case shippingRequired = "shipping_required"
        case shippingTaxable = "shipping_taxable"
        case shippingClass = "shipping_class"
        case shippingClassID = "shipping_class_id"
        case reviewsAllowed = "reviews_allowed"
        case averageRating = "average_rating"
        case ratingCount = "rating_count"
//        case upsellIDS = "upsell_ids"
//        case crossSellIDS = "cross_sell_ids"
        case parentID = "parent_id"
        case purchaseNote = "purchase_note"
        case images
//        case defaultAttributes = "default_attributes"
//        case variations
//        case groupedProducts = "grouped_products"
//        case menuOrder = "menu_order"
//        case priceHTML = "price_html"
//        case relatedIDS = "related_ids"
//        case metaData = "meta_data"
//        case stockStatus = "stock_status"
//        case hasOptions = "has_options"
//        case postPassword = "post_password"
//        case jetpackSharingEnabled = "jetpack_sharing_enabled"
        case links = "_links"
        case quantity
        case selectedVariant
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let id: Int?
    let name, slug: String?
    let position: Int?
    let visible, variation: Bool?
    let options: [String]?
}

extension Attribute: Equatable {
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Dimensions
struct Dimensions: Codable {
    let length, width, height: String?
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let dateCreated, dateCreatedGmt, dateModified, dateModifiedGmt: String?
    let src: String?
    let name, alt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case src, name, alt
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, collection: [Collection]?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case collection
    }
}

// MARK: - Collection
struct Collection: Codable {
    let href: String?
}

struct ProductVariant: Codable {
    let id: Int?
    let attributes: [Attribute]?
    let name: String?
    let parentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
        case name, parentID = "parent_id"
    }
}

extension ProductVariant: Equatable {
    static func == (lhs: ProductVariant, rhs: ProductVariant) -> Bool {
        return lhs.id == rhs.id
    }
}
