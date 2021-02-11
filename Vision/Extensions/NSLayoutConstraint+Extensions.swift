//
//  NSLayoutConstraint+Extensions.swift
//  Bmore
//
//  Created by Idan Moshe on 07/02/2021.
//

import UIKit

extension NSLayoutConstraint {
    
    /// Autolayout convenience method for matching a subview's layout to its superview
    /// Providing edge insets will shrink the subview as requested
    /// Optionally respects safe area insets of the superview, as desired
    /// Custom insets are additive to the safe area insets (left inset of 8 and safeAreaInsets.left of 8 == total inset of 16 points)
    /// - Parameters:
    ///   - view: the view to be contained, aka the new subview
    ///   - containerView: the view to do the containing, aka the new superview
    ///   - insets: Insets defining layout of the subview in relation to the superview. Provide .zero for a perfect match
    ///   - respectsSafeArea: whether to respect the containerView's safe area insets (iOS 11.0+)
    static func contain(view: UIView, in containerView: UIView, withInsets insets: UIEdgeInsets, respectingSafeAreaInsets respectsSafeArea: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(view)

        let identifierHeader = String(describing: type(of: view))

        let leadingAnchor: NSLayoutXAxisAnchor
        let trailingAnchor: NSLayoutXAxisAnchor
        let topAnchor: NSLayoutYAxisAnchor
        let bottomAnchor: NSLayoutYAxisAnchor

        leadingAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.leadingAnchor : containerView.leadingAnchor
        trailingAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.trailingAnchor : containerView.trailingAnchor
        topAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.topAnchor : containerView.topAnchor
        bottomAnchor = respectsSafeArea ? containerView.safeAreaLayoutGuide.bottomAnchor : containerView.bottomAnchor

        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left)
        leading.identifier = identifierHeader + "_containmentLeading"

        let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right * -1.0)
        trailing.identifier = identifierHeader + "_containmentTrailing"

        let top = view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        top.identifier = identifierHeader + "_containmentTop"

        let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom * -1.0)
        bottom.identifier = identifierHeader + "_containmentBottom"

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
}
