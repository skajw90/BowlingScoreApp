//
//  MenuPreview.swift
//  Demo
//
//  Created by Jiwon Nam on 1/19/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol MenuPreviewDelegate {
    func openMenu()
}

class MenuPreview: UIView {
    var delegate: MenuPreviewDelegate?
    
    lazy var menuPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("MENU", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(menuPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var logo: UILabel = {
        let test = UILabel()
        test.text = "LABEL"
        test.textColor = .white
        test.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        test.textAlignment = .center
        addSubview(test)
        return test
    } ()
    
    @objc func menuPrevBtnHandler(sender: Any) {
        print("menuPrev Clicked")
        delegate!.openMenu()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        logo.frame = CGRect(x: 0, y: 0, width: bounds.maxX, height: bounds.height)
        menuPreview.frame = CGRect(x: 0, y: 0, width: bounds.maxX / 5, height: bounds.height)
        
    }
}
