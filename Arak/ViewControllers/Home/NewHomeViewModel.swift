//
//  NewHomeViewModel.swift
//  Arak
//
//  Created by Osama Abu Hdba on 18/07/2024.
//

import Foundation

class NewHomeViewModel {
    
    // MARK: - Properties
    var adsList:[Adverisment] = []
    var hasMore: Bool = true
    var featuredAdsList:[Adverisment] = []
    var hasMoreFeaturedAds: Bool = true
    var hasMoreBannerAds: Bool = true
    var randomProducts: [RelatedProducts] = []
    var bannerList:[AdBanner] = []
    var ellectionFilters: EllectionFilters?
    var ellectionData: EllectionData?
    var ellectionPerson: EllectionPeople?
    var adCategory: [AdCategory] = []
    var stores: [Store] = []
    var itemCount: Int {
        return adsList.count
    }
    var itemBannerCount: Int {
        return bannerList.count
    }
    

    // MARK: - Protected Methods
    func adsList(page:Int , search:String, adsType: Int? ,compliation: @escaping CompliationHandler) {
        adsList = []
        Network.shared.request(request: APIRouter.adsList(page: page, search: search, ad_category_id: adsType), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data?.ads ?? [])
            self.hasMore = (response?.data?.ads ?? []).count != 0
            compliation(nil)
        }
    }
    
    func searchList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.searchAd(title: search), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data??.data ?? [])
            self.hasMore = (response?.data??.data ?? []).count != 0
            compliation(nil)
        }
    }
    
    func getFavorateList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getFavorites(page: page), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data?.ads ?? [])
            self.hasMore = (response?.data?.ads ?? []).count != 0
            compliation(nil)
        }
    }
    
    
    func deleteAd(adId:Int ,compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.deleteAds(adId: adId), decodable: Adverisment.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            compliation(nil)
        }
    }
    
    func getHistory(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getHistory(page: page), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data?.ads ?? [])
            self.hasMore = (response?.data?.ads ?? []).count != 0
            compliation(nil)
        }
    }
    
    func getUserAds(page:Int, isFilter: Bool , year:String, month: String , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getUserAds(page: page, isFilter: isFilter, date_from: year, date_to: month), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data??.data ?? [])
            self.hasMore = (response?.data??.data ?? []).count != 0
            compliation(nil)
        }
    }
    func getBannerList(page:Int ,compliation: @escaping CompliationHandler) {
        if page == 1 {
            bannerList = []
        }
        Network.shared.request(request: APIRouter.userBanners(page: page), decodable: NewPagingModel<[AdBanner]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.bannerList = response?.data??.banners ?? []
            self.hasMoreBannerAds = (response?.data??.banners ?? []).count > 0
            compliation(nil)
        }
    }
    
    // MARK: - Protected Methods
    func featuredList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            featuredAdsList = []
        }
        Network.shared.request(request: APIRouter.featuredAds(page: page, search: search), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.featuredAdsList.append(contentsOf: response?.data?.ads ?? [])
            self.hasMoreFeaturedAds = (response?.data?.ads ?? []).count != 0
            compliation(nil)
        }
    }
    
    func getRandomProductList(compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.getRandomProducts, decodable: RelatedProductsContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.randomProducts = response?.data?.products ?? []
            compliation(nil)
        }
    }
    
    func getRandomStoresList(compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: StoresRout.getStores(page: 1, category: -1), decodable: StoresData.self) { [weak self] (response, error) in
            if error != nil {
                compliation(error)
                return
            }
//            self?.categories.append(contentsOf: response?.data?.storeCategories ?? [])
            self?.stores = response?.data?.stores ?? []
//            self?.banners = response?.data?.banners ?? []
            compliation(nil)
        }
    }
    
    
    
    func getEllectionFilter(compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.getEllectionFilters, decodable: EllectionFilters.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.ellectionFilters = response?.data
            compliation(nil)
        }
    }
    
    func getEllectionData(governorateId: Int?,districtId: Int? ,compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.getEllectionData(governorate_id: governorateId, district_id: districtId), decodable: EllectionData.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.ellectionData = nil
            self.ellectionData = response?.data
            compliation(nil)
        }
    }
    
    func getEllectionDetails(personId: Int ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getEllectionDetails(person_id: personId), decodable: EllectionPeople.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.ellectionPerson = response?.data
            compliation(nil)
        }
    }
    
    func getAdsCategory(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getAdsCategory, decodable: AdCategoryContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adCategory = response?.data?.adCategories ?? []
            compliation(nil)
        }
    }
    
    
}

