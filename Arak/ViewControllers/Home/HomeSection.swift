//
//  HomeSection.swift
//  Arak
//
//  Created by Osama Abu Hdba on 21/02/2023.
//

import Foundation

enum HomeSectionIdentifier: Int, CaseIterable, Comparable, Equatable {
    case banners = 0
    case ellection
    case ellectionBanner
    case SpecialAds
    case randomProducts
    case Ads

    var requiresAuthentication: Bool {
        switch self {
        case .banners: return false
        case .randomProducts: return false
        case .ellection: return false
        case .ellectionBanner: return false
        case .Ads: return false
        case .SpecialAds: return false
        }
    }

    var isInitial: Bool {
        switch self {
        case .banners: return true
        case .randomProducts: return true
        case .ellection: return true
        case .ellectionBanner: return true
        case .Ads: return true
        case .SpecialAds: return false
        }
    }

    var order: Int {
        rawValue
    }

    static func < (lhs: HomeSectionIdentifier, rhs: HomeSectionIdentifier) -> Bool {
        lhs.order < rhs.order
    }
}

enum HomeSection: Comparable, Equatable {
    case banners([AdBanner])
    case randomProducts([RelatedProducts])
    case ellection([EllectionPeople])
    case ellectionBanner([EllectionDataBanner])
    case SpecialAds([Adverisment])
    case Ads([Adverisment])

    var title: String? {
        switch self {
        case .banners: return nil
        case .randomProducts: return "label.home.categories".localiz()
        case .ellection: return ""
        case .ellectionBanner: return ""
        case .Ads: return nil
        case .SpecialAds: return "label.home.popularproducts".localiz()
        }
    }

    var hasSeeMore: Bool {
        switch self {
        case .banners: return false
        case .randomProducts: return false
        case .ellection: return true
        case .ellectionBanner: return true
        case .SpecialAds: return true
        case .Ads: return false
        }
    }

    var numberOfItems: Int {
        switch self {
        case .banners(let items): return items.isEmpty ? 0 : 1
        case .randomProducts(let items): return items.count
        case .ellection(let items): return items.count
        case .ellectionBanner(let items): return items.count
        case .SpecialAds(let items): return items.count
        case .Ads(let items): return items.count
        }
    }

    var identifier: HomeSectionIdentifier {
        switch self {
        case .banners: return .banners
        case .randomProducts: return .randomProducts
        case .ellection: return .ellection
        case .ellectionBanner: return .ellectionBanner
        case .SpecialAds: return .SpecialAds
        case .Ads: return .Ads
        }
    }

    static func < (lhs: HomeSection, rhs: HomeSection) -> Bool {
        lhs.identifier < rhs.identifier
    }

    static func == (lhs: HomeSection, rhs: HomeSection) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension Array where Element == HomeSection {
    func diff(for new: [HomeSection], condition: Bool = true) -> [HomeSection] {
        var newArray: [HomeSection] = new
        for element in self {
            if !(newArray.contains { $0.identifier == element.identifier }) {
                newArray.append(element)
            }
        }

        return newArray.sorted().filter { $0.numberOfItems > 0 }
    }
}
