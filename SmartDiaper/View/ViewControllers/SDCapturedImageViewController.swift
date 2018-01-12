//
//  SDCapturedImageViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCapturedImageViewController: UIViewController {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!

    var leftImage: UIImage?
    var middleImage: UIImage?
    var rightImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        leftImageView.image = leftImage
        middleImageView.image = middleImage
        rightImageView.image = rightImage
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
