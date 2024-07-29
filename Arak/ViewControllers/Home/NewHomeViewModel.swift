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
    
    var itemCount: Int {
        return adsList.count
    }
    var itemBannerCount: Int {
        return bannerList.count
    }
    

    // MARK: - Protected Methods
    func adsList(page:Int , search:String, adsType: AdsTypes ,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
            bannerList = []
        }
        Network.shared.request(request: APIRouter.adsList(page: page, search: search), decodable: AdverismentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.adsList.append(contentsOf: response?.data?.ads?.data ?? [])
            self.hasMore = (response?.data?.ads?.data ?? []).count != 0
            if page == 1 {
                self.bannerList = (response?.data?.banners?.data ?? [])
                self.hasMoreBannerAds = (response?.data?.banners?.data ?? []).count > 0
            }
            compliation(nil)
        }
    }
    
    func searchList(page:Int , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.adsList(page: page, search: search), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
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
    
    func getUserAds(page:Int, isFilter: Bool , year:String, month: String , search:String,compliation: @escaping CompliationHandler) {
        if page == 1 {
            adsList = []
        }
        Network.shared.request(request: APIRouter.getUserAds(page: page, isFilter: isFilter, year: year, month: month), decodable: PagingModel<[Adverisment]>?.self) { (response, error) in
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
