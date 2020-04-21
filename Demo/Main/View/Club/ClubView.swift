//
//  File.swift
//  Demo
//
//  Created by Jiwon Nam on 2/26/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ClubViewDataSource {
    func getClubName() -> String
    func isClubMaster() -> Bool
}

protocol ClubViewDelegate {
    func openContentsView(with: String)
    func exitClubView()
}

class ClubView: UIView, ClubTopMenuViewDelegate {
    
    var delegate: ClubViewDelegate?
    var dataSource: ClubViewDataSource?
    
    lazy var clubNameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.layer.borderWidth = 1
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        return label
    } ()
    
    lazy var exitClubButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("X", for: .normal)
        button.backgroundColor = .black
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(exitButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var clubTopMenuView: ClubTopMenuView = {
        let view = ClubTopMenuView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var contentsView: ClubContentsView = {
        let view = ClubContentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    
    lazy var clubMasterButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(masterButtonHandler), for: UIControl.Event.touchDown)
        return button
    } ()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("SET", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(settingButtonHandler), for: UIControl.Event.touchDown)
        return button
    } ()
    
    @objc func masterButtonHandler(sender: UIButton) {
        
    }
    
    @objc func settingButtonHandler(sender: UIButton) {
        
    }
    
    @objc func exitButtonHandler(sender: UIButton) {
        delegate!.exitClubView()
    }
    
    func openContentsView(with: String) {
        delegate!.openContentsView(with: with)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clubNameLabel.text = dataSource!.getClubName()
        let length: CGFloat = bounds.maxX / 7
        let settingRect = CGRect(x: bounds.maxX - 3 * length / 2, y: bounds.maxY - 3 * length / 2, width: length, height: length)
        if(dataSource!.isClubMaster()) {
            settingButton.removeFromSuperview()
            addSubview(clubMasterButton)
            clubMasterButton.frame = settingRect
        }
        else {
            clubMasterButton.removeFromSuperview()
            addSubview(settingButton)
            settingButton.frame = settingRect
        }
    }
    
}

class ClubProfileView: UIView {
    lazy var sampleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        addSubview(view)
        return view
    } ()
    
    lazy var sampleView2: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (sampleView.frame, rect) = rect.divided(atDistance: bounds.maxY / 2, from: .minYEdge)
        (sampleView2.frame, rect) = rect.divided(atDistance: bounds.maxY / 2, from: .minYEdge)
    }
}


class ClubContentsView: UIView {
    // MARK: - UI Properties
    var curView: UIView = ClubProfileView()
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        curView.backgroundColor = .white
        curView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(curView)
    }
    
    // MARK: - Helper Method to change view with params
    func switchViews(selectedType: String) {
        let preView = curView
        switch selectedType {
        case "Profile": curView = ClubProfileView()
        case "New": curView = ClubNewGameView()
        case "Calendar": curView = ClubCalendarView()
        case "Team": curView = ClubTeamView()
        case "Ranking": curView = ClubRankingView()
        default: curView = UIView()
        }
        preView.swapViews(next: curView)
        setNeedsDisplay()
    }
}

class ClubNewGameView: UIView {
    
}

class ClubCalendarView: CalendarView {
    
}

class ClubTeamView: UIView {
    
}

class ClubRankingView: UIView {
    
}
