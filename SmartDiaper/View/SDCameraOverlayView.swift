//
//  SDCameraOverlayView.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/10/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCameraOverlayView: UIView {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!

    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitWithFrame(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInitWithFrame(frame: CGRect) {
        Bundle.main.loadNibNamed(String(describing: SDCameraOverlayView.self), owner: self, options: nil)
        addSubview(contentView)

//        contentView.translatesAutoresizingMaskIntoConstraints = false // so that we can change the frame dynamically
//        contentView.frame = self.bounds

        self.leftView.layer.borderColor = UIColor.green.cgColor
        self.leftView.layer.borderWidth = 2
        self.leftView.backgroundColor = .clear

        self.middleView.layer.borderColor = UIColor.green.cgColor
        self.middleView.layer.borderWidth = 2
        self.middleView.backgroundColor = .clear

        self.contentView.backgroundColor = .clear

//        let verticalConstraintForContentView = NSLayoutConstraint(item: contentView,
//                                                                  attribute: NSLayoutAttribute.bottom,
//                                                                  relatedBy: NSLayoutRelation.equal,
//                                                                  toItem: self,
//                                                                  attribute: NSLayoutAttribute.top,
//                                                                  multiplier: 1,
//                                                                  constant: 0)
//
//        let horizontalConstraintForContentView = NSLayoutConstraint(item: contentView,
//                                                                    attribute: NSLayoutAttribute.centerX,
//                                                                    relatedBy: NSLayoutRelation.equal, toItem: self,
//                                                                    attribute: NSLayoutAttribute.centerX,
//                                                                    multiplier: 1,
//                                                                    constant: 0)
//
//        let widthConstraintForContentView = NSLayoutConstraint(item: contentView,
//                                                               attribute: NSLayoutAttribute.width,
//                                                               relatedBy: NSLayoutRelation.lessThanOrEqual,
//                                                               toItem: nil,
//                                                               attribute: NSLayoutAttribute.notAnAttribute,
//                                                               multiplier: 1,
//                                                               constant: 200)
//
//        NSLayoutConstraint.activate([verticalConstraintForContentView,
//                                     horizontalConstraintForContentView,
//                                     widthConstraintForContentView])

//        self.contentView.layoutIfNeeded()
    }

    func setBorderColorOfAreas(color: UIColor) {
        self.leftView.layer.borderColor = color.cgColor
        self.middleView.layer.borderColor = color.cgColor
    }

}
