//
//  Food101RecognitionWithARViewController.swift
//  CoreMLPractice
//
//  Created by Yoshikazu Ando on 2018/07/14.
//  Copyright © 2018年 Yoshikazu Ando. All rights reserved.
//

import UIKit
import ARKit
import Vision

class Food101RecognitionWithARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
            self.sceneView.scene = SCNScene()
        }
    }

    let queue = DispatchQueue(label: "com.andooown.coreml-practice.recognition-with-ar")

    var mlModel: VNCoreMLModel!
    var request: VNCoreMLRequest!
    var isPredicting = false
    var screenCenter: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            self.mlModel = try VNCoreMLModel(for: NASNetMobile().model)
        } catch {
            print(error.localizedDescription)
        }
        self.request = VNCoreMLRequest(model: self.mlModel) { request, _ in
            guard let bestResult = request.results?.first as? VNClassificationObservation,
                  bestResult.confidence < 0.3 else {
                self.isPredicting = false
                return
            }
        }
        self.request.imageCropAndScaleOption = .centerCrop
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneView.session.run(ARWorldTrackingConfiguration())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.screenCenter = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.hisTest(self.screenCenter!)
        self.queue.async {
            guard !self.isPredicting,
                  let pixelBuffer = self.sceneView.session.currentFrame?.capturedImage else { return }
            self.isPredicting = true

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            guard (try? handler.perform([self.request])) != nil else {
                self.isPredicting = false
                return
            }
        }
    }

    // MARK: - Private Method

    private func hisTest(_ pos: CGPoint) {
        let nodeResults = self.sceneView.hitTest(pos, options: nil)
        if nodeResults.count > 0 {
            print(nodeResults)
        }
    }

}
