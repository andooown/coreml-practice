//
//  ViewController.swift
//  CoreMLPractice
//
//  Created by Yoshikazu Ando on 2018/06/08.
//  Copyright © 2018年 Yoshikazu Ando. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class Food101RecognitionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var resultLabel: UILabel!

    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(for: .video)
    let videoOutput = AVCaptureVideoDataOutput()

    var mlModel: VNCoreMLModel!
    var request: VNCoreMLRequest!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            self.mlModel = try VNCoreMLModel(for: NASNetMobile().model)
        } catch {
            print(error.localizedDescription)
        }
        self.request = VNCoreMLRequest(model: mlModel) { request, _ in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }

            if results.count > 0 {
                var filteredResults = results.filter { $0.confidence >= 0.1 }
                if filteredResults.count < 3 {
                    filteredResults = results[0..<3].map { $0 }
                }

                let resultText = filteredResults
                                     .map { "\($0.identifier) - \(String(format: "%.1f", $0.confidence * 100.0))%" }
                                     .joined(separator: "\n")
                DispatchQueue.main.sync(execute: {
                    self.resultLabel.text = resultText
                })
            }
        }
        self.request.imageCropAndScaleOption = .centerCrop

        do {
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        } catch let error as NSError {
            print(error)
        }

        self.videoOutput.videoSettings =
                [String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)]
        self.videoOutput.alwaysDiscardsLateVideoFrames = true
        let queue: DispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        self.videoOutput.setSampleBufferDelegate(self, queue: queue)
        self.captureSession.addOutput(self.videoOutput)

        let videoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.cameraView.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraView.layer.addSublayer(videoLayer)

        for connection in self.videoOutput.connections {
            let conn = connection
            if conn.isVideoOrientationSupported {
                conn.videoOrientation = AVCaptureVideoOrientation.portrait
            }
        }

        self.captureSession.startRunning()
    }

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let image = CIImage(cvPixelBuffer: pixelBuffer)

        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        guard (try? handler.perform([self.request])) != nil else {
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
