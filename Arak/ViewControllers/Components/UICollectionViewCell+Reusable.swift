//
//  UICollectionViewCell+Reusable.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

protocol Identifiable: AnyObject {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return String(describing: self) }
}

extension NSObject: Identifiable { }

protocol ReusableCell: Identifiable { }

protocol ReusableView: Identifiable { }

extension UICollectionViewCell: ReusableCell { }

extension UITableViewCell: ReusableCell {}

extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
    func register(cellClass: ReusableCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }

    func register(reusableViewClass: ReusableView.Type, for kind: String) {
        register(reusableViewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableViewClass.identifier)
    }

    func dequeueCell<T: ReusableCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }

    func dequeReusableView<T: ReusableView>(reusableViewType: T.Type,
                                            kind: String,
                                            for indexPath: IndexPath) -> T {
        guard let supplementary = dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: reusableViewType.identifier,
                                                                   for: indexPath) as? T else {
            fatalError()
        }

        return supplementary
    }
}

extension UITableView {
    func dequeueCell<T: ReusableCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }

    func register(cellClass: ReusableCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}
