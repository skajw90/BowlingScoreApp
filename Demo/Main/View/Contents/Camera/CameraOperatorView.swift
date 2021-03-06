//
//  CameraOperatorView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/10/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CameraOperatorViewDelegate {
    func cancelCamera()
    func takePicture()
    func retakeCamera()
}

class CameraOperatorView: UIView {
    // MARK: - Properties
    var delegate: CameraOperatorViewDelegate?
    
    // MARK: - UI Properties
    lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Photo", for: .normal)
        button.addTarget(self, action: #selector(takePhoto), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    lazy var cancelCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelCamera), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    lazy var retakeCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retake", for: .normal)
        button.addTarget(self, action: #selector(retakeCamera), for: UIControl.Event.touchDown)
        return button
    } ()
    
    // MARK: - UIView Override Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        cancelCameraButton.frame = CGRect(x: 0, y: 0, width: bounds.width / 4, height: bounds.height)
        takePhotoButton.frame = CGRect(x: 3 * bounds.width / 8 , y: 0, width: bounds.width / 4, height: bounds.height)
        retakeCameraButton.frame = CGRect(x: 3 * bounds.width / 4, y: 0, width: bounds.width / 4, height: bounds.height)
    }
    
    // MARK: - UIButton Action Hanlder Functions
    @objc func cancelCamera(sender: UIButton) { delegate!.cancelCamera() }
    @objc func takePhoto(sender: UIButton) { delegate!.takePicture() }
    @objc func retakeCamera(sender: UIButton) { delegate!.retakeCamera() }
    
    // MARK: - Helper Method to set buttons
    func addRetakeCameraView() { addSubview(retakeCameraButton) }
    func removeRetakeCameraView() { retakeCameraButton.removeFromSuperview() }
}
