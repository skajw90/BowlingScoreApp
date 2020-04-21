//
//  File.swift
//  Demo
//
//  Created by Jiwon Nam on 2/26/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol SearchClubViewDelegate {
    func requestSearchClubName(code: String)
    func removeSearchClubViewController()
}

class SearchClubView: UIView, SearchClubContentsViewDelegate {
    var delegate: SearchClubViewDelegate?
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        addSubview(view)
        return view
    } ()
    lazy var contents: SearchClubContentsView = {
        let view = SearchClubContentsView()
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        view.delegate = self
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = frame
        var rect = bounds
        (_, rect) = rect.divided(atDistance: 3 * bounds.maxY / 8, from: .minYEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxX / 12, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxX / 12, from: .maxXEdge)
        (contents.frame, rect) = rect.divided(atDistance: bounds.maxY / 4, from: .minYEdge)
    }
    
    func requestSearchClubName(code: String) {
        delegate!.requestSearchClubName(code: code)
    }
    
    func removeSearchClubViewController() {
        delegate!.removeSearchClubViewController()
    }
}
