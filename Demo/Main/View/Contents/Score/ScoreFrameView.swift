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
    var dataSource: ScoreFrameViewDataSource?
    var delegate: ScoreFrameViewDelegate?
    var frameViews: [FrameView] = []
    
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
            }
        }
        
        for j in 0 ..< 21 {
            if j == 0 && scores.getInput(index: j) == nil {
                frameViews[j].scoreInputView.firstScore.backgroundColor = .yellow
            }
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
                    if j % 2 == 0 {
                        if score == 11 { result = "X" }
                    }
                    else {
                        if score == 11 {
                            if j == 19 && scores.getInput(index: j - 1) == 11 { result = "X"}
                            else { result = "/" }
                        }
                    }
                }
            }
            if j == 20 {
                frameViews[9].scoreInputView.thirdScore.text = result
            }
            else if j % 2 == 0 {
                frameViews[j / 2].scoreInputView.firstScore.text = result
            }
            else {
                frameViews[j / 2].scoreInputView.secondScore.text = result
            }
            
            if let delegate = delegate, frameViews[9].scoreOutputLabel.text != nil {
                delegate.enableSaveScore(isEnable: true)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        for i in 0 ..< 10 {
            if i != 9 {
                (frameViews[i].frame, rect) = rect.divided(atDistance: 2 * frame.maxX / 21, from: .minXEdge)
            }
            else {
                (frameViews[i].frame, rect) = rect.divided(atDistance: 3 * frame.maxX / 21, from: .minXEdge)
            }
        }
    }
    
    func update() {
        setNeedsDisplay()
    }
}

class FrameView: UIView {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (frameLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
        
        (scoreInputView.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
        
        (scoreOutputLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 3, from: .minYEdge)
    }
}

class ScoreInputView: UIView {
    var isLastFrame: Bool = false
    
    lazy var firstScore: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 0.3
        label.textAlignment = .center
        addSubview(label)
        return label
    } ()
    lazy var secondScore: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 0.3
        label.textAlignment = .center
        addSubview(label)
        return label
    } ()
    
    lazy var thirdScore: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 0.3
        label.textAlignment = .center
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isLastFrame {
            firstScore.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 2, height: bounds.maxY)
            secondScore.frame = CGRect(x: bounds.maxX / 2, y: 0, width: bounds.maxX / 2, height: bounds.maxY)
        }
        else {
            firstScore.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            secondScore.frame = CGRect(x: bounds.maxX / 3, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            thirdScore.frame = CGRect(x: 2 * bounds.maxX / 3, y: 0, width: bounds.maxX / 3, height: bounds.maxY)
            addSubview(thirdScore)
        }
    }
    
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
