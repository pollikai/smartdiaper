//
//  SDAVCaptureViewModel.swift
//  SmartDiaper
//
//  Created by Ankush Kushwaha on 1/23/18.
//  Copyright © 2018 Starcut. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

class SDAVCaptureViewModel: NSObject, AVCapturePhotoCaptureDelegate {

    var photoIsCaptured = Variable(false)
    var flashOn = Variable(false)
    var avSessionFailed = Variable(SessionSetupResult.configurationFailed)

    var capturedImage: UIImage? {
        get {
            return self.image
        }
    }

    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    private var image: UIImage?
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "sessionQueue",
                                     attributes: [],
                                     target: nil)
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var setupResult: SessionSetupResult = .success
    private enum SDAVCaptureError: Error {
        case noVideoInput(Error)
    }

    override init() {
        super.init()

        checkAuthorization()

        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }

    // MARK: - --------AVCaptureSession Management--------

    func tryToOpenSessionPreviewInsideView(previewView: UIView!) {
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.avSessionFailed.value = .success

                DispatchQueue.main.async { [unowned self] in
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    previewLayer.frame = previewView.bounds
                    previewView.layer.addSublayer(previewLayer)
                    self.session.startRunning()

                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

                    previewView.layer.addSublayer(previewLayer)

                }
            case .notAuthorized:
                self.avSessionFailed.value = .notAuthorized

            case .configurationFailed:
                self.avSessionFailed.value = .configurationFailed
            }
        }
    }

    func stopSession() {

        sessionQueue.async { //[unowned self] in // INFO: if we uncomment it. then deinit() runs
            //without waiting this block to execute, and self = nil at that time, so wont stop self.session,
            // this is very good example to see unowned into action
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
    }

    private func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            break

        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })

        default:
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

                throw  SDAVCaptureError.noVideoInput(NSError(domain: "Could not add video device input to the session",
                                                             code: -1,
                                                             userInfo: nil))
            }
        }
    }

    func capturePhoto() {
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

    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else {return}
        do {
            try device.lockForConfiguration()
            let torchOn = !device.isTorchActive
            try device.setTorchModeOn(level: 1.0)
            device.torchMode = torchOn ? .on : .off
            flashOn.value = !torchOn
            device.unlockForConfiguration()
        } catch {
            print("error")
        }
    }
#if DEBUG
    deinit {
        print("deinit")
    }
#endif

}

// MARK: - --------AVCapturePhotoCaptureDelegate Methods--------

extension  SDAVCaptureViewModel {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        if let image = UIImage(data: imageData) {
            self.image = image

            photoIsCaptured.value = true
        }
    }
}
