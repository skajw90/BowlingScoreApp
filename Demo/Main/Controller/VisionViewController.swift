//
//  VisionViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/11/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Vision

// MARK: - Text recognition
struct lineComponent {
    var x: CGFloat
    var y: CGFloat
    var text: [String]
}

class VisionViewController: CameraController {
    // MARK: - Properties
    var request: VNRecognizeTextRequest!
    typealias ColoredBoxGroup = (color: CGColor, boxes: [CGRect])
    
    // MARK: - ViewController methods
    override func viewDidLoad() {
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        super.viewDidLoad()
    }
    
    // MARK: - Text Recognize handler
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        var redBoxes = [CGRect]() // Shows all recognized text lines
        var greenBoxes = [CGRect]() // Shows words that might be serials
        dataFromCamera = []
        testActualData = []
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let maximumCandidates = 1
        var lines: [lineComponent] = []
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            let pattern = ".*"
            let splitter = candidate.string.split(separator: " ")
            for result in splitter {
                if hasPictured {
                    guard let range = result.range(of: pattern, options: .regularExpression, range: nil, locale: nil) else { continue }
                    if let box = try? candidate.boundingBox(for: range)?.boundingBox {
                        greenBoxes.append(box)
                        if lines.count == 0 { lines.append(lineComponent(x: box.midX, y: box.midY, text: [String(result)])) }
                        else {
                            var count = 0
                            for i in 0 ..< lines.count {
                                if abs(lines[i].y - box.midY) < 0.010 * lastZoomFactor {
                                    lines[i].text.append(String(result))
                                    count += 1
                                }
                            }
                            if count == 0 { lines.append(lineComponent(x: box.midX, y: box.midY, text: [String(result)]))}
                        }
                    }
                }
            }
            redBoxes.append(visionResult.boundingBox)
        }
        if hasPictured {
            print("\(0.010 * lastZoomFactor)")
            for i in 0 ..< lines.count {
                let line = lines[i].text
                testActualData.append(line)
                print("\(line)")
                if line.count > 7 {
                    dataFromCamera.append(line)
                }
            }
            updateCameraScoreResult()
        }
        show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes), (color: UIColor.green.cgColor, boxes: greenBoxes)])
    }
    
    // MARK: - updateCameraScore
    func updateCameraScoreResult() {
        DispatchQueue.main.async { self.cameraScoreView.update() }
    }
    
    // MARK: - Capture output override function
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            request.regionOfInterest = regionOfInterest
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: textOrientation, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Bounding box drawing
    // Draw a box on screen. Must be called from main queue.
    var boxLayer = [CAShapeLayer]()
    func draw(rect: CGRect, color: CGColor) {
        let layer = CAShapeLayer()
        layer.opacity = 0.5
        layer.borderColor = color
        layer.borderWidth = 2
        layer.frame = rect
        boxLayer.append(layer)
        cameraView.videoPreviewLayer.insertSublayer(layer, at: 1)
    }
    // Remove all drawn boxes. Must be called on main queue.
    func removeBoxes() {
        for layer in boxLayer { layer.removeFromSuperlayer() }
        boxLayer.removeAll()
    }
    
    // Draws groups of colored boxes.
    func show(boxGroups: [ColoredBoxGroup]) {
        DispatchQueue.main.async {
            let layer = self.cameraView.videoPreviewLayer
            self.removeBoxes()
            for boxGroup in boxGroups {
                let color = boxGroup.color
                for box in boxGroup.boxes {
                    let rect = layer.layerRectConverted(fromMetadataOutputRect: box.applying(self.visionToAVFTransform))
                    self.draw(rect: rect, color: color)
                }
            }
        }
    }
}

