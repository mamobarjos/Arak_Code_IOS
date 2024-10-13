//
//  HorizontalTagView.swift
//  CARDIZERR
//
//  Created by Osama Abu Hdba on 11/02/2023.
//

import UIKit

protocol HorizontalTagViewDelegate: AnyObject {
    func didTapItem(item: TagItem)
}

class HorizontalTagView: UIView {
    
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
        Bundle.main.loadNibNamed(HorizontalTagView.className, owner: self, options: nil)
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

    }

    public func setupCategories(products: [RelatedProducts]) {
        items = products.map({.init(id: $0.id ?? 0, imageURL: $0.storeProductFiles?.first?.path ?? "", title: $0.name ?? "", storeId: $0.storeid ?? 0)})

        if products.isEmpty {return}
       
//        selectedItemID = categories.first?.id ?? 1
        self.collectionView.reloadData()
    }

    private func calculateTagWidth(_ item: TagItem) -> CGFloat {
        var width: CGFloat = 0

        width += item.title.width(with: HorizontalTagView.font) + 1 // add text size
        width += 5

        if width < 65 {
            return 65
        } else {
            return width
        }
    }
}

extension HorizontalTagView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HorizontalTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item = self.items[indexPath.item]

        cell.categoryNameLabel.text = item.title
        
        if item.id == -1 {
            cell.mainCategoryImageView.image = UIImage(named: "all_Category_icon")
            cell.mainCategoryImageView.contentMode = .scaleAspectFit
        } else {
            cell.mainCategoryImageView.kf.setImage(with: URL(string: item.imageURL))
            cell.mainCategoryImageView.contentMode = .scaleToFill
        }
       
       
        cell.tagIsSelected = item.id == selectedItemID

//        if indexPath.item == items.count - 1 {
//            cell.mainCategoryImageView.image = UIImage(named: "see-all-icon")
//        }

        cell.setup(with: item, animate: self.shouldAnimate)
        cell.onAction = { [weak self] in
//            if item.id != 0 {
                self?.selectedItemID = item.id
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 80, height: HorizontalTagView.height)
    }
}

extension String {
    func width(with font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin],
                                           attributes: [.font: font],
                                           context: nil)
        return ceil(actualSize.width)
    }
}

struct TagItem: Equatable {
    let id: Int
    let imageURL: String
    let title: String
    let storeId: Int
}
