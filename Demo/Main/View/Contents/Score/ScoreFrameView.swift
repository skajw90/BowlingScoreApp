//
//  ScoreFrameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreFrameViewDataSource {
    func getSelectedFrame() -> Int
}

class ScoreFrameView: UIView {
    var dataSource: ScoreFrameViewDataSource?
    var isPreView: Bool = false
    var turn: Int = 0
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
        
        for i in 0 ..< 10 {
            if !isPreView {
                // set highlight for current frame
                if i == dataSource!.getSelectedFrame() {
                    frameViews[i].scoreInputView.highlightBorder(turn: turn)
                }
            }
            else {
                // get all score data
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        for i in 0 ..< 10 {
            (frameViews[i].frame, rect) = rect.divided(atDistance: frame.maxX / 10, from: .minXEdge)
        }
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
    
    func highlightBorder(turn: Int) {
        switch turn {
        case 0:
            firstScore.backgroundColor = .yellow
        case 1:
            secondScore.backgroundColor = .yellow
        case 2:
            thirdScore.backgroundColor = .yellow
        default:
            return
        }
    }
}
