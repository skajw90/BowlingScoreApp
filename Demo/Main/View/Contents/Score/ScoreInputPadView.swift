//
//  ScoreInputPad.swift
//  Demo
//
//  Created by Jiwon Nam on 1/28/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreInputPadViewDelegate {
    func setCurrentFrameNumber(index: Int)
    func setScoreByPad(score: Int, isSplit: Bool)
}

protocol ScoreInputPadViewDataSource {
    func getAvailableScores() -> [Bool]
    func getNextAvailable(index: Int) -> Bool
    func getSelectedFrame() -> (frame: Int, turn: Int)
}

class ScoreInputPadView: UIView, NumberPadViewDataSource, NumberPadViewDelegate {
    // MARK: - Properties
    var delegate: ScoreInputPadViewDelegate?
    var dataSource: ScoreInputPadViewDataSource?
    var isSplit: Bool = false
    // MARK: - UI Properties
    lazy var frameCounterLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        addSubview(label)
        return label
    } ()
    lazy var numberPadView: NumberPadView = {
        let view = NumberPadView()
        view.dataSource = self
        view.delegate = self
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        addSubview(view)
        return view
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
    lazy var splitButton: UIButton = {
        let button = UIButton()
        button.setTitle("SPLIT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(splitBtnHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !dataSource!.getNextAvailable(index: -1) {
            prevScoreBtn.alpha = 0.5
            prevScoreBtn.isEnabled = false
        }
        else {
            prevScoreBtn.alpha = 1
            prevScoreBtn.isEnabled = true
        }
        if !dataSource!.getNextAvailable(index: 1) {
            nextScoreBtn.alpha = 0.5
            nextScoreBtn.isEnabled = false
        }
        else {
            nextScoreBtn.alpha = 1
            nextScoreBtn.isEnabled = true
        }
        let nextAvailableScores = dataSource!.getAvailableScores()
        numberPadView.update(availableSet: nextAvailableScores)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (splitButton.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        rect = CGRect(x: rect.minX, y: rect.minY, width: rect.maxX, height: 8 * rect.maxY / 10)
        (prevScoreBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 6, from: .minXEdge)
        (numberPadView.frame, rect) = rect.divided(atDistance: 2 * frame.maxX / 3, from: .minXEdge)
        (nextScoreBtn.frame, rect) = rect.divided(atDistance: frame.maxX / 6, from: .minXEdge)
    }
    
    // MARK: - UIButton action handler
    @objc func scoreBtnHandler(sender: UIButton) {
        if sender.tag == 0 && dataSource!.getNextAvailable(index: -1) {
            print("go back to prev score")
            delegate!.setCurrentFrameNumber(index: -1)
        }
        if sender.tag == 1 && dataSource!.getNextAvailable(index: 1) {
            print("go next score")
            delegate!.setCurrentFrameNumber(index: 1)
        }
        setNeedsDisplay()
    }
    
    @objc func splitBtnHandler(sender: UIButton) {
        isSplit = !isSplit
    }
    
    // MARK: - NumberPadViewDataSource Functions
    func getIsFirstTurn() -> Bool {
        if dataSource!.getSelectedFrame().turn == 0 || dataSource!.getSelectedFrame().turn == 2 {
            isSplit = false
            return true
        }
        return false
    }

    // MARK: - NumberPadViewDelegate Functions
    func setScoreByPad(score: Int) {
        delegate!.setScoreByPad(score: score, isSplit: isSplit)
        setNeedsDisplay()
    }
}

protocol NumberPadViewDataSource {
    func getIsFirstTurn() -> Bool
}

protocol NumberPadViewDelegate {
    func setScoreByPad(score: Int)
}

// MARK: - Customed NumberPadView
class NumberPadView: UIView {
    // MARK: - Properties
    var dataSource: NumberPadViewDataSource?
    var delegate: NumberPadViewDelegate?
    var numberpads: [NumberPadCell] = []
    
    // MARK: - UIView Override Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0 ..< 12 {
            let tempCell = NumberPadCell()
            tempCell.tag = i
            tempCell.addTarget(self, action: #selector(numberPadCellBtnHandler), for: UIControl.Event.touchDown)
            numberpads.append(tempCell)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for i in 0 ..< 12 {
            let tempCell = numberpads[i]
            if i == 10 {
                tempCell.label.text = "F"
                tempCell.frame = CGRect(x: 0, y: 3 * bounds.maxY / 4, width: bounds.maxX / 3, height: bounds.maxY / 4)
            }
            else if i == 11 {
                if dataSource!.getIsFirstTurn() {
                    tempCell.label.text = "X"
                }
                else {
                    tempCell.label.text = "/"
                }
               tempCell.frame = CGRect(x: 2 * bounds.maxX / 3, y: 3 * bounds.maxY / 4, width: bounds.maxX / 3, height: bounds.maxY / 4)
            }
            else if i == 0 {
                tempCell.label.text = "\(i)"
                tempCell.frame = CGRect(x: bounds.maxX / 3, y: 3 * bounds.maxY / 4, width: bounds.maxX / 3, height: bounds.maxY / 4)
            }
            else {
                tempCell.label.text = "\(i)"
                tempCell.frame = CGRect(x: CGFloat((i - 1) % 3) * bounds.maxX / 3, y: CGFloat(2 - Int((i - 1) / 3)) * bounds.maxY / 4, width: bounds.maxX / 3, height: bounds.maxY / 4)
            }
        }
    }
    
    // MARK: - UIButton Action Handler
    @objc func numberPadCellBtnHandler(sender: UIButton) {
        delegate!.setScoreByPad(score: sender.tag)
    }
    
    // MARK: - Update all properties and view
    func update(availableSet: [Bool]) {
        for i in 0 ..< 12 {
            if availableSet[i] {
                numberpads[i].removeFromSuperview()
                addSubview(numberpads[i])
            }
            else { numberpads[i].removeFromSuperview() }
        }
        setNeedsDisplay()
    }
}

// MARK: - Customed UIButton
class NumberPadCell: UIButton {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        label.textAlignment = .center
        label.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.layer.borderWidth = 1
        addSubview(label)
        return label
    } ()
       
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        label.frame = bounds
    }
}

class PinPadView: UIView {
    
}
