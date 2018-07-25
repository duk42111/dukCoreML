//
//  ViewController.swift
//  CoreML-Tutorial-1
//
//  Created by udaykanthd on 19/07/18.
//  Copyright © 2018 udaykanthd. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class MainViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession : AVCaptureSession!
    var cameraOutPut : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var photoData : Data?
    
    

    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ConfidenceLable: UILabel!
    @IBOutlet weak var OutputImageView: RoundShadowUIImageView!
    @IBOutlet weak var DescriptionView: RoundShadowUIView!
    @IBOutlet weak var CameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = CameraView.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCameraViewTap))
        tap.numberOfTapsRequired = 1
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let cameraVideo = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: cameraVideo!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            cameraOutPut = AVCapturePhotoOutput()
            if captureSession.canAddOutput(cameraOutPut) == true {
                captureSession.canAddOutput(cameraOutPut!)
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer.videoGravity  = AVLayerVideoGravity.resizeAspect
            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            CameraView.layer.addSublayer(previewLayer!)
            CameraView.addGestureRecognizer(tap)
            captureSession.startRunning()
            
        } catch  {
            debugPrint(error)
        }
    }
   @objc func onCameraViewTap() {
        let  photoSetting = AVCapturePhotoSettings()
        photoSetting.previewPhotoFormat = photoSetting.embeddedThumbnailPhotoFormat
        cameraOutPut.capturePhoto(with: photoSetting, delegate: self)
    }
    func coreMLRequest(request: VNRequest, error:Error?)  {
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        for classification in results {
            if classification.confidence < 0.5 {
                self.DescriptionLabel.text = "App does not recognize what it is. Please try again later."
                self.ConfidenceLable.text = ""
                break
            } else {
                self.DescriptionLabel.text = classification.identifier
                self.ConfidenceLable.text = "I am \(classification.confidence * 100 )% confident"
                break
            }
        }
        
    }
    // MARK: AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            do{
               let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler:coreMLRequest )
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            }
            catch {
               debugPrint(error)
            }
            let image = UIImage(data: photoData!)
            self.OutputImageView.image = image;
            
            
        }
    }

}

//learn option and optional chaining
