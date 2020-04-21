//
//  ClubTopMenuView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/29/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ClubTopMenuViewDelegate {
    func openContentsView(with: String)
}

class ClubTopMenuView: UIView {
    var delegate: ClubTopMenuViewDelegate?
    
    lazy var profilePrevButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Profile", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(previewButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var teamInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Team", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(previewButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Calendar", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(previewButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var newGameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("New", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(previewButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var rankingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Ranking", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(previewButtonHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (profilePrevButton.frame, rect) = rect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (newGameButton.frame, rect) = rect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (teamInfoButton.frame, rect) = rect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (calendarButton.frame, rect) = rect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
        (rankingButton.frame, rect) = rect.divided(atDistance: bounds.maxX / 5, from: .minXEdge)
    }
    
    @objc func previewButtonHandler(sender: UIButton) {
        delegate!.openContentsView(with: sender.titleLabel!.text!)
    }
}
