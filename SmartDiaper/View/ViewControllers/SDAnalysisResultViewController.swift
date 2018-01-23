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

        let colorAnalysis = SDColorAnalysis()

        let specificGravity = colorAnalysis.specificGravityForColor(color: self.leftView.backgroundColor!)
        self.label1.text = "SG: \(String(format: "%.3f", specificGravity!.specificGravityValue))"

        let phValue = colorAnalysis.phValueForColor(color: self.middleView.backgroundColor!)
        self.label2.text = "PH: \(String(format: "%d", phValue!.phValue))"

        self.imageView.isHidden = true
        sampleImage.isHidden = true
        sampleImage2.isHidden = true

        saveResultInDB(specificGravity: specificGravity?.specificGravityValue,
                       phValue: phValue?.phValue)
#if DEBUG
    self.imageView.isHidden = false
    sampleImage.isHidden = false
    sampleImage2.isHidden = false

    let rgbColour = specificGravity?.color.cgColor
    let rgbColours = rgbColour?.components
    let capruredRgb = self.leftView.backgroundColor?.cgColor.components

    print("Caprured Red: \(capruredRgb![0] * 255) Green: \(capruredRgb![1] * 255), Blue: \(capruredRgb![2] * 255)")

    print("Red: \(rgbColours![0] * 255) Green: \(rgbColours![1] * 255), Blue: \(rgbColours![2] * 255)")

    print("specificGravityValue: \(specificGravity!.specificGravityValue)")

#endif
    }

    private func addSubViewAtFrame(frame: CGRect) {
#if DEBUG
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        self.view.addSubview(view)
#endif
    }

    private func saveResultInDB(specificGravity: Double?, phValue: Int?) {

        guard let specificGravity = specificGravity, let phValue = phValue else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: Date())

        let defaults = UserDefaults.standard

        if  var data = defaults.object(forKey: "scan_results") as? [[String: Any]] {

            let dict = ["ph": phValue,
                        "specific_gravity": specificGravity,
                        "date": dateString] as [String: Any]
            data.append(dict)

            defaults.set(data, forKey: "scan_results")

        } else {
            defaults.set(phValue, forKey: "ph")
            defaults.set(specificGravity, forKey: "specific_gravity")

            let dict = ["ph": phValue,
                        "specific_gravity": specificGravity,
                        "date": dateString] as [String: Any]

            var data = [[String: Any]]()
            data.append(dict)
            defaults.set(data, forKey: "scan_results")

        }

        defaults.synchronize()
    }
}
