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

        DispatchQueue.main.async { [unowned self] in
            // Use main queue to compute things as UI frames depends on autolayout, and autolayout must se frames in main queue
            self.performAnalysisForColorName()

            #if DEBUG
                self.imageView.isHidden = false
                self.sampleImage.isHidden = false
                self.sampleImage2.isHidden = false

                self.leftView.isHidden = true
                self.middleView.isHidden = true

                let rgbColour = self.leftView.backgroundColor?.cgColor
                let rgbColours = rgbColour?.components
                let capruredRgb = self.leftView.backgroundColor?.cgColor.components

                print("Caprured Red:\(capruredRgb![0] * 255) Green:\(capruredRgb![1] * 255),Blue: \(capruredRgb![2] * 255)")

                print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

            #endif

        }
    }

    private func performAnalysis() {

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

        self.overlayView?.removeFromSuperview()

        self.commonDebugTasks(leftDotFrame: leftDotFrame, rightDotFrame: rightDotFrame)

    }

    private func performAnalysisForColorName() {

        let leftDotFrame = self.overlayView?.leftView.frameInSuperView

        sampleImage.image = self.view.snapshot(of: leftDotFrame)

        self.leftView.backgroundColor = sampleImage.image?.areaAverageColor()

        let rightDotFrame = self.overlayView?.middleView.frameInSuperView

        sampleImage2.image = self.view.snapshot(of: rightDotFrame)

        self.middleView.backgroundColor = sampleImage2.image?.areaAverageColor()

        let name = self.viewModel?.nameForColorValue(color: self.leftView.backgroundColor!)
        self.label1.text = "name: \(name ?? "")"

        let name2 = self.viewModel?.nameForColorValue(color: self.middleView.backgroundColor!)
        self.label2.text = "name2: \(name2 ?? "")"

        self.imageView.isHidden = true
        sampleImage.isHidden = true
        sampleImage2.isHidden = true

        self.overlayView?.removeFromSuperview()

        self.commonDebugTasks(leftDotFrame: leftDotFrame, rightDotFrame: rightDotFrame)
    }

    private func commonDebugTasks(leftDotFrame: CGRect?, rightDotFrame: CGRect?) {

        guard let leftDotFrameValue = leftDotFrame, let rightDotFrameValue = rightDotFrame else {return}

        #if DEBUG
            addSubViewAtFrame(frame: leftDotFrameValue)

            addSubViewAtFrame(frame: rightDotFrameValue)
        #endif

    }

    private func addSubViewAtFrame(frame: CGRect) {
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        self.view.addSubview(view)
    }

#if DEBUG
    deinit {
        print("deinit")
    }
#endif

}
