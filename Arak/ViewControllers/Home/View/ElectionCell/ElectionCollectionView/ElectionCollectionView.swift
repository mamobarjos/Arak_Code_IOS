//
//  ElectionCollectionView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 28/07/2024.
//

import UIKit

class ElectionCollectionView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var shouldAnimate = true
    static let font = UIFont.font(for: .regular, size: 12)
    static let height: CGFloat = 100
    static let horizontalItemPadding: CGFloat = 5

    weak var delegate: HorizontalTagViewDelegate?
    var items: [TagItem] = [] {
        didSet {
//            collectionView.reloadData()
        }
    }

    var selectedItemID: Int? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    var onItemSelection: ((TagItem) -> Void)?
// MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init? (coder Decoder: NSCoder) {
        super.init(coder: Decoder)
        setup()
    }

    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

// MARK: - Private Functions
    private func setup() {
        setupUI()
    }

    private func setupUI() {
        // Load the container view from the nib file
        Bundle.main.loadNibNamed(ElectionCollectionView.className, owner: self, options: nil)
        addSubview(containerView)

        // Set up constraints for the container view
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.register(HorizontalTagCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewLayout {
        // Item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           // Vertical group containing two items (one for each row)
           let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(200))
           let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 2)
           verticalGroup.interItemSpacing = .fixed(10)
           
           // Horizontal group to enable horizontal scrolling
           let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(200))
           let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
           
           // Section
           let section = NSCollectionLayoutSection(group: horizontalGroup)
           section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Helper.appLanguage == "en" ? 0 : 100, bottom: 0, trailing: Helper.appLanguage == "en" ? 100 : 0)
        section.orthogonalScrollingBehavior = .continuous
           
           // Layout
           let layout = UICollectionViewCompositionalLayout(section: section)
           return layout
    }

    public func setupCategories(products: [EllectionPeople]) {
        items = products.map({.init(id: $0.id ?? 0, imageURL: $0.img ?? "", title: $0.name ?? "", storeId: 0)})

//        if products.isEmpty {return}
       
//        selectedItemID = categories.first?.id ?? 1
        self.collectionView.reloadData()
    }
}

extension ElectionCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HorizontalTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item = self.items[indexPath.item]

        cell.categoryNameLabel.text = item.title
        if let url = URL(string: item.imageURL) {
            cell.mainCategoryImageView.sd_setImage(with: url)
        }
        cell.tagIsSelected = item.id == selectedItemID

//        if indexPath.item == items.count - 1 {
//            cell.mainCategoryImageView.image = UIImage(named: "see-all-icon")
//        }

        cell.setup(with: item, animate: self.shouldAnimate)
        cell.onAction = { [weak self] in
//            if item.id != 0 {
//                self?.selectedItemID = item.id
//                self?.onItemSelection?(item)
//                self?.shouldAnimate = false
//            }
            self?.delegate?.didTapItem(item: item)
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shouldAnimate = true
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 80, height: 100)
//       }
//
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//           return 5 // Reduced space between items horizontally
//       }
//
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//           return 5 // Reduced space between items vertically
//       }
}

