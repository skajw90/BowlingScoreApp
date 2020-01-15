//
//  ProfileView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    lazy var profilePictureView: ProfilePictureView = {
        let view = ProfilePictureView()
        view.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        addSubview(view)
        return view
    } ()
    
    lazy var profileInfoView: ProfileInfoView = {
        let view = ProfileInfoView()
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (profilePictureView.frame, rect) = rect.divided(atDistance: frame.width * 0.3, from: .minXEdge)
        
        (profileInfoView.frame, rect) = rect.divided(atDistance: frame.width * 0.7, from: .minXEdge)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
