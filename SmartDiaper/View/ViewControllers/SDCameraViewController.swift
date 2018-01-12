//
//  ViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/10/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit

class SDCameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!

    var leftImage: UIImage?
    var middleImage: UIImage?
    var rightImage: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc func captureScreen() {

        if let overlayView = imagePicker.cameraOverlayView as? SDCameraOverlayView {

            if let appDelegate = UIApplication.shared.delegate as? SDAppDelegate {
                let image = screenshotOf(window: appDelegate.window!)

                imageView.image = image

                self.leftImage = self.imageView.snapshot(of: overlayView.leftView.frameInSuperView!)
                self.middleImage = self.imageView.snapshot(of: overlayView.middleView.frameInSuperView!)
                self.rightImage = self.imageView.snapshot(of: overlayView.rightView.frameInSuperView!)
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func takePhoto() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)

        let overlayView = SDCameraOverlayView.init(frame: .zero)
        imagePicker.cameraOverlayView = overlayView

    }

    @IBAction func showCapturedImagesButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: R.segue.sdCameraViewController.sdCapturedImageViewController.identifier,
                          sender: nil)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == R.segue.sdCameraViewController.sdCapturedImageViewController.identifier {
            guard let viewController = R.storyboard.main.sdCapturedImageViewController() else {return}

            viewController.leftImage = self.leftImage
            viewController.middleImage = self.middleImage
            viewController.rightImage = self.rightImage

            self.show(viewController, sender: nil)
        }
    }

    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!",
                                       message: "Your altered image has been saved to your photos.",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let color = image?.pixelColorAtPoint(pos: CGPoint.zero)

        if let overlayView = imagePicker.cameraOverlayView as? SDCameraOverlayView {
            //            print("leftView: \(overlayView.leftView.frame)")
            print("leftView frameInSuperView: \(overlayView.leftView.frameInSuperView)")
            //
            //            print("middleView: \(overlayView.middleView.frame)")
            print("middleView frameInSuperView: \(overlayView.middleView.frameInSuperView)")
            //
            //            print("rightView: \(overlayView.rightView.frame)")
            print("rightView frameInSuperView: \(overlayView.rightView.frameInSuperView)")

            if let appDelegate = UIApplication.shared.delegate as? SDAppDelegate {
                image = screenshotOf(window: appDelegate.window!)
            }

            imageView.image = image

            self.leftImage = self.imageView.snapshot(of: overlayView.leftView.frameInSuperView!)
            self.middleImage = self.imageView.snapshot(of: overlayView.middleView.frameInSuperView!)
            self.rightImage = self.imageView.snapshot(of: overlayView.rightView.frameInSuperView!)

        }
        print(color?.hexValue())

        //        if let appDelegate = UIApplication.shared.delegate as? SDAppDelegate
        //         {
        //
        //            image = screenshotOf(window: appDelegate.window!)
        //        }
        //        imageView.image = image

    }

    func screenshotOf(window: UIWindow) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, true, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        window.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }

}
