//
//  CameraView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/10/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    // MARK: - UI Properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    var session: AVCaptureSession? {
        get { return videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue}
    }
    
    // MARK: UIView Override Functions
    override class var layerClass: AnyClass { return AVCaptureVideoPreviewLayer.self }
}

