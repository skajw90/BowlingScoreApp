//
//  ScoreInputPinsetTop.swift
//  Demo
//
//  Created by Jiwon Nam on 2/22/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreInputPinsetViewDelegate {
    func setCurrentFrameNumberForPin(index: Int)
    func setPin(leftPin: Int?)
    func moveToNext()
}

protocol ScoreInputPinsetViewDataSource {
    func getPinSet(frame: Int) -> [Int]?
    func getTurn() -> (frame:Int, turn: Int)
    func getAvailableScores() -> [Bool]
    func getNextAvailable(index: Int) -> Bool
    func isFirstPinInput() -> Bool
}

class ScoreInputPinsetView: UIView, PinsetPreviewDelegate, PinsetPreviewDataSource {
    var dataSource: ScoreInputPinsetViewDataSource?
    var delegate: ScoreInputPinsetViewDelegate?
    
    lazy var setScoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .orange
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(setScoreButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var spareStrikeButton: UIButton = {
       let button = UIButton()
        button.setTitle("ST", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(setSpareStrikeButtonHanlder), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var gutterButton: UIButton = {
        let button = UIButton()
        button.setTitle("GT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(setGutterButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var prevScoreBtn: UIButton = {
        let button = UIButton()
        button.setTitle("<<", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(scoreBtnHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    lazy var nextScoreBtn: UIButton = {
        let button = UIButton()
        button.setTitle(">>", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(scoreBtnHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var pinsetView: PinsetPreview = {
        let view = PinsetPreview()
        for i in 1 ..< 11 {
            view.pinButton[i - 1].setTitle("\(i)", for: .normal)
            view.pinButton[i - 1].setTitleColor(.black, for: .normal)
        }
        view.dataSource = self
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    // MARK: - UIButton action handler
    @objc func scoreBtnHandler(sender: UIButton) {
        if sender.tag == 0 && dataSource!.getNextAvailable(index: -1) {
            print("go back to prev score")
            delegate!.setCurrentFrameNumberForPin(index: -1)
            pinsetView.update()
        }
        if sender.tag == 1 && dataSource!.getNextAvailable(index: 1) {
            print("go next score")
            delegate!.setCurrentFrameNumberForPin(index: 1)
            pinsetView.update()
        }
    }
    @objc func setScoreButtonHandler(sender: UIButton) {
        delegate!.moveToNext()
        if isFirstPinInput() { spareStrikeButton.setTitle("ST", for: .normal) }
        else { spareStrikeButton.setTitle("SP", for: .normal) }
    }
    @objc func setSpareStrikeButtonHanlder(sender: UIButton) {
        
    }
    @objc func setGutterButtonHandler(sender: UIButton) {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (_, rect) = rect.divided(atDistance: frame.maxY / 15, from: .minYEdge)
        var setSpareGutterRect = CGRect()
        (setSpareGutterRect, rect) = rect.divided(atDistance: frame.maxY / 12, from: .minYEdge)
        (_, setSpareGutterRect) = setSpareGutterRect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (gutterButton.frame, setSpareGutterRect) = setSpareGutterRect.divided(atDistance: 3 * bounds.width / 20, from: .minXEdge)
        (setScoreButton.frame, setSpareGutterRect) = setSpareGutterRect.divided(atDistance:3 * bounds.width / 10, from: .minXEdge)
        (spareStrikeButton.frame, setSpareGutterRect) = setSpareGutterRect.divided(atDistance: 3 * bounds.width / 20, from: .minXEdge)
        (prevScoreBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 12, from: .minXEdge)
        (pinsetView.frame, rect) = rect.divided(atDistance: 5 * frame.maxX / 6, from: .minXEdge)
        (nextScoreBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 12, from: .minXEdge)
    }
    
    func isFirstPinInput() -> Bool { return dataSource!.isFirstPinInput() }
    
    func setPin(leftPin: Int?) { delegate!.setPin(leftPin: leftPin) }
    
    func getPinSet(frame: Int) -> [Int]? { return dataSource!.getPinSet(frame: frame) }
    
    func getTurn() -> (frame: Int, turn: Int) { dataSource!.getTurn() }
}
