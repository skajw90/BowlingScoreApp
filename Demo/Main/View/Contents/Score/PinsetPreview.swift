//
//  PinsetPreview.swift
//  Demo
//
//  Created by Jiwon Nam on 2/22/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol PinsetPreviewDelegate {
//    func setPreViewPin(leftPin: Int)
    func setPin(leftPin: Int?)
}

protocol PinsetPreviewDataSource {
//    func getPinSet() -> (frist: [Int], second: [Int])
    func getPinSet(frame: Int) -> [Int]?
    func getTurn() -> (frame:Int, turn: Int)
    func isFirstPinInput() -> Bool
}

class PinsetPreview: UIView {
    var delegate: PinsetPreviewDelegate?
    var dataSource: PinsetPreviewDataSource?
    var prevPins: [Int] = []
    var isPreset: Bool = false
    var isFirstInput: Bool = false
    var currentFrame: Int = 0
    lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .lightGray
        addSubview(label)
        return label
    } ()
    lazy var pinButton: [PinButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 1 ..< 11 {
            let button = PinButton()
            button.addTarget(self, action: #selector(pinButtonActionHandler), for: UIControl.Event.touchDown)
            button.tag = i
            button.backgroundColor = .lightGray
            button.isEnabled = false
            addSubview(button)
            pinButton.append(button)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialize()
        
        if !isPreset {
            currentFrame = dataSource!.getTurn().frame
            isFirstInput = dataSource!.isFirstPinInput()
        }
        else {
            backgroundLabel.text = ""
            isPreset = false
        }
        if let leftPins = dataSource!.getPinSet(frame: currentFrame) {
            for i in 0 ..< 10 {
                if isFirstInput {
                    if leftPins.contains(i) {
                        drawOpenSign(index: i)
                    }
                    else {
                        drawDefaultSign(index: i)
                    }
                }
                else {
                    prevPins = dataSource!.getPinSet(frame: currentFrame - 1)!
                    if prevPins.contains(i) {
                        drawOpenSign(index: i)
                    }
                    if leftPins.contains(i) {
                        drawSpareSign(index: i)
                    }
                }
            }
        }
        else {
            backgroundLabel.text = "?"
        }
    }
    
    func initialize() {
        //prevPins = []
        for i in 0 ..< 10 {
            drawDefaultSign(index: i)
        }
    }
    
    func drawDefaultSign(index: Int) {
        pinButton[index].backgroundColor = .lightGray
        pinButton[index].layer.borderColor = UIColor.clear.cgColor
        pinButton[index].layer.borderWidth = 0
        if pinButton[index].titleLabel != nil && pinButton[index].currentTitleColor == .white {
            pinButton[index].setTitleColor(.black, for: .normal)
        }
    }
    
    func drawOpenSign(index: Int) {
        pinButton[index].backgroundColor = .clear
        pinButton[index].layer.borderColor = UIColor.black.cgColor
        pinButton[index].layer.borderWidth = 1
    }
    
    func drawSpareSign(index: Int) {
        pinButton[index].backgroundColor = .black
        pinButton[index].layer.borderColor = UIColor.clear.cgColor
        pinButton[index].layer.borderWidth = 0
        if pinButton[index].titleLabel != nil {
            pinButton[index].setTitleColor(.white, for: .normal)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLabel.frame = bounds
        let defaultPinDiameter = bounds.maxX / 9
        let yDistance = bounds.maxX / 6
        let xDistance = 2 * yDistance / tan(.pi / 3)
        pinButton[0].frame = CGRect(origin: CGPoint(x: bounds.midX - 0.5 * defaultPinDiameter, y: bounds.midY + 1.5 * yDistance), size: CGSize(width: defaultPinDiameter, height: defaultPinDiameter))
        pinButton[0].layer.cornerRadius = 0.5 * pinButton[0].bounds.size.width
        pinButton[0].clipsToBounds = true
        for i in 1 ..< 3 {
            pinButton[i].frame = CGRect(origin: CGPoint(x: bounds.midX - 0.5 * defaultPinDiameter + 0.5 * pow(-1, CGFloat(i)) * xDistance, y: bounds.midY + 0.5 * yDistance), size: CGSize(width: defaultPinDiameter, height: defaultPinDiameter))
            pinButton[i].layer.cornerRadius = 0.5 * pinButton[i].bounds.size.width
            pinButton[i].clipsToBounds = true
        }
        
        for i in 3 ..< 6 {
            pinButton[i].frame = CGRect(origin: CGPoint(x: bounds.midX - 0.5 * defaultPinDiameter + CGFloat(i - 4) * xDistance, y: bounds.midY - 0.5 * yDistance), size: CGSize(width: defaultPinDiameter, height: defaultPinDiameter))
            pinButton[i].layer.cornerRadius = 0.5 * pinButton[i].bounds.size.width
            pinButton[i].clipsToBounds = true
        }
        for i in 6 ..< 10 {
            var center = CGPoint()
            if i == 6 || i == 9 {
                center = CGPoint(x: bounds.midX - 0.5 * defaultPinDiameter - 1.5 * pow(-1, CGFloat(i)) * xDistance, y: bounds.midY - 1.5 * yDistance)
            }
            else {
                center = CGPoint(x: bounds.midX - 0.5 * defaultPinDiameter + 0.5 * pow(-1, CGFloat(i)) * xDistance, y: bounds.midY - 1.5 * yDistance)
            }
            pinButton[i].frame = CGRect(origin: center, size: CGSize(width: defaultPinDiameter, height: defaultPinDiameter))
            pinButton[i].layer.cornerRadius = 0.5 * pinButton[i].bounds.size.width
            pinButton[i].clipsToBounds = true
        }
    }
    
    func setAllbuttonEnable() {
        for i in 0 ..< 10 {
            pinButton[i].isEnabled = true
        }
    }
    
    func setAllbuttonDisable() {
        for i in 0 ..< 10 {
            pinButton[i].isEnabled = false
        }
    }
    
    @objc func pinButtonActionHandler(sender: UIButton) {
        if dataSource!.isFirstPinInput() || prevPins.contains(sender.tag - 1) {
            delegate!.setPin(leftPin: sender.tag - 1)
        }
        backgroundLabel.text = ""
        update()
    }
    
    func update() {
        backgroundLabel.text = ""
        setNeedsDisplay()
    }
    
    func updateWith(frame: Int, isFirst: Bool) {
        isPreset = true
        currentFrame = frame
        isFirstInput = isFirst
        setNeedsDisplay()
    }
}

class PinButton: UIButton {
}
