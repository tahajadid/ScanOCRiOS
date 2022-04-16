//
//  UIViewExtension.swift
//  inwiOCR
//
//  Created by taha_jadid on 14/4/2022.
//


import UIKit
/*
 This class is extension of UIView
 */
extension UIView {

    /*
     This Fuction to used to add a view to its parent view using constraints programmatically
     */
    func fixConstraintsToView(_ container: UIView, positionType: ViewPostion, top: CGFloat?, right: CGFloat?, bottom: CGFloat?, left: CGFloat?) {
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch positionType {
        case .margin:
            if top != nil {
                let const = NSLayoutConstraint(item: self,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: container,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: top!)
                const.identifier = "topAnchorConst"
                const.isActive = true
            }
            
            if right != nil {
                let const = NSLayoutConstraint(item: self,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: container,
                                               attribute: .trailing,
                                               multiplier: 1.0,
                                               constant: right! * -1)
                const.identifier = "rightAnchorConst"
                const.isActive = true
            }
            
            if bottom != nil {
                let const = NSLayoutConstraint(item: self,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: container,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: bottom! * -1)
                const.identifier = "bottomAnchorConst"
                const.isActive = true
            }
            
            if left != nil {
                let const = NSLayoutConstraint(item: self,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: container,
                                   attribute: .leading,
                                   multiplier: 1.0,
                                   constant: left!)
                const.identifier = "leftAnchorConst"
                const.isActive = true
            }
        }
    }
    
    func setOnClickListener(target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    /*
     This function is to remove subViews
     */
    func removeSubViews() {
        self.subviews.forEach { mView in
            mView.removeFromSuperview()
            mView.removeSubViews()
        }
    }
    
    
    /*
     This enum is used to set the view's location using the function on this file "fixConstraintsToView(..)"
     */
    enum ViewPostion {
        case margin
    }

}
