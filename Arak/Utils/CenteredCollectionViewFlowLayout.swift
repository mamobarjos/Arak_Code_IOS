//
//  CenteredCollectionViewFlowLayout.swift
//  Arak
//
//  Created by Osama Abu Hdba on 22/07/2024.
//

import Foundation
import UIKit

class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let collectionViewBounds = collectionView.bounds
        let halfWidth = collectionViewBounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        if let attributesForVisibleCells = layoutAttributesForElements(in: collectionViewBounds) {
            var candidateAttribute: UICollectionViewLayoutAttributes?
            for attributes in attributesForVisibleCells {
                if candidateAttribute == nil {
                    candidateAttribute = attributes
                    continue
                }
                
                if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttribute!.center.x - proposedContentOffsetCenterX) {
                    candidateAttribute = attributes
                }
            }
            
            if let candidateAttributes = candidateAttribute {
                let newOffsetX = candidateAttributes.center.x - halfWidth
                return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
            }
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}
