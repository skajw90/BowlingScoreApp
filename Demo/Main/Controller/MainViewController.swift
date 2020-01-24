//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuSetControllerDataSource, MenuPreviewDelegate {

    // add profile to initialize each controllers
    var menuSetController: MenuSetController?
    
    var userData: UserData = UserData(userID: "TEST", overall: nil, dataFiles: nil, joinedClub: nil)
    var userSetting = (0, 0 , IntervalFormat.year)
    
    func loadUserInfo() {
        
    }
    
    func saveUserInfo() {
        
    }
    
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
            mainView.menuPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.menuPreview.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.menuPreview.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.menuPreview.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.topMenuSetView.topAnchor.constraint(equalTo: mainView.menuPreview.bottomAnchor),
            mainView.topMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.topMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.topMenuSetView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.contentsView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.contentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.contentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.contentsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.76),
            
            mainView.bottomMenuSetView.topAnchor.constraint(equalTo: mainView.contentsView.bottomAnchor),
            mainView.bottomMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.bottomMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomMenuSetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        menuSetController = MenuSetController(mainView: mainView)
        mainView.menuPreview.delegate = self
        menuSetController!.dataSource = self
        menuSetController!.openProfile()
    }
    
    // top Menu delegate functions
    func openMenu() {
        
    }
    
    func getUserID() -> String {
        return userData.userID!
    }
    
    func getUserOverall() -> ScoreFormat? {
        return userData.overall
    }
}

