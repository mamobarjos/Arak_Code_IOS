//
//  RankViewModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 09/07/2021.
//

import Foundation
class RankViewModel {
    private var rankList: [User] = []
    var hasMore = true
    var itemCount: Int {
        return rankList.count
    }
    
    func item(at index: Int) -> User  {
        return rankList[index]
    }

    func getTopRanking(page: Int,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getTopRanked(page: page), decodable: PagingModel<[User]>.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            if page == 1 {
                self.rankList = []
            }
            self.hasMore = (response?.data?.data ?? []).count != 0
            self.rankList.append(contentsOf: response?.data?.data ?? [])
            compliation(nil)
        }
    }
}
