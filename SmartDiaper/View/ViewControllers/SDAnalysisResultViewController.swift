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
    @IBOutlet weak var sampleImage: UIImageView!
    @IBOutlet weak var sampleImage2: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var scanAgainButton: UIButton!
    @IBOutlet weak var saveResultButton: UIButton!

    @IBAction func saveResultsButtonAction(_ sender: Any) {
        self.viewModel?.saveData()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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

        saveResultButton.layer.cornerRadius = 5.0

        scanAgainButton.layer.cornerRadius = 5.0
        scanAgainButton.layer.borderColor = UIColor(red: 243, green: 134, blue: 96).cgColor
        scanAgainButton.layer.borderWidth = 1.0

        leftView.layer.cornerRadius = 5.0
        middleView.layer.cornerRadius = 5.0

        self.imageView.contentMode = .scaleAspectFill

        self.imageView.image = image

        self.overlayView = SDCameraOverlayView(frame: self.view.frame)
        self.overlayView?.setBorderColorOfAreas(color: .clear)
        self.view.addSubview(self.overlayView!)

        // System correct frame in snapshot once we call this function
        // FIXME: Need to call this function as drawHierarchy(in: bounds, afterScreenUpdates: true)
        self.view.snapshot(of: self.overlayView?.leftView.frameInSuperView)
        //somehow force autolayout to set and we have desired frame for our views

        let leftDotFrame = self.overlayView?.leftView.frameInSuperView
        // self.overlayView?.leftView.frameInSuperView.frme =
        //self.overlayView.contentView = self.imageview.frame = self.view.frame
        sampleImage.image = self.view.snapshot(of: leftDotFrame)

        self.leftView.backgroundColor = sampleImage.image?.areaAverageColor()

        let rightDotFrame = self.overlayView?.middleView.frameInSuperView

        sampleImage2.image = self.view.snapshot(of: rightDotFrame)

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

    leftView.isHidden = true
    middleView.isHidden = true

    let rgbColour = self.leftView.backgroundColor?.cgColor
    let rgbColours = rgbColour?.components
    let capruredRgb = self.leftView.backgroundColor?.cgColor.components

    addSubViewAtFrame(frame: leftDotFrame!) // for debugging

    addSubViewAtFrame(frame: rightDotFrame!) // for debugging

    print("Caprured Red: \(capruredRgb![0] * 255) Green: \(capruredRgb![1] * 255), Blue: \(capruredRgb![2] * 255)")

    print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

    print("specificGravityValue: \(String(describing: specificGravityValueString))")

#endif
    }

    private func addSubViewAtFrame(frame: CGRect) {
#if DEBUG
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        self.view.addSubview(view)
#endif
    }

#if DEBUG
    deinit {
        print("deinit")
    }
#endif

}
