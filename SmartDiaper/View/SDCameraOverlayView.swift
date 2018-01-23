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

        self.leftView.layer.borderColor = UIColor.green.cgColor
        self.leftView.layer.borderWidth = 2
        self.leftView.backgroundColor = .clear

        self.middleView.layer.borderColor = UIColor.green.cgColor
        self.middleView.layer.borderWidth = 2
        self.middleView.backgroundColor = .clear

        self.contentView.backgroundColor = .clear
    }

    func setBorderColorOfAreas(color: UIColor) {
        self.leftView.layer.borderColor = color.cgColor
        self.middleView.layer.borderColor = color.cgColor
    }

}
