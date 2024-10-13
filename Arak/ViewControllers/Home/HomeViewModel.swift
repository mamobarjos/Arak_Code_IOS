//
//  HomeViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation

class HomeViewModel {
    
    // MARK: - Properties
    private var adsList:[Adverisment] = []
    var hasMore: Bool = true
    private var featuredAdsList:[Adverisment] = []
    var hasMoreFeaturedAds: Bool = true
    var hasMoreBannerAds: Bool = true
    var randomProducts: [RelatedProducts] = []
    private var bannerList:[AdBanner] = []
    
    var itemCount: Int {
        return adsList.count
    }
    var itemBannerCount: Int {
        return bannerList.count
    }
    
    // MARK: - Exposed Methods
    func item(at index: Int) -> Adverisment? {
        return index >= adsList.count ? nil : adsList[index]
    }
    
    func getAll() -> [Adverisment] {
        return adsList
    }
    func getAllBanner() -> [AdBanner] {
        return bannerList
    }
    
    var itemFeaturedCount: Int {
        return featuredAdsList.count
    }
    
    func updateAdsFavorate(index: Int)  {
        adsList[index].isFav = !(adsList[index].isFav ?? false)
    }
    
    // MARK: - Exposed Methods
    func itemFeatured(at index: Int) -> Adverisment? {
        return index >= featuredAdsList.count ? nil : featuredAdsList[index]
    }
    
    func itemBanner(at index: Int) -> AdBanner? {
        return bannerList[index]
    }
    
    func getAllFeatured() -> [Adverisment] {
        return featuredAdsList
    }
    
    func removeIte(at index: Int) -> Bool  {
        if index < adsList.count  {
            adsList.remove(at: index)
            return true
        }
        return false
    }
    
    // MARK: - Protected Methods
    
    
    
    
    // MARK: - Protected Methods
    func adsList(page:Int , search:String, adsType: AdsTypes ,compliation: @escaping CompliationHandler) {
        if adsType == .all {
            if page == 1 {
                adsList = []
                bannerList = []
            }
            Network.shared.request(request: APIRouter.adsList(page: page, search: search, ad_category_id: adsType.rawValue), decodable: AdverismentResponse.self) { (response, error) in
                if error != nil {
                    compliation(error)
                    return
                }
                self.adsList.append(contentsOf: response?.data?.ads ?? [])
                self.hasMore = (response?.data?.ads ?? []).count != 0
                compliation(nil)
            }
        } else {
            if page == 1 {
                adsList = []
            }
            Network.shared.request(request: APIRouter.adsFilteredList(page: page, type: adsType.rawValue), decodable: PagingModel<[Adverisment]>.self) { (response, error) in
                if error != nil {
                    compliation(error)
                    return
                }
                self.adsList.append(contentsOf: response?.data?.data ?? [])
                self.hasMore = (response?.data?.data ?? []).count != 0
//                if page == 1 {
//                    self.bannerList = (response?.data?.banners?.data ?? [])
//                    self.hasMoreBannerAds = (response?.data?.banners?.data ?? []).count > 0
//                }
                compliation(nil)
            }
        }
    }
    
    func searchList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.searchAd(title: search), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data?.ads ?? [])
            self.hasMore = false
            compliation(nil)
        }
    }
    
    func getFavorateList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getFavorites(page: page), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data??.data ?? [])
            self.hasMore = (response?.data??.data ?? []).count != 0
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
        Network.shared.request(request: APIRouter.getHistory(page: page), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data??.data ?? [])
            self.hasMore = (response?.data??.data ?? []).count != 0
            compliation(nil)
        }
    }
    
    func getUserAds(page:Int, isFilter: Bool , date_from:String, date_to: String , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getUserAds(page: page, isFilter: isFilter, date_from: date_from, date_to: date_to), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList = response?.data?.ads ?? []
            self.hasMore = false
            compliation(nil)
        }
    }
    func getBannerList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            bannerList = []
        }
        Network.shared.request(request: APIRouter.userBanners(page: page), decodable: PagingModel<[AdBanner]>?.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.bannerList.append(contentsOf: response?.data??.data ?? [])
            self.hasMoreBannerAds = (response?.data??.data ?? []).count > 0
            compliation(nil)
        }
    }
    
    // MARK: - Protected Methods
    func featuredList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            featuredAdsList = []
        }
        Network.shared.request(request: APIRouter.featuredAds(page: page, search: search), decodable: PagingModel<[Adverisment]>.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.featuredAdsList.append(contentsOf: response?.data?.data ?? [])
            self.hasMoreFeaturedAds = (response?.data?.data ?? []).count != 0
            compliation(nil)
        }
    }
    
    func getRandomProductList(compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.getRandomProducts, decodable: [RelatedProducts].self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.randomProducts = response?.data ?? []
            compliation(nil)
        }
    }
}
