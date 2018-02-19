//
//  SDCameraOverlayViewForOneTarget.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 2/19/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCameraOverlayViewForOneTarget: UIView {

    @IBOutlet weak var targetView: UIView!
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitWithFrame(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInitWithFrame(frame: CGRect) {
        Bundle.main.loadNibNamed(String(describing: SDCameraOverlayViewForOneTarget.self), owner: self, options: nil)
        addSubview(contentView)

        self.contentView.frame = frame

        self.targetView.layer.borderColor = UIColor.red.cgColor
        self.targetView.layer.borderWidth = 2
        self.targetView.backgroundColor = .clear

        self.contentView.backgroundColor = .clear
    }

    func setBorderColorOfAreas(color: UIColor) {
        self.targetView.layer.borderColor = color.cgColor
     }

}
