//
//  SDAnalysisResultViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/22/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDAnalysisResultViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage!

    var leftImage: UIImage?
    var middleImage: UIImage?
    var rightImage: UIImage?

    var overlayView: SDCameraOverlayView?
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var sampleImage: UIImageView!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    @IBAction func backButtonAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func scanAgainButtonAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.image = image.resized(toWidth: self.imageView.frame.width)
        self.imageView.image = image

        self.overlayView = SDCameraOverlayView.init(frame: .zero)
        self.imageView.addSubview(self.overlayView!)

        sampleImage.image = self.imageView.snapshot(of: self.overlayView?.leftView.frameInSuperView)

        self.leftView.backgroundColor = sampleImage.image?.areaAverageColor()

        sampleImage.image = self.imageView.snapshot(of: self.overlayView?.middleView.frameInSuperView)

        self.middleView.backgroundColor = sampleImage.image?.areaAverageColor()

        let colorAnalysis = SDColorAnalysis()

        let specificGravitySampleColor = sampleImage.image?.areaAverageColor()

        let specificGravity = colorAnalysis.specificGravityForColor(color: self.leftView.backgroundColor!)

        self.label1.text = "SG: \(String(format: "%.3f", specificGravity!.specificGravityValue))"

        let phValue = colorAnalysis.phValueForColor(color: self.middleView.backgroundColor!)

//        let specificGravity = colorAnalysis.specificGravityForColor(color: mycolor!)

#if !DEBUG
//    self.imageView.isHidden = true

    let rgbColour = specificGravity?.color.cgColor
    let rgbColours = rgbColour?.components
    let capruredRgb = specificGravitySampleColor?.cgColor.components

    print("Caprured Red: \(capruredRgb![0] * 255) Green: \(capruredRgb![1] * 255), Blue: \(capruredRgb![2] * 255)")

    print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

    print("specificGravityValue: \(specificGravity!.specificGravityValue)")

#endif
    }
}
