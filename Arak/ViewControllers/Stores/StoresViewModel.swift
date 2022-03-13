//
//  StoresViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import Foundation

class StoresViewModel {
    private var categories: [StoreCategory] = []
    private var stores: [Store] = []
    private var searchedStores: [TestSearchModel] = []
    private var banners: [Banner] = []
    var canLoadMore = false

    func getCategories() -> [StoreCategory] {
        return self.categories
    }

    func getStores() -> [Store] {
        return self.stores
    }

    func getSearchedStores() -> [TestSearchModel] {
        return self.searchedStores
    }

    func getBanners() -> [Banner] {
        return self.banners
    }

    /// get stores and categories
    func getStores(page: Int = 1,compliation: @escaping CompliationHandler) {
        if page == 1 {
            stores = []
        }
        Network.shared.request(request: StoresRout.getStores(page: page), decodable: StoresRespose.self) { [weak self] (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self?.canLoadMore = !(response?.data?.storesData.data.isEmpty ?? false)
            self?.categories.append(contentsOf: response?.data?.storeCategories ?? [])
            self?.stores.append(contentsOf: response?.data?.storesData.data ?? [])
            self?.banners = response?.data?.banners ?? []
            compliation(nil)
        }
    }

    /// fetch stores by category if category id == ("-1") response will back with all stores
    func getStoresByCategory(page: Int = 1, by category: Int, compliation: @escaping CompliationHandler) {
        if page == 1 {
            self.stores = []
        }
        Network.shared.request(request: StoresRout.filterStoresByCategory(category: category, page: page), decodable: StoresData.self) { [weak self] response, error in
            guard error == nil else {
                compliation(error)
                return
            }
//            self?.stores = []
            self?.canLoadMore = !(response?.data?.data.isEmpty ?? false)
            self?.stores.append(contentsOf: response?.data?.data ?? [])
            compliation(nil)
        }
    }

    // search stores
    func searchStores(query: String, compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.searchStore(storeName: query), decodable: PagingModel<[TestSearchModel]>.self) { [weak self] response, error in
            guard error == nil else {
                compliation(error)
                return
            }
            self?.searchedStores = []
            self?.searchedStores = response?.data?.data ?? []
            compliation(nil)
        }
    }
}

// TODO: - will be removed later

struct TestSearchModel: Codable {
    let totalRates: Double?
    let youtube: String?
    let userid: Int?
    let isFeatured: Int?
    let img: String?
    let facebook: String?
    let lon: String?
    let storeCategoryid: Int?
    let updatedAt: String?
    let cover: String?
    let name: String?
    let twitter: String?
    let linkedin: String?
    let id: Int?
    let website: String?
    let phoneNo: String?
    let instagram: String?
    let lat: String?
    let createdAt: String?
    let desc: String?
    let snapchat: String?

    enum CodingKeys: String, CodingKey {
        case totalRates = "total_rates"
        case youtube = "youtube"
        case userid = "user_id"
        case isFeatured = "is_featured"
        case img = "img"
        case facebook = "facebook"
        case lon = "lon"
        case storeCategoryid = "store_category_id"
        case updatedAt = "updated_at"
        case cover = "cover"
        case name = "name"
        case twitter = "twitter"
        case linkedin = "linkedin"
        case id = "id"
        case website = "website"
        case phoneNo = "phone_no"
        case instagram = "instagram"
        case lat = "lat"
        case createdAt = "created_at"
        case desc = "desc"
        case snapchat = "snapchat"
    }
}
