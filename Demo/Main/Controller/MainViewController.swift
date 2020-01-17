//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BottomMenuSetViewDelegate, TopMenuSetViewDelegate, ContentsViewDataSource {
    
    var selectedContents: contentsType = .profile
    
    var mainView: MainView {
        return view as! MainView
    }

    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.frame = view.frame
        
        NSLayoutConstraint.activate([
            mainView.topMenuSetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.topMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.topMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.topMenuSetView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            
            mainView.contentsView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.contentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.contentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.contentsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            
            mainView.bottomMenuSetView.topAnchor.constraint(equalTo: mainView.contentsView.bottomAnchor),
            mainView.bottomMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.bottomMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomMenuSetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mainView.bottomMenuSetView.delegate = self
        mainView.topMenuSetView.delegate = self
        mainView.contentsView.dataSource = self
        mainView.contentsView.switchViews()
    }
    
    // contentsView dataSource
    func getContentsType() -> contentsType {
        return selectedContents
    }
    
    // top Menu delegate functions
    func openNewGame() {
        print("action open new game")
        selectedContents = .newGame
        mainView.contentsView.switchViews()
        // profileView switch to newGameView
    }
    
    func openCalendar() {
        print("action open calendar")
        selectedContents = .calendar
        mainView.contentsView.switchViews()
        // previous View switch to calendar view
    }
    
    func openCamera() {
        print("action open camera")
        selectedContents = .camera
        mainView.contentsView.switchViews()
        // start camera module
    }
    // bottom Menu delegate functions
    func openRecord() {
        print("action open record")
        selectedContents = .record
        mainView.contentsView.switchViews()
        // switch record view
    }
    
    func openGraph() {
        print("action open graph")
        selectedContents = .graph
        mainView.contentsView.switchViews()
        // switch graph view
    }
    
    func openAnalysis() {
        print("action open Analysis")
        selectedContents = .analysis
        mainView.contentsView.switchViews()
        // switch analysis view
    }
    
    func openSetting() {
        print("action open setting")
        selectedContents = .setting
        mainView.contentsView.switchViews()
        // switch setting view
    }
}

