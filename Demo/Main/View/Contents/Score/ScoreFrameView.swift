//
//  ScoreFrameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreFrameViewDelegate {
    func enableSaveScore(isEnable: Bool)
}

protocol ScoreFrameViewDataSource {
    func getSelectedFrame() -> (frame: Int, turn: Int)
    func getScores(tag: Int) -> GameScore
}

class ScoreFrameView: UIView {
    // MARK: - Properties
    var dataSource: ScoreFrameViewDataSource?
    var delegate: ScoreFrameViewDelegate?
    var frameViews: [FrameView] = []
    
    // MARK: - UIView override Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        for i in 0 ..< 10 {
            let tempFrame = FrameView()
            if i == 9 {
                tempFrame.scoreInputView.isLastFrame = true
            }
            tempFrame.frameLabel.text = "\(i + 1)"
            addSubview(tempFrame)
            frameViews.append(tempFrame)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let scores = dataSource!.getScores(tag: tag)
        for i in 0 ..< 10 {
            if let out = scores.getOutput(index: i).score {
                frameViews[i].scoreOutputLabel.text = "\(out)"
                frameViews[i].scoreOutputLabel.setTextColor()
            }
        }
        
        for j in 0 ..< 21 {
            if j == 0 && scores.getInput(index: j) == nil { frameViews[j].scoreInputView.firstScore.backgroundColor = .yellow }
            var result = ""
            if let score = scores.getInput(index: j) {
                result = "\(score)"
                if score == 0 { result = "-" }
                if score == 10 { result = "F" }
                if j == 20 {
                    if score == 11 {
                        if scores.getInput(index: j - 1) != 11 { result = "/" }
                        else { result = "X" }
                    }
                }
                else {
                    if j % 2 == 0 { if score == 11 { result = "X" } }
                    else {
                        if score == 11 {
                            if j == 19 && scores.getInput(index: j - 1) == 11 { result = "X"}
                            else { result = "/" }
                        }
                    }
                }
            }
            if j == 19 {
                frameViews[9].scoreInputView.secondScore.inputLabel.text = result
                frameViews[9].scoreInputView.secondScore.inputLabel.layer.borderColor = UIColor.clear.cgColor
                if let bonus = scores.getOutput(index: 9).firstBonusStat, bonus == .split || bonus == .splitMake {
                    frameViews[9].scoreInputView.secondScore.inputLabel.layer.borderColor = UIColor.red.cgColor
                }
            }
            else if j == 20 {
                frameViews[9].scoreInputView.thirdScore.inputLabel.text = result
                frameViews[9].scoreInputView.thirdScore.inputLabel.layer.borderColor = UIColor.clear.cgColor
                if let bonus = scores.getOutput(index: 9).secondBonusStat, bonus == .split {
                    frameViews[9].scoreInputView.thirdScore.inputLabel.layer.borderColor = UIColor.red.cgColor
                }
            }
            else if j % 2 == 0 {
                frameViews[j / 2].scoreInputView.firstScore.inputLabel.text = result
                if let stat = scores.getOutput(index: j / 2).stat, stat == .split || stat == .splitMake {
                    frameViews[j / 2].scoreInputView.firstScore.inputLabel.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    frameViews[j / 2].scoreInputView.firstScore.inputLabel.layer.borderColor = UIColor.clear.cgColor
                }
            }
            else { frameViews[j / 2].scoreInputView.secondScore.inputLabel.text = result }
            if let delegate = delegate, frameViews[9].scoreOutputLabel.text != nil { delegate.enableSaveScore(isEnable: true) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        for i in 0 ..< 10 {
            if i != 9 {
                (frameViews[i].frame, rect) = rect.divided(atDistance: 2 * bounds.width / 21, from: .minXEdge)
            }
            else {
                (frameViews[i].frame, rect) = rect.divided(atDistance: 3 * bounds.width / 21, from: .minXEdge)
            }
        }
    }
    
    // MARK: - Update all screen
    func update() { setNeedsDisplay() }
}

// MARK: - Customed FrameView
class FrameView: UIView {
    // MARK: - UI Properties
    lazy var frameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 1
        label.backgroundColor = .lightGray
        addSubview(label)
        return label
    } ()
    lazy var scoreInputView: ScoreInputView = {
        let view = ScoreInputView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        addSubview(view)
        return view
    } ()
    lazy var scoreOutputLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 1
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    // MARK: - UI override functions
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (frameLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
        (scoreInputView.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
        (scoreOutputLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
    }
}

class ScoreInputLabelView: UIView {
    lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        inputLabel.frame = CGRect(x: 0, y: bounds.midY - bounds.maxX / 2, width: bounds.maxX, height: bounds.maxX)
    }
}

// MARK: - Customed ScoreInputView
class ScoreInputView: UIView {
    // MARK: - Properties
    var isLastFrame: Bool = false
    
    // MARK: - UI Properties
    lazy var firstScore: ScoreInputLabelView = {
        let view = ScoreInputLabelView()
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    } ()
    lazy var secondScore: ScoreInputLabelView = {
        let view = ScoreInputLabelView()
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.black.cgColor
        addSubview(view)
        return view
    } ()
    lazy var thirdScore: ScoreInputLabelView = {
        let view = ScoreInputLabelView()
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.black.cgColor
        return view
    } ()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isLastFrame {
            firstScore.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 2, height: bounds.maxY)
            firstScore.inputLabel.layer.cornerRadius = firstScore.bounds.width / 2
            firstScore.inputLabel.layer.masksToBounds = true
            firstScore.inputLabel.layer.borderWidth = 0.6
            secondScore.frame = CGRect(x: bounds.maxX / 2, y: 0, width: bounds.maxX / 2, height: bounds.maxY)
        }
        else {
            firstScore.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            secondScore.frame = CGRect(x: bounds.maxX / 3, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            thirdScore.frame = CGRect(x: 2 * bounds.maxX / 3, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            firstScore.inputLabel.layer.cornerRadius = firstScore.bounds.width / 2
            firstScore.inputLabel.layer.masksToBounds = true
            firstScore.inputLabel.layer.borderWidth = 0.6
            secondScore.inputLabel.layer.cornerRadius = secondScore.bounds.width / 2
            secondScore.inputLabel.layer.masksToBounds = true
            secondScore.inputLabel.layer.borderWidth = 0.6
            thirdScore.inputLabel.layer.cornerRadius = thirdScore.bounds.width / 2
            thirdScore.inputLabel.layer.masksToBounds = true
            thirdScore.inputLabel.layer.borderWidth = 0.6
            addSubview(thirdScore)
        }
    }
    
    // MARK: - helper method to highlight border
    func highlightBorder(turn: Int, on: Bool) {
        var highlightView = UIView()
        switch turn {
        case 0:
            highlightView = firstScore
        case 1:
            highlightView = secondScore
        case 2:
            highlightView = thirdScore
        default:
            return
        }
        if on {
            highlightView.backgroundColor = .yellow
        }
        else {
            highlightView.backgroundColor = .clear
        }
        setNeedsDisplay()
    }
}
