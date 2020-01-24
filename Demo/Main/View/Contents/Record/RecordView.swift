//
//  RecordView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class RecordView: UIView {
    lazy var sampleColor: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        addSubview(view)
        return view
    } ()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        sampleColor.frame = frame
    }
}
