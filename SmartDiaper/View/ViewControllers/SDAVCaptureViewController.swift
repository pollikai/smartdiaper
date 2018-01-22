//
//  SDAVCaptureViewController.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/11/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit
import AVFoundation

class SDAVCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    enum SDAVCaptureError: Error {
        case noVideoInout(Error)
    }
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoButton: UIButton!

    var leftImage: UIImage?
    var middleImage: UIImage?
    var rightImage: UIImage?
    var overlayView: SDCameraOverlayView?

    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let sessionQueue = DispatchQueue(label: "session queue",
                                     attributes: [],
                                     target: nil)

    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoDeviceInput: AVCaptureDeviceInput!
    var setupResult: SessionSetupResult = .success

    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        checkAuthorization()

        /*
         Setup the capture session.
         In general it is not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.
         
         Why not do all of this on the main queue?
         Because AVCaptureSession.startRunning() is a blocking call which can
         take a long time. We dispatch session setup to the sessionQueue so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only start the session running if setup succeeded.
                DispatchQueue.main.async { [unowned self] in
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.previewLayer.frame = self.previewView.bounds
                    self.previewView.layer.addSublayer(self.previewLayer)
                    self.session.startRunning()

//                    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

//                    self.view.layer.addSublayer(self.previewLayer)

                    self.overlayView = SDCameraOverlayView.init(frame: .zero)

                    self.previewView.layer.addSublayer(self.previewLayer)

                    self.view.addSubview(self.overlayView!)

                }

            case .notAuthorized:
                DispatchQueue.main.async { [unowned self] in
                    let changePrivacySetting = "AVCam have no permission to use camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting,
                                                    comment: "Alert message when user has denied access to the camera")
                    let alertController = UIAlertController(title: "AVCam",
                                                            message: message,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel, handler: nil))

                    alertController.addAction(UIAlertAction(title:
                        NSLocalizedString("Settings", comment: "Alert button to open Settings"),
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
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async { [unowned self] in
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }

        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == R.segue.sdavCaptureViewController.sdCapturedAVSessionViewController.identifier {
            guard let viewController = R.storyboard.main.sdCapturedAVSessionViewController() else {return}

            viewController.image = self.capturedImage.image
            self.show(viewController, sender: nil)

        } else if segue.identifier == R.segue.sdavCaptureViewController.sdAnalysisResultViewController.identifier {

            guard let viewController = R.storyboard.main.sdAnalysisResultViewController() else {return}
            viewController.image = self.capturedImage.image
            self.show(viewController, sender: nil)
        }
    }

    // MARK: Session Management

    func checkAuthorization() {
        /*
         Check video authorization status. Video access is required and audio
         access is optional. If audio access is denied, audio is not recorded
         during movie recording.
         */
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break

        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. We suspend the session queue to delay session
             setup until the access request has completed.
             
             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })

        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
    }

    private func configureSession() {
        if setupResult != .success {
            return
        }

        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo

        do {
            try self.addVieoInput(text: "")
        } catch let error as NSError {

            print("Caught NSError: \(error.localizedDescription), \(error.domain), \(error.code)")

            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }

        // Add photo output.
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)

            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        } else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()
    }

    private func addVieoInput(text: String) throws {
        do {
            var defaultVideoDevice: AVCaptureDevice?

            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            if let dualCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera,
                                                              for: AVMediaType.video,
                                                              position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                                     for: AVMediaType.video,
                                                                     position: .back) {
                // If the back dual camera is not available, default to the back wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                                      for: AVMediaType.video,
                                                                      position: .front) {
                /*
                 In some cases where users break their phones, the back wide angle camera is not available.
                 In this case, we should default to the front wide angle camera.
                 */
                defaultVideoDevice = frontCameraDevice
            }

            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)

            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput

            } else {
                setupResult = .configurationFailed
                session.commitConfiguration()

                throw  SDAVCaptureError.noVideoInout(NSError(domain: "Could not add video device input to the session",
                                                             code: -1,
                                                             userInfo: nil))
            }
        }
    }

    @IBAction private func capturePhoto(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        if self.videoDeviceInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        if !photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:
                photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)

    }

    @IBAction func showImage(_ sender: Any) {
#if DEBUG
self.performSegue(withIdentifier:
            R.segue.sdavCaptureViewController.sdCapturedAVSessionViewController.identifier,
                                          sender: nil)
#else
        self.performSegue(withIdentifier:
            R.segue.sdavCaptureViewController.sdAnalysisResultViewController.identifier,
                          sender: nil)
#endif

    }

    @IBAction func showScreenShot(_ sender: Any) {

//        if let appDelegate = UIApplication.shared.delegate as? SDAppDelegate {
//            let image = screenshotOf(window: appDelegate.window!)
//        }

    }

    // MARK: - AVCapturePhotoCaptureDelegate Methods

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        if let image = UIImage(data: imageData) {
            self.capturedImage.image = image
        }

        self.leftImage = self.previewView.snapshot(of: self.overlayView?.leftView.frameInSuperView!)
        self.middleImage = self.previewView.snapshot(of: self.overlayView?.middleView.frameInSuperView!)
        self.rightImage = self.previewView.snapshot(of: self.overlayView?.rightView.frameInSuperView!)

        self.showImage("")
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
