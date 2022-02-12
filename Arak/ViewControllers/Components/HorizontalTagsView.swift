//
//  HorizontalTagsView.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit
import WWLayout

class HorizontalTagsView: ViewWithSetup {
    static let font = UIFont.font(for: .regular, size: 11)
    static let height: CGFloat = 26
    static let horizontalItemPadding: CGFloat = 15

    lazy var collectionView = createCollectionView()

    var items: [TagItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var selectedItemID: Int? {
        didSet {
            collectionView.reloadData()
        }
    }

    var onItemSelection: ((TagItem) -> Void)?

    override func setup() {

        addSubview(collectionView)
        collectionView.layout
            .fill(.superview)
    }

    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 26)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(cellClass: TagCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 25, bottom: 0, right: 25)

        return collectionView
    }

    override var intrinsicContentSize: CGSize {
        .init(width: Self.noIntrinsicMetric, height: 40)
    }

    private func calculateTagWidth(_ item: TagItem) -> CGFloat {
        var width: CGFloat = 0

        width += item.title.width(with: HorizontalTagsView.font) + 1 // add text size
        width += 2 * HorizontalTagsView.horizontalItemPadding  // add paddings
        width += 5 // well, that's a tip for me :)

        return width
    }
}

extension HorizontalTagsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellClass: TagCell.self, for: indexPath)
        let item = self.items[indexPath.item]

        cell.label.text = item.title
        cell.tagIsSelected = item.id == selectedItemID

        if item.id == selectedItemID {
            let index = items.firstIndex(of: item) ?? 0
//            self.collectionView.contentOffset.x = CGFloat(100 * (index ?? 0))
            self.collectionView.scrollToItem(at: [0,Int(index)], at: .centeredHorizontally, animated: true)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        selectedItemID = item.id
        onItemSelection?(item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: ceil(calculateTagWidth(items[indexPath.item])), height: HorizontalTagsView.height)
    }
}

extension HorizontalTagsView {
    struct TagItem: Equatable {
        let id: Int
        let title: String
    }
}

extension HorizontalTagsView {
    class TagCell: UICollectionViewCell {
        let label = UILabel().then {
            $0.font = HorizontalTagsView.font
            $0.textAlignment = .center
        }

        var tagIsSelected: Bool = false {
            didSet {
//                contentView.animateBorderColor(fromValue: .text, toColor: .accentOrange, duration: 0.5)

//                contentView.layer.borderWidth = tagIsSelected ? 1 : 0
                contentView.backgroundColor = tagIsSelected ? .accentOrange : .background
                label.textColor = tagIsSelected ? .background : .text
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        func setup() {
            backgroundColor = .background
            contentView.backgroundColor = .background

            contentView.addSubview(label)
            label.layout
                .leading(to: .superview, offset: HorizontalTagsView.horizontalItemPadding)
                .trailing(to: .superview, offset: -HorizontalTagsView.horizontalItemPadding)
                .top(to: .superview, offset: 5)
                .bottom(to: .superview, offset: -5)

        }

        override func layoutSubviews() {
            super.layoutSubviews()
            contentView.layer.cornerRadius = 7
            contentView.dropShadow(color: .lightGray, opacity: 3, offSet: CGSize(width: 3, height: 3), radius: 3)
        }
    }
}

private extension String {
    func width(with font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin],
                                           attributes: [.font: font],
                                           context: nil)
        return ceil(actualSize.width)
    }
}

extension UIView {
    func animateBorderColor(fromValue: UIColor ,toColor: UIColor, duration: Double) {
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = fromValue.cgColor
    animation.toValue = toColor.cgColor
    animation.duration = duration
    layer.add(animation, forKey: "borderColor")
    layer.borderColor = toColor.cgColor
  }
}
