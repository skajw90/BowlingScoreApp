//
//  NewGameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

enum InputMode {
    case pad
    case pin
}

protocol NewGameViewDelegate {
    func setSelectedFrame(index: Int)
    func setScore(score: Int)
    func saveScore()
}

protocol NewGameViewDataSource {
    func getSelectedFrame() -> (frame: Int, turn: Int)
    func getDate() -> CalendarData
    func getNextAvailable(index: Int) -> Bool
    func getScores() -> GameScore
    func getAvailableScores() -> [Bool]
}

class NewGameView: UIView, ScoreFrameViewDataSource, ScoreInputPadViewDataSource, ScoreInputPadViewDelegate, ScoreFrameViewDelegate {
    
    var dataSource: NewGameViewDataSource?
    var delegate: NewGameViewDelegate?
    var inputMode: InputMode = .pad
    
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
        return button
    } ()
    
    lazy var scoreInputPadView: ScoreInputPadView = {
        let view = ScoreInputPadView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .yellow
        return view
    } ()
    
    lazy var scoreInputPinsetView: ScoreInputPinsetView = {
        let view = ScoreInputPinsetView()
        view.backgroundColor = .green
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dateLabel.text = dataSource!.getDate().toString()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeInputMethodButton.removeFromSuperview()
        var rect = CGRect(x: bounds.maxX / 32, y: 0, width: 15 * frame.maxX / 16, height: bounds.maxY)
        var labelRect: CGRect
        (labelRect, rect) = rect.divided(atDistance: frame.maxY / 12, from: .minYEdge)
        (dateLabel.frame, labelRect) = labelRect.divided(atDistance: 2 * frame.maxX / 3, from: .minXEdge)
        (saveButton.frame, labelRect) = labelRect.divided(atDistance: 1 * frame.maxX / 3, from: .minXEdge)
        (scoreFrameView.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
        rect = CGRect(x: 0, y: rect.minY, width: frame.maxX, height: rect.maxY)
        if inputMode == .pad {
            scoreInputPinsetView.removeFromSuperview()
            (scoreInputPadView.frame, rect) = rect.divided(atDistance: 5 * frame.maxY / 6 - frame.maxY / 12, from: .minYEdge)
            addSubview(scoreInputPadView)
            changeInputMethodButton.setTitle("PAD", for: .normal)
        }
        else {
            scoreInputPadView.removeFromSuperview()
            (scoreInputPinsetView.frame, rect) = rect.divided(atDistance: 5 * frame.maxY / 6 - frame.maxY / 12, from: .minYEdge)
            addSubview(scoreInputPinsetView)
            changeInputMethodButton.setTitle("PIN", for: .normal)
        }
        changeInputMethodButton.frame = CGRect(x: bounds.maxX / 32, y: frame.maxY / 12 + frame.maxY / 6 + bounds.maxX / 32, width: bounds.maxX / 5, height: bounds.maxX / 10)
        addSubview(changeInputMethodButton)
    }
    
    func getSelectedFrame() -> (frame: Int, turn: Int) {
        return dataSource!.getSelectedFrame()
    }
    
    func getNextAvailable(index: Int) -> Bool {
        return dataSource!.getNextAvailable(index: index)
    }
       
    func setCurrentFrameNumber(index: Int) {
        delegate!.setSelectedFrame(index: index)
    }
    
    func setScore(score: Int) {
        delegate!.setScore(score: score)
    }
    
    func getScores(tag: Int) -> GameScore {
        dataSource!.getScores()
    }
    
    func enableSaveScore(isEnable: Bool) {
        saveButton.isEnabled = isEnable
    }
    
    @objc func changeInputMethod(sender: Any) {
        if inputMode == .pin {
            inputMode = .pad
        }
        else {
            inputMode = .pin
        }
        setNeedsLayout()
    }
    
    @objc func saveButtonHanlder(sender: Any) {
        delegate!.saveScore()
    }
    
    func getAvailableScores() -> [Bool] {
        return dataSource!.getAvailableScores()
    }
}

extension UIButton {
    override open var isEnabled: Bool {
               didSet {
                   DispatchQueue.main.async {
                       if self.isEnabled {
                           self.alpha = 1.0
                       }
                       else {
                           self.alpha = 0.7
                       }
                   }
               }
           }
}
