//
//  ContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

enum contentsType {
    case profile
    case newGame
    case camera
    case calendar
    case record
    case graph
    case analysis
    case setting
}

protocol ContentsViewDataSource {
    func getContentsType() -> contentsType
}

class ContentsView: UIView {
    var dataSource: ContentsViewDataSource?
    var curType: contentsType = .profile
    var curView: UIView = ProfileView()
    lazy var profileView: ProfileView = {
        let view = ProfileView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    lazy var newGameView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    lazy var recordView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        curView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(curView)
    }
    
    func switchViews() {
        curView.removeFromSuperview()
        switch dataSource!.getContentsType() {
        case .profile:
            curView = profileView
        case .newGame:
            curView = newGameView
        case .record:
            curView = recordView
        default:
            curView = profileView
        }
        setNeedsDisplay()
    }
}
