//
//  SectionBoundary+Title.swift
//  Arak
//
//  Created by Osama Abu Hdba on 21/02/2023.
//

import UIKit

extension NSCollectionLayoutBoundarySupplementaryItem {
    static func title(withPadding: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(withPadding ? 0.9 : 1 ), heightDimension: .estimated(40))

        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .top)
    }
}
