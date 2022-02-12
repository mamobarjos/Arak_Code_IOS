//
//  ScrollContainerView.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

class ScrollContainerView: UIView {
    /**
     The view containing the scroll view
     */
    let scrollViewContainerView: UIView = UIView()

    /**
     The actual scroll view
     */
    let scrollView: UIScrollView = UIScrollView()

    /**
     The content container, inside the sroll view
     */
    let contentContainerView: UIView = UIView()

    /**
     The content view itself :)
     */
    let contentView: UIView

    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }

    fileprivate func setup() {
        addViews()
        addConstraints()
        setupContents(with: contentContainerView)
    }

    fileprivate func addViews() {
        addSubview(scrollViewContainerView)
        scrollViewContainerView.addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
    }

    fileprivate func addConstraints() {
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollViewContainerView.layout.fill(.superview)
        scrollView.layout.fill(.superview)
        contentContainerView.layout.fill(.superview)

        contentContainerView.widthAnchor.constraint(equalTo: scrollViewContainerView.widthAnchor).isActive = true

        let constraint = contentContainerView.heightAnchor.constraint(equalTo: scrollViewContainerView.heightAnchor)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }

    fileprivate func setupContents(with containerView: UIView) {
        containerView.addSubview(contentView)
        contentView.layout.top(to: .superview)
            .leading(to: .superview)
            .trailing(to: .superview)
            .bottom(.lessOrEqual, to: .superview, edge: .bottom, offset: 1)

        contentView.backgroundColor = .clear
        contentContainerView.backgroundColor = .clear
        scrollViewContainerView.backgroundColor = .clear
    }
}
