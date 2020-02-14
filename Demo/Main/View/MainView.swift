//
//  MainView.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainView: UIView {
    // MARK: - UIView Properties
    lazy var menuPreview: MenuPreview = {
        let view = MenuPreview()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var topMenuSetView: TopMenuSetView = {
        let view = TopMenuSetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var contentsView: ContentsView = {
        let view = ContentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
    
    lazy var bottomMenuSetView: BottomMenuSetView = {
        let view = BottomMenuSetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    } ()
}
