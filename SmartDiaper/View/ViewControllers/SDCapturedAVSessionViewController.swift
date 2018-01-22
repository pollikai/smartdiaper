//
//  SDCapturedAVSessionViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCapturedAVSessionViewController: UIViewController {

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

    @IBAction func backButtonAction(_ sender: Any) {

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

        let leftViewColor = image?.pixelColorAtPoint(pos: (self.overlayView?.leftView.centerInSuperView)!)
        self.leftView.backgroundColor = leftViewColor

//        addPixelViewAtPoint(point: (self.overlayView?.leftView.centerInSuperView)!)

//        addPixelViewAtFrame(frame: (self.overlayView?.leftView.frameInSuperView)!)

         sampleImage.image = self.imageView.snapshot(of: self.overlayView?.leftView.frameInSuperView)

        self.leftView.backgroundColor = sampleImage.image?.areaAverageColor()

        let colorAnalysis = SDColorAnalysis()

        //                           (red: 23, green: 42, blue: 46)
        let mycolor = sampleImage.image?.areaAverageColor()

        let sg = colorAnalysis.specificGravityForColor(color: mycolor!)
        let rgbColour = sg?.color.cgColor
        let rgbColours = rgbColour?.components

        let capruredRgbColours = mycolor?.cgColor.components
        print("Caprured Red: \(capruredRgbColours![0] * 255) Green: \(capruredRgbColours![1] * 255), Blue: \(capruredRgbColours![2] * 255)")

        print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

        print("specificGravityValue: \(sg!.specificGravityValue)")

    }

   func shotCrop() {

    }

    private func addPixelViewAtPoint(point: CGPoint) {
        let pixelView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        pixelView.center = point
        pixelView.backgroundColor = .red
        self.imageView.addSubview(pixelView)

    }

    private func addPixelViewAtFrame(frame: CGRect) {
        let pixelView = UIView(frame: frame)
        pixelView.backgroundColor = .red
        self.imageView.addSubview(pixelView)

    }

}
