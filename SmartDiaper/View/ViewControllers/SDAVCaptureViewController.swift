//
//  SDAVCaptureViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit
import RxSwift

class SDAVCaptureViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var showImageButton: UIButton!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var flashButton: UIButton!

    @IBOutlet weak var bottomView: UIView!
    var capturedImage: UIImage!

    private var viewModel: SDAVCaptureViewModel?
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        middleView.layer.borderColor = UIColor(red: 254, green: 252, blue: 247).cgColor
        middleView.layer.borderWidth = 30
        middleView.clipsToBounds = true
        middleView.layer.masksToBounds = true
        middleView.layer.cornerRadius = 35

#if DEBUG
            showImageButton.isHidden = false
#endif

        self.viewModel = SDAVCaptureViewModel()

        addViewModelObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel?.tryToOpenSessionPreviewInsideView(previewView: self.previewView)

        let overlayView = SDCameraOverlayView(frame: self.view.frame)
        self.view.addSubview(overlayView)
        self.view.bringSubview(toFront: self.bottomView)
    }

    override func viewWillDisappear(_ animated: Bool) {

        self.viewModel?.stopSession()

        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == R.segue.sdavCaptureViewController.sdAnalysisResultViewController.identifier {

            guard let viewController = segue.destination as? SDAnalysisResultViewController else {return}
            viewController.image = self.capturedImage
            self.show(viewController, sender: nil)
        }
    }

    private func addViewModelObservers() {
        viewModel?.photoIsCaptured.asObservable().skip(1)
            .subscribe({[weak self] _ in

                DispatchQueue.main.async {

                self?.capturedImage = self?.viewModel?.capturedImage
                    self?.performSegue(withIdentifier:
                    R.segue.sdavCaptureViewController.sdAnalysisResultViewController.identifier,
                                  sender: nil)
                }

            }).disposed(by: disposeBag)

        viewModel?.flashOn.asObservable().skip(1)
            .subscribe({[weak self] value in

                DispatchQueue.main.async {
                    if value.element == true {
                        self?.flashButton.setImage(R.image.flash_off(), for: .normal)
                    } else {
                        self?.flashButton.setImage(R.image.flash_on(), for: .normal)
                    }
                }
            }).disposed(by: disposeBag)

        viewModel?.avSessionFailed.asObservable().skip(1)
            .subscribe({[weak self] value in
                DispatchQueue.main.async {

                    self?.handleCameraSetup(value: value.element!)
                }
            }).disposed(by: disposeBag)
    }

    private func handleCameraSetup(value: SDAVCaptureViewModel.SessionSetupResult) {

        switch value {
        case .success:
            // no need to do anything, view model is handling this part
            break
        case .notAuthorized:
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "AVCam",
                                                        message: "AVCam have no permission to use camera",
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                                 comment: "Alert OK button"),
                                                        style: .cancel, handler: nil))

                alertController.addAction(UIAlertAction(title: "Settings",
                                                        style: .`default`,
                                                        handler: { _ in
                                                            UIApplication.shared.open(URL(string:
                                                                UIApplicationOpenSettingsURLString)!,
                                                                                      options: [:],
                                                                                      completionHandler: nil)
                }))

                self.present(alertController, animated: true, completion: nil)
            }
        case .configurationFailed:

            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "AVCam",
                                                        message: "Unable to capture media",
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                                 comment: "Alert OK button"),
                                                        style: .cancel,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func toggleFlashButtonAction(_ sender: Any) {
        self.viewModel?.toggleFlash()
    }

    @IBAction func capturePhoto(_ sender: Any) {
        self.viewModel?.capturePhoto()
    }

    @IBAction func showImage(_ sender: Any) {
        self.performSegue(withIdentifier:
            R.segue.sdavCaptureViewController.sdAnalysisResultViewController.identifier,
                          sender: nil)

    }

#if DEBUG
    deinit {
        print("deinit")
    }
#endif

}
