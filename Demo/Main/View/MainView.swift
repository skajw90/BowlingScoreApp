//
//  MainView.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainView: UIView {
    lazy var topMenuSetView: TopMenuSetView = {
        let view = TopMenuSetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var bottomMenuSetView: BottomMenuSetView = {
        let view = BottomMenuSetView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
}
