//
//  CategoriesViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import UIKit
import WWLayout

protocol CategoriesViewControllerDelegate: AnyObject {
    func didFinishWithCategory(categoryId: Int, categoryName: String)
}

class CategoriesViewController: UIViewController {
    lazy var collectionView = makeCollectionView()

    var selectedIndexPath: IndexPath? = [0, 0]
    private var categories: [StoreCategory] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var selectedCategoryId: Int?
    private var selectedCategoryName: String?
    private var categoryPercentage: Double?
    private var viewModel: CreateStoreViewModel = .init()

    let saveButton = PrimaryActionButton(style: .halfRounded, title: "Save".localiz())

    weak var delegate: CategoriesViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.subviews {
            collectionView
            saveButton
        }

        collectionView.layout
            .top(to: .safeArea)
            .leading(to: .superview)
            .trailing(to: .superview)
            .bottom(to: .superview, offset: -150)

        saveButton.layout
            .trailing(to: .superview, offset: -50)
            .leading(to: .superview, offset: 50)
            .bottom(to: .superview, offset: -75)
            .height(to: 50)

        saveButton.action = { [weak self] in
            guard let self = self else {return}
            self.delegate?.didFinishWithCategory(categoryId: self.selectedCategoryId ?? 1, categoryName: self.selectedCategoryName ?? "")
            self.navigationController?.popViewController(animated: true)
        }

        viewModel.getStoresCategory(compliation: {[weak self] error in
            if let error = error {
                self?.showToast(message: error)
                return
            }
            self?.categories = self?.viewModel.getCategories() ?? []
        })

        self.title = "title.Choose Store Category".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellClass: CategoryCollectionViewCell.self, for: indexPath)
        let item = categories[indexPath.item]
        cell.titleLabel.text = item.name
        if indexPath == selectedIndexPath {
            cell.update(style: .selected)
            selectedCategoryId = item.id
            selectedCategoryName = item.name
        } else {
            cell.update(style: .regular)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        collectionView.reloadData()

    }
}
// MARK: - Collection View Setup
extension CategoriesViewController {
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(cellClass: CategoryCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }

    func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 10, bottom: 20, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        if #available(iOS 14.0, *) {
            configuration.contentInsetsReference = .safeArea
        }
        layout.configuration = configuration
        return layout
    }
}
