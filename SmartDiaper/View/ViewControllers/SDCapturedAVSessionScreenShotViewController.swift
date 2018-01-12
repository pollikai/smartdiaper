//
//  SDCapturedAVSessionScreenShotViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCapturedAVSessionScreenShotViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = image

    }

}
