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
    private var searchedStores: [Store] = []
    private var banners: [AdBanner] = []
    var canLoadMore = false

    func getCategories() -> [StoreCategory] {
        return self.categories
    }

    func getStores() -> [Store] {
        return self.stores
    }

    func getSearchedStores() -> [Store] {
        return self.searchedStores
    }

    func getBanners() -> [AdBanner] {
        return self.banners
    }

    /// get categories
    func categories(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getCategories, decodable: StoreCategoryContainer.self) { [weak self] (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self?.categories = []
            self?.categories.append(contentsOf: response?.data?.storeCategories ?? [])
        
            compliation(nil)
        }
    }
    
    /// get stores
    func getStores(page: Int = 1,compliation: @escaping CompliationHandler) {
        if page == 1 {
            stores = []
        }
        Network.shared.request(request: StoresRout.getStores(page: page, category: -1), decodable: StoresData.self) { [weak self] (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self?.canLoadMore = !(response?.data?.stores?.isEmpty ?? false)
//            self?.categories.append(contentsOf: response?.data?.storeCategories ?? [])
            self?.stores.append(contentsOf: response?.data?.stores ?? [])
//            self?.banners = response?.data?.banners ?? []
            compliation(nil)
        }
    }
    
    func getBannerList(page:Int ,compliation: @escaping CompliationHandler) {
        if page == 1 {
            banners = []
        }
        Network.shared.request(request: APIRouter.userBanners(page: page), decodable: NewPagingModel<[AdBanner]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.banners = response?.data??.banners ?? []
            compliation(nil)
        }
    }

    /// fetch stores by category if category id == ("-1") response will back with all stores
    func getStoresByCategory(page: Int = 1, by category: Int, compliation: @escaping CompliationHandler) {
        if page == 1 {
            self.stores = []
        }
        Network.shared.request(request: StoresRout.getStores(page: page, category: category), decodable: StoresData.self) { [weak self] response, error in
            guard error == nil else {
                compliation(error)
                return
            }
//            self?.stores = []
            self?.canLoadMore = !(response?.data?.stores?.isEmpty ?? false)
            self?.stores.append(contentsOf: response?.data?.stores ?? [])
            compliation(nil)
        }
    }

    // search stores
    func searchStores(query: String, compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.searchStore(storeName: query), decodable: StoresData.self) { [weak self] response, error in
            guard error == nil else {
                compliation(error)
                return
            }
            self?.searchedStores = []
            self?.searchedStores = response?.data?.stores ?? []
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
