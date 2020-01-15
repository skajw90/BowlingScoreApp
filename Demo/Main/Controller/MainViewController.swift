//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BottomMenuSetViewDelegate, TopMenuSetViewDelegate {

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
            
            mainView.profileView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.profileView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.profileView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.profileView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            
            mainView.bottomMenuSetView.topAnchor.constraint(equalTo: mainView.profileView.bottomAnchor),
            mainView.bottomMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.bottomMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomMenuSetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mainView.bottomMenuSetView.delegate = self
        mainView.topMenuSetView.delegate = self
    }
    
    // top Menu delegate functions
    func openNewGame() {
        print("action open new game")
    }
    
    func openCalendar() {
        print("action open calendar")
    }
    
    func openCamera() {
        print("action open camera")
        
    }
    // bottom Menu delegate functions
    func openRecord() {
        print("action open record")
    }
    
    func openGraph() {
        print("action open graph")
    }
    
    func openAnalysis() {
        print("action open Analysis")
    }
    
    func openSetting() {
        print("action open setting")
    }
}

