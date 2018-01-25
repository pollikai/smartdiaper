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

    private var viewModel: SDAnalysisResultViewModel?

    var image: UIImage!

    var overlayView: SDCameraOverlayView?
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var sampleImage: UIImageView!
    @IBOutlet weak var sampleImage2: UIImageView!

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

        viewModel = SDAnalysisResultViewModel()

        self.imageView.contentMode = .scaleAspectFill

        self.imageView.image = image

        self.overlayView = SDCameraOverlayView.init(frame: .zero)
        self.imageView.addSubview(self.overlayView!)

        self.overlayView?.setBorderColorOfAreas(color: .clear)
        // System taking correct frame in snapshot once we calll this function
        self.view.snapshot(of: self.overlayView?.leftView.frameInSuperView) // FIXME:

        sampleImage.image = self.view.snapshot(of: self.overlayView?.leftView.frameInSuperView)
        addSubViewAtFrame(frame: (self.overlayView?.leftView.frameInSuperView)!) // for debugging

        self.leftView.backgroundColor = sampleImage.image?.areaAverageColor()

        sampleImage2.image = self.view.snapshot(of: self.overlayView?.middleView.frameInSuperView)
        addSubViewAtFrame(frame: (self.overlayView?.middleView.frameInSuperView)!) // for debugging

        self.middleView.backgroundColor = sampleImage2.image?.areaAverageColor()

        let specificGravityValueString = self.viewModel?.specificGravityForColor(color: self.leftView.backgroundColor!)
        self.label1.text = "SG: \(specificGravityValueString ?? "")"

        let phValueString = self.viewModel?.phValueForColor(color: self.middleView.backgroundColor!)
        self.label2.text = "PH: \(phValueString ?? "")"

        self.imageView.isHidden = true
        sampleImage.isHidden = true
        sampleImage2.isHidden = true

#if DEBUG
    self.imageView.isHidden = false
    sampleImage.isHidden = false
    sampleImage2.isHidden = false

    let rgbColour = self.leftView.backgroundColor?.cgColor
    let rgbColours = rgbColour?.components
    let capruredRgb = self.leftView.backgroundColor?.cgColor.components

    print("Caprured Red: \(capruredRgb![0] * 255) Green: \(capruredRgb![1] * 255), Blue: \(capruredRgb![2] * 255)")

    print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

    print("specificGravityValue: \(specificGravityValueString)")

#endif
    }

    private func addSubViewAtFrame(frame: CGRect) {
#if DEBUG
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        self.view.addSubview(view)
#endif
    }

}
