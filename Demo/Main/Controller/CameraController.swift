//
//  CameraController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/5/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreMotion

protocol CameraControllerDelegate {
    func cancelCamera(controller: CameraController)
    func saveData(data: [String])
}

class CameraController: UIViewController, CameraOperatorViewDelegate, CameraScoreViewDataSource, ScoreFrameViewDataSource, CameraScoreviewDelegate {
    
    // MARK: - Properties
    var delegate: CameraControllerDelegate?
    var testActualData: [[String]] = []
    var dataFromCamera: [[String]] = []
    var hasPictured = false
    var motionManager: CMMotionManager!
    
    // MARK: - Capture related objects
    private let captureSession = AVCaptureSession()
    let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    var captureDevice: AVCaptureDevice?
    var videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "videoDataOutputQueue")
    
    // MARK: - UI objects
    lazy var cameraView: CameraView = {
        let view = CameraView()
        view.backgroundColor = .gray
        self.view.addSubview(view)
        return view
    } ()
    
    lazy var cutoutView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    } ()
    lazy var cameraScoreView: CameraScoreView = {
        let view = CameraScoreView()
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        return view
    } ()
    lazy var cameraOperatorView: CameraOperatorView = {
        let view = CameraOperatorView()
        return view
    } ()
    var maskLayer = CAShapeLayer()
    var currentOrientation = UIDeviceOrientation.portrait
    
    // MARK: - Region of interest (ROI) and text orientation
    // Region of video data output buffer that recognition should be run on.
    // Gets recalculated once the bounds of the preview layer are known.
    var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
    // Orientation of text to search for in the region of interest.
    var textOrientation = CGImagePropertyOrientation.up
    
    // MARK: - Coordinate transforms
    var bufferAspectRatio: Double = 1920.0 / 1080.0
    // Transform from UI orientation to buffer orientation.
    var uiRotationTransform = CGAffineTransform.identity
    // Transform bottom-left coordinates to top-left.
    var bottomToTopTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
    // Transform coordinates in ROI to global coordinates (still normalized).
    var roiToGlobalTransform = CGAffineTransform.identity
    
    // Vision -> AVF coordinate transform.
    var visionToAVFTransform = CGAffineTransform.identity
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 5.0
    var lastZoomFactor: CGFloat = 1.0

    // MARK: Pinch Zoom in and out
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat { return min(min(max(factor, minimumZoom), maximumZoom), captureDevice!.activeFormat.videoMaxZoomFactor) }
        func update(scale factor: CGFloat) {
            do {
                try captureDevice!.lockForConfiguration()
                defer { captureDevice!.unlockForConfiguration() }
                captureDevice!.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    // MARK: - CameraOperatorViewDataSource Functions
    func cancelCamera() { delegate!.cancelCamera(controller: self) }
    func takePicture() {
        hasPictured = true
        captureSessionQueue.async {
            if self.captureSession.isRunning { self.captureSession.stopRunning() }
            DispatchQueue.main.async { self.changeLayout() }
        }
    }
    // MARK: - CameraOperatorViewDelegate and CameraScoreViewDelegate Functions
    func retakeCamera() {
        hasPictured = false
        cameraScoreView.removeFromSuperview()
        initViewLayout()
        captureSessionQueue.async { if !self.captureSession.isRunning { self.captureSession.startRunning() }}
    }
    
    // MARK: - CameraScoreViewDataSource Functions
    func getLineDataFromCamera() -> [ScoreFrameView] {
        var test: [ScoreFrameView] = []
        for i in 0 ..< dataFromCamera.count {
            let temp = ScoreFrameView()
            temp.dataSource = self
            temp.tag = i
            test.append(temp)
        }
        return test
    }
    func getTestStringData() -> [[String]] { return dataFromCamera }
    func getTestActualData() -> [[String]] { return testActualData }
    
    
    // MARK: - ScoreFrameViewDataSource Functions
    func getSelectedFrame() -> (frame: Int, turn: Int) { return (frame: 0, turn: 0) }
    func getScores(tag: Int) -> GameScore {
        let score = GameScore()
        let index = tag
        if index >= 0 && index < dataFromCamera.count {
            let num = dataFromCamera[index].count
            print("score data number: \(num)")
            print("scores at \(index): ")
            print("\(dataFromCamera[index])")
            if num == 12 {
                var outputs: [FrameScore] = []
                for i in 1 ..< num - 1 {
                    let output =  FrameScore(score: Int(dataFromCamera[index][i]),bonusCount: 0, isSplit: false)
                    outputs.append(output)
                    // set data to score
                }
                score.output = outputs
            }
            
        }
        return score
    }
    
    // MARK: - View controller methods
    func initViewLayout() {
        dataFromCamera = []
        testActualData = []
        cameraView.frame = view.frame
        cutoutView.frame = view.frame
        // Set up preview view.
        cameraView.session = captureSession
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
        // Set up cutout view.
        cutoutView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.fillRule = .evenOdd
        cutoutView.layer.mask = maskLayer
        cameraOperatorView.delegate = self
        view.addSubview(cameraOperatorView)
        // Starting the capture session is a blocking call. Perform setup using
        // a dedicated serial dispatch queue to prevent blocking the main thread.
        captureSessionQueue.async {
            self.setupCamera()
            DispatchQueue.main.async { self.calculateRegionOfInterest() }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewLayout()
    }
    func changeLayout() {
        var rect = view.bounds
        (cameraView.frame, rect) = rect.divided(atDistance: 0.4 * view.bounds.maxY, from: .minYEdge)
        (cameraScoreView.frame, rect) = rect.divided(atDistance: 0.6 * view.bounds.maxY, from: .minYEdge)
        cameraOperatorView.removeFromSuperview()
        view.addSubview(cameraScoreView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCoreMotion()
        updateCutout()
    }
    
    // MARK: - Setup
    func calculateRegionOfInterest() {
        // In landscape orientation the desired ROI is specified as the ratio of
        // buffer width to height. When the UI is rotated to portrait, keep the
        // vertical size the same (in buffer pixels). Also try to keep the
        // horizontal size the same up to a maximum ratio.
        var desiredHeightRatio = 0.6
        var desiredWidthRatio = 0.7
        let maxPortraitWidth = 0.8
        
        // Figure out size of ROI.
        let size: CGSize
        if currentOrientation.isPortrait || currentOrientation == .unknown {
            size = CGSize(width: min(desiredWidthRatio * bufferAspectRatio, maxPortraitWidth), height: desiredHeightRatio / bufferAspectRatio)
        } else {
            desiredHeightRatio = 0.6
            desiredWidthRatio = 0.55
            size = CGSize(width: desiredWidthRatio, height: desiredHeightRatio)
        }
        // Make it centered.
        regionOfInterest.origin = CGPoint(x: (1 - size.width) / 2, y: (1 - size.height) / 2)
        regionOfInterest.size = size
        
        // ROI changed, update transform.
        setupOrientationAndTransform()
        
        // Update the cutout to match the new ROI.
        DispatchQueue.main.async {
            // Wait for the next run cycle before updating the cutout. This
            // ensures that the preview layer already has its new orientation.
            self.updateCutout()
        }
    }
    func updateCutout() {
        // Figure out where the cutout ends up in layer coordinates.
        let roiRectTransform = bottomToTopTransform.concatenating(uiRotationTransform)
        let cutout = cameraView.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: regionOfInterest.applying(roiRectTransform))
        // Create the mask.
        let path = UIBezierPath(rect: cutoutView.frame)
        path.append(UIBezierPath(rect: cutout))
        maskLayer.path = path.cgPath
        cameraOperatorView.frame = CGRect(x: 0, y: 9 * view.bounds.height / 10, width: view.bounds.width, height: view.bounds.height / 10)
       
    }
    func setupOrientationAndTransform() {
        // Recalculate the affine transform between Vision coordinates and AVF coordinates.
        // Compensate for region of interest.
        let roi = regionOfInterest
        roiToGlobalTransform = CGAffineTransform(translationX: roi.origin.x, y: roi.origin.y).scaledBy(x: roi.width, y: roi.height)
        // Compensate for orientation (buffers always come in the same orientation).
        switch currentOrientation {
        case .landscapeLeft:
            textOrientation = CGImagePropertyOrientation.up
            uiRotationTransform = CGAffineTransform.identity
        case .landscapeRight:
            textOrientation = CGImagePropertyOrientation.down
            uiRotationTransform = CGAffineTransform(translationX: 1, y: 1).rotated(by: CGFloat.pi)
        case .portraitUpsideDown:
            textOrientation = CGImagePropertyOrientation.left
            uiRotationTransform = CGAffineTransform(translationX: 1, y: 0).rotated(by: CGFloat.pi / 2)
        default: // We default everything else to .portraitUp
            textOrientation = CGImagePropertyOrientation.right
            uiRotationTransform = CGAffineTransform(translationX: 0, y: 1).rotated(by: -CGFloat.pi / 2)
        }
        // Full Vision ROI to AVF transform.
        visionToAVFTransform = roiToGlobalTransform.concatenating(bottomToTopTransform).concatenating(uiRotationTransform)
    }
    func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            print("Could not create capture device.")
            return
        }
        self.captureDevice = captureDevice
        
        // NOTE:
        // Requesting 4k buffers allows recognition of smaller text but will
        // consume more power. Use the smallest buffer size necessary to keep
        // down battery usage.
        if captureDevice.supportsSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
            bufferAspectRatio = 3840.0 / 2160.0
        } else {
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            bufferAspectRatio = 1920.0 / 1080.0
        }
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Could not create device input.")
            return
        }
        if captureSession.canAddInput(deviceInput) { captureSession.addInput(deviceInput) }
        // Configure video data output.
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            // NOTE:
            // There is a trade-off to be made here. Enabling stabilization will
            // give temporally more stable results and should help the recognizer
            // converge. But if it's enabled the VideoDataOutput buffers don't
            // match what's displayed on screen, which makes drawing bounding
            // boxes very hard. Disable it in this app to allow drawing detected
            // bounding boxes on screen.
            videoDataOutput.connection(with: AVMediaType.video)?.preferredVideoStabilizationMode = .off
        } else {
            print("Could not add VDO output")
            return
        }
        // Set zoom and autofocus to help focus on very small text.
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = 1
            captureDevice.autoFocusRangeRestriction = .none
            captureDevice.unlockForConfiguration()
        } catch {
            print("Could not set zoom level due to error: \(error)")
            return
        }
        captureSession.startRunning()
    }
     
    // MARK: - Motion handler, and change orientation
    func addCoreMotion() {
        let splitAngle:Double = 0.75
        let updateTimer:TimeInterval = 0.5
        motionManager = CMMotionManager()
        motionManager?.gyroUpdateInterval = updateTimer
        motionManager?.accelerometerUpdateInterval = updateTimer
        var orientationLast    = UIInterfaceOrientation(rawValue: 0)!
        motionManager?.startAccelerometerUpdates(to: (OperationQueue.current)!, withHandler: {
            (acceleroMeterData, error) -> Void in
            if error == nil {
                let acceleration = (acceleroMeterData?.acceleration)!
                var orientationNew = UIInterfaceOrientation(rawValue: 0)!
                if acceleration.x >= splitAngle { orientationNew = .landscapeLeft }
                else if acceleration.x <= -(splitAngle) { orientationNew = .landscapeRight }
                else if acceleration.y <= -(splitAngle) { orientationNew = .portrait }
                else if acceleration.y >= splitAngle { orientationNew = .portraitUpsideDown }
                if orientationNew != orientationLast && orientationNew != .unknown{
                    orientationLast = orientationNew
                    self.deviceOrientationChanged(orinetation: orientationNew)
                }
            }
        })
    }
    func deviceOrientationChanged(orinetation:UIInterfaceOrientation) {
        // set orient for image read in text detector
        if orinetation.rawValue == 3 {
            currentOrientation = .landscapeLeft
        }
        else if orinetation.rawValue == 4 {
            currentOrientation = .landscapeRight
        }
        else if orinetation.rawValue == 1 {
            currentOrientation = .portrait
        }
        calculateRegionOfInterest()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // implemented in VisionViewController.
    }
}

// MARK: - Utility extensions
extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
}
