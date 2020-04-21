//
//  CameraScoreView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/11/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CameraScoreviewDelegate {
    func retakeCamera()
}

protocol CameraScoreViewDataSource {
    func getLineDataFromCamera() -> [ScoreFrameView]
    func getTestStringData() -> [[String]]
    func getTestActualData() -> [[String]]
}

class CameraScoreView: UIView, CameraOperatorViewDelegate {
    
    // MARK: - Properties
    var dataSource: CameraScoreViewDataSource?
    var delegate: CameraScoreviewDelegate?
    var selectedRaw: [Bool] = []
    
    // MARK: - UI Properties
    lazy var scoreButton: [UIButton] = []
    lazy var scoreLabel: [UILabel] = []
    lazy var scoreListView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    lazy var actualResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    } ()
    lazy var operatorView: CameraOperatorView = {
        let view = CameraOperatorView()
        view.delegate = self
        view.backgroundColor = .black
        view.retakeCameraButton.setTitle("Edit", for: .normal)
        view.addRetakeCameraView()
        view.takePhotoButton.setTitle("Save", for: .normal)
        addSubview(view)
        return view
    } ()
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(button)
        return button
    } ()
    
    // MARK: - UIView Override Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (scoreListView.frame, rect) = rect.divided(atDistance: 4 * bounds.height / 5, from: .minYEdge)
        (operatorView.frame, rect) = rect.divided(atDistance: bounds.height / 5, from: .minYEdge)
    }
    
    // MARK: - UIButton Action Handler Function
    @objc func buttonClickHandler(sender: UIButton) {
           print("\(sender.tag) clicked")
           // need to add edit or save button or open edit game view
           if selectedRaw[sender.tag] == true {
               selectedRaw[sender.tag] = false
               scoreButton[sender.tag].backgroundColor = .clear
           }
           else {
               selectedRaw[sender.tag] = true
               scoreButton[sender.tag].backgroundColor = .systemBlue
           }
       }
    
    // MARK: - Helper Method to change Button Properties
    func resetButton() {
        for i in 0 ..< scoreButton.count {
            scoreButton[i].removeFromSuperview()
            scoreLabel[i].removeFromSuperview()
        }
        scoreButton = []
        scoreLabel = []
        actualResultLabel.text = ""
    }
    
    // MARK: - Helper Method to update Data
    func update() {
        resetButton()
        let data = dataSource!.getLineDataFromCamera()
        let labelData = dataSource!.getTestStringData()
        let actualData = dataSource!.getTestActualData()
        let testReusltLabel = UILabel()
        testReusltLabel.text = ""
        for i in 0 ..< actualData.count {
            testReusltLabel.text! += " \(actualData[i])"
            testReusltLabel.text! += "\n"
        }
        for i in 0 ..< data.count {
            let button = UIButton()
            selectedRaw.append(false)
            let scoreFrameView = data[i]
            let label = UILabel()
            let scoreText = labelData[i]
            button.frame = CGRect(x: 0, y: CGFloat(2 * i) *
                3 * bounds.height / 16 + bounds.height / 16, width: frame.width, height: bounds.height / 8)
            label.frame = CGRect(x: 0, y: CGFloat(2 * i + 1) *
            3 * bounds.height / 16 + bounds.height / 16, width: frame.width, height: bounds.height / 8)
            button.tag = i
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 2
            scoreFrameView.frame = button.bounds
            scoreFrameView.isUserInteractionEnabled = false
            label.numberOfLines = 3
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            label.textColor = .black
            label.text = ""
            for j in 0 ..< scoreText.count {
                label.text! += " \(scoreText[j])"
            }
            button.addSubview(scoreFrameView)
            button.addTarget(self, action: #selector(buttonClickHandler), for: UIControl.Event.touchDown)
            scoreListView.addSubview(button)
            scoreListView.addSubview(label)
            scoreButton.append(button)
            scoreLabel.append(label)
        }
        testReusltLabel.textColor = .black
        testReusltLabel.textAlignment = .left
        testReusltLabel.numberOfLines = 0
        testReusltLabel.adjustsFontForContentSizeCategory = true
        testReusltLabel.frame = CGRect(x: 0, y: CGFloat(2 * data.count + 1) *
        3 * bounds.height / 16 + bounds.height / 16, width: frame.width, height: 2 * bounds.height)
        scoreListView.addSubview(testReusltLabel)
        scoreListView.contentSize = scoreListView.subviews.reduce(CGRect.zero, {
           return $0.union($1.frame)
        }).size
        scoreListView.contentSize.width = 0
    }
    
    // MARK: - CameraOperatorViewdelegate Functions
    func cancelCamera() {
        print("dismiss, and rerun camera")
        delegate!.retakeCamera()
    }
    func takePicture() {
        print("save all selected items")
    }
    func retakeCamera() {
        print("Edit selected item")
    }
}
