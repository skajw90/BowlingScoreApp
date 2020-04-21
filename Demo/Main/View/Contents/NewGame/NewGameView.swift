//
//  NewGameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol NewGameViewDelegate {
    func setSelectedFrame(index: Int)
    func moveFrameTo(index: Int)
    func setScoreByPad(score: Int, isSplit: Bool)
    func setPin(leftPin: Int?)
    func saveScore()
    func moveToNext()
}

protocol NewGameViewDataSource {
    func getSelectedFrame() -> (frame: Int, turn: Int)
    func getDate() -> CalendarData
    func getNextAvailable(index: Int) -> Bool
    func getScores() -> GameScore
    func getAvailableScores() -> [Bool]
    func getPinSet(frame: Int) -> [Int]?
    func isFirstPinInput() -> Bool
}

class NewGameView: UIView, ScoreFrameViewDataSource, ScoreInputPadViewDataSource, ScoreInputPadViewDelegate, ScoreFrameViewDelegate, PinsetPreviewDelegate, ScoreInputPinsetTopViewDataSource, ScoreInputPinsetViewDataSource, ScoreInputPinsetViewDelegate {
    
    // MARK: - Properties
    var dataSource: NewGameViewDataSource?
    var delegate: NewGameViewDelegate?
    var inputMode: InputMode = .pad
    
    // MARK: - UI properties
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(label)
        return label
    } ()
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.isEnabled = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(saveButtonHanlder), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
       } ()
    lazy var scoreFrameView: ScoreFrameView = {
        let view = ScoreFrameView()
        view.dataSource = self
        view.delegate = self
        view.tag = 0
        addSubview(view)
        return view
    } ()
    lazy var changeInputMethodButton: UIButton = {
        let button = UIButton()
        button.setTitle("PAD", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(changeInputMethod), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    lazy var scoreInputPinsetTopView: ScoreInputPinsetTopView = {
        let view = ScoreInputPinsetTopView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    lazy var scoreInputPadView: ScoreInputPadView = {
        let view = ScoreInputPadView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .yellow
        addSubview(view)
        return view
    } ()
    lazy var scoreInputPinsetView: ScoreInputPinsetView = {
        let view = ScoreInputPinsetView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dateLabel.text = dataSource!.getDate().toString()
    }
    
    // MARK: - UI autolayout
    override func layoutSubviews() {
        super.layoutSubviews()
        changeInputMethodButton.removeFromSuperview()
        var rect = bounds
        (scoreFrameView.frame, rect) = rect.divided(atDistance: frame.maxY / 8, from: .minYEdge)
        (scoreInputPinsetTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 8, from: .minYEdge)
        var statusRect: CGRect
        (statusRect, rect) = rect.divided(atDistance: frame.maxY / 12, from: .minYEdge)
        (changeInputMethodButton.frame, statusRect) = statusRect.divided(atDistance: frame.maxX / 6, from: .minXEdge)
        (dateLabel.frame, statusRect) = statusRect.divided(atDistance: 4 * frame.maxX / 6, from: .minXEdge)
        (saveButton.frame, statusRect) = statusRect.divided(atDistance: frame.maxX / 6, from: .minXEdge)
        var padPinViewRect: CGRect
        (padPinViewRect, rect) = rect.divided(atDistance: 4 * frame.maxY / 6, from: .minYEdge)
        scoreInputPinsetView.frame = padPinViewRect
        scoreInputPadView.frame = padPinViewRect
        if inputMode == .pad {
            scoreInputPinsetView.pinsetView.setAllbuttonDisable()
            scoreInputPinsetView.removeFromSuperview()
            addSubview(scoreInputPadView)
            changeInputMethodButton.setTitle("PIN", for: .normal)
        }
        else {
            scoreInputPadView.removeFromSuperview()
            addSubview(scoreInputPinsetView)
            scoreInputPinsetView.pinsetView.setAllbuttonEnable()
            scoreInputPinsetView.pinsetView.backgroundLabel.text = "T"
            changeInputMethodButton.setTitle("PAD", for: .normal)
        }
        addSubview(changeInputMethodButton)
    }
    
    // MARK: - ScoreFrameViewDataSource Functions
    func setScoreByPad(score: Int, isSplit: Bool) { delegate!.setScoreByPad(score: score, isSplit: isSplit) }
    
    // MARK: - ScoreFrameViewDataSource and ScoreInputPadViewDataSource shared Functions
    func getSelectedFrame() -> (frame: Int, turn: Int) { return dataSource!.getSelectedFrame() }
    
    // MARK: - ScoreFrameViewDelegate Functions
    func enableSaveScore(isEnable: Bool) { saveButton.isEnabled = isEnable }
    
    // MARK: - ScoreInputPadViewDataSource Functions
    func getAvailableScores() -> [Bool] { return dataSource!.getAvailableScores() }
    func getNextAvailable(index: Int) -> Bool { return dataSource!.getNextAvailable(index: index) }
    
    // MARK: - ScoreInputPadViewDelegate Functions
    func setCurrentFrameNumber(index: Int) { delegate!.setSelectedFrame(index: index) }
    func getScores(tag: Int) -> GameScore { dataSource!.getScores() }
    
    // MARK: - PinsetPreviewDelegate Functions
    func setPin(leftPin: Int?) {
        delegate!.setPin(leftPin: leftPin)
    }
    
    // MARK: - PinsetPreviewDataSource Functions
    func getPinSet(frame: Int) -> [Int]? {
        return dataSource!.getPinSet(frame: frame)
    }
    
    func setCurrentFrameNumberForPin(index: Int) {
        delegate!.setSelectedFrame(index: index)
    }
    func isFirstPinInput() -> Bool {
        return dataSource!.isFirstPinInput()
    }
    
    func getTurn() -> (frame: Int, turn: Int) {
        dataSource!.getSelectedFrame()
    }
    
    func moveToNext() {
        delegate!.moveToNext()
    }
    
    
    // MARK: - UIButton handlers
    @objc func changeInputMethod(sender: Any) {
        if inputMode == .pin { inputMode = .pad }
        else { inputMode = .pin }
        setNeedsLayout()
    }
    @objc func saveButtonHanlder(sender: Any) {
        delegate!.saveScore()
    }
    
    // MARK: - UIView Override Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first
        guard let location = firstTouch?.location(in: self) else {
            return
        }
        for i in 0 ..< 10 {
            if isInBoundary(boundary: getFrameRect(index: i), touchPos: location) {
                delegate!.moveFrameTo(index: i)
                return
            }
        }
    }
    func isInBoundary(boundary: CGRect, touchPos: CGPoint) -> Bool {
        return boundary.contains(touchPos)
    }
    func getFrameRect(index: Int) -> CGRect {
        return scoreFrameView.frameViews[index].frame
    }
}

// MARK: - UIButton change enable disable property
extension UIButton {
    override open var isEnabled: Bool {
       didSet {
           DispatchQueue.main.async {
               if self.isEnabled { self.alpha = 1.0 }
               else { self.alpha = 0.7 }
           }
       }
   }
}
