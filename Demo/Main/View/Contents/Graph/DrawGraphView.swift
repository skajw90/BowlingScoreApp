//
//  StatusGraphView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/9/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol DrawGraphViewDataSource {
    
}

class DrawGraphView: UIView {
    
    lazy var colorLabels: [UILabel] = []
    
    lazy var redLabel: UILabel = {
        let label = UILabel()
        label.text = "AVG"
        label.textColor = .red
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        addSubview(label)
        return label
    } ()
    
    lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.text = "H/G"
        label.textColor = .green
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        addSubview(label)
        return label
    } ()
    
    lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.text = "L/G"
        label.textColor = .blue
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        addSubview(label)
        return label
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBorder()
        update()
    }
    
    func update() {
        drawColorLabels()
        drawYAxisLabels()
    }
    
    func drawColorLabels() {
        
        redLabel.frame = CGRect(x: 66 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
        greenLabel.frame = CGRect(x: 56 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
        blueLabel.frame = CGRect(x: 46 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
    }
    
    func drawYAxisLabels() {
        // use data source to get values
        // from low to high?
        let data = [100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]
        let origin = CGPoint(x: bounds.maxX / 10, y: bounds.maxY / 15)
        let height = 4 * bounds.maxY / 5
        let width = 8.5 * bounds.maxX / 10
        
        let rawLength = height / CGFloat(data.count - 1)
        
        for i in 0 ..< data.count {
            let label = UILabel()
            label.text = "\(data[i])"
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
           
            addSubview(label)
            label.frame = CGRect(x: 0, y: origin.y - rawLength / 4 + CGFloat(10 - i) * rawLength, width: origin.x, height: rawLength / 2)
        }
        
        // get data for period
        let period = ["1\n20xx", "1\n20xx", "1\n20xx", "1\n20xx", "1\n20xx", "1\n20xx"]
        let columnLength = width / CGFloat(period.count)
        for i in 0 ..< period.count {
            let label = UILabel()
            label.text = "\(period[i])"
            label.numberOfLines = 2
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .center
            label.textColor = .white
            
            addSubview(label)
            label.frame = CGRect(x: columnLength / 2 + CGFloat(i) * columnLength, y: origin.y + height + 5, width: columnLength, height: 2 * bounds.maxY / 15 - 5)
        }
    }
    
    func drawGrid() {
        let context = UIGraphicsGetCurrentContext()!
        let origin = CGPoint(x: bounds.maxX / 10, y: bounds.maxY / 15)
        let height = 4 * bounds.maxY / 5
        let width = 8.5 * bounds.maxX / 10
        // depending on variance number of line will changing
        // use datasource to get values
        let rawLength = height / 10
        for i in 0 ..< 9 {
            let from = CGPoint(x: origin.x, y: CGFloat(i + 1) * (rawLength) + origin.y)
            let to = CGPoint(x: origin.x + width, y: CGFloat(i + 1) * (rawLength) + origin.y)
            context.move(to: from)
            context.addLine(to: to)
        }
        
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.white.cgColor)
        context.drawPath(using: .stroke)
    }
    
    func drawBorder() {
        let context = UIGraphicsGetCurrentContext()!
        let origin = CGPoint(x: bounds.maxX / 10, y: bounds.maxY / 15)
        let height = 4 * bounds.maxY / 5
        let width = 8.5 * bounds.maxX / 10
        context.move(to: origin)
        context.addLine(to: CGPoint(x: origin.x, y: origin.y + height))
        context.move(to: origin)
        context.addLine(to: CGPoint(x: origin.x + width, y: origin.y))
        context.move(to: CGPoint(x: origin.x + width, y: origin.y + height))
        context.addLine(to: CGPoint(x: origin.x, y: origin.y + height))
        context.move(to: CGPoint(x: origin.x + width, y: origin.y + height))
        context.addLine(to: CGPoint(x: origin.x + width, y: origin.y))
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.white.cgColor)
        context.drawPath(using: .stroke)
        drawGrid()
    }
}
