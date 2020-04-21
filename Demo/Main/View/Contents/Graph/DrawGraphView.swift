//
//  StatusGraphView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/9/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol DrawGraphViewDataSource {
    func getXValuesForGraph() -> [(from: CalendarData, to: CalendarData, data: Any?)]
    func getSelectedSegment() -> Int
    func getLabelText() -> (String, String, String)
}

class DrawGraphView: UIView {
    var dataSource: DrawGraphViewDataSource?
    var origin:CGPoint = CGPoint()
    var height: CGFloat = 0
    var width: CGFloat = 0
    var lineWidth: CGFloat = 2
    // MARK: - UI Properties
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
    lazy var xAxisLabels: [UILabel] = []
    lazy var yAxisLabels: [UILabel] = []
    
    // MARK: - UIView Override Functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        origin = CGPoint(x: bounds.maxX / 10, y: bounds.maxY / 15)
        height = 4 * bounds.maxY / 5
        width = 8.5 * bounds.maxX / 10
        drawBorder()
        update()
    }
    
    // MARK: - Helper Method to update Data
    func update() {
        clearAllLabels()
        drawColorLabels()
        drawAxisLabels()
        //setNeedsDisplay()
    }
    
    private func clearAllLabels() {
        for label in xAxisLabels {
            label.removeFromSuperview()
        }
        for label in yAxisLabels {
            label.removeFromSuperview()
        }
        xAxisLabels = []
        yAxisLabels = []
    }
    private func drawColorLabels() {
        redLabel.frame = CGRect(x: 66 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
        greenLabel.frame = CGRect(x: 56 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
        blueLabel.frame = CGRect(x: 46 * bounds.maxX / 80, y: 0, width: bounds.maxX / 8, height: bounds.maxY / 15)
        let labelData = dataSource!.getLabelText()
        redLabel.text = labelData.0
        greenLabel.text = labelData.1
        blueLabel.text = labelData.2
    }
    private func drawAxisLabels() {
        var prevRedValue: CGPoint?
        var prevGreenValue: CGPoint?
        var prevBlueValue: CGPoint?
        var period: [String] = []
        var highest: Float?
        var lowest: Float?
        let context = UIGraphicsGetCurrentContext()!
        
        // get data for period
        let graphData = dataSource!.getXValuesForGraph()
        let selectedSegment = dataSource!.getSelectedSegment()
        var isScore = false
        // set text for X-Y Axis
        for i in 0 ..< graphData.count {
            var temp = "\(graphData[i].from.year!)"
            if selectedSegment == 0 { temp += "\n\(graphData[i].from.month!)"}
            else if selectedSegment != 3 {
                var to = graphData[i].to
                to.month! -= 1
                if to.month == 0 {
                    to.year! -= 1
                    to.month = 12
                }
                temp += "\n\(graphData[i].from.month!)~\(to.month!)"
            }
            period.append(temp)
            // set y axis bounds
            if let temp = graphData[i].data {
                if let stat = temp as? StatFormat {
                    if let high = highest, let low = lowest {
                        highest = max(Float(stat.openCount) / Float(stat.num) * 100, Float(stat.spareCount) / Float(stat.num) * 100, Float(stat.strikeCount) / Float(stat.num) * 100, high)
                        lowest = min(Float(stat.openCount) / Float(stat.num) * 100, Float(stat.spareCount) / Float(stat.num) * 100, Float(stat.strikeCount) / Float(stat.num) * 100, low)
                    }
                    else {
                        highest = max(Float(stat.openCount) / Float(stat.num) * 100, Float(stat.spareCount) / Float(stat.num) * 100, Float(stat.strikeCount) / Float(stat.num) * 100)
                        lowest = min(Float(stat.openCount) / Float(stat.num) * 100, Float(stat.spareCount) / Float(stat.num) * 100, Float(stat.strikeCount) / Float(stat.num) * 100)
                    }
                }
                else if let score = temp as? ScoreOverallFormat {
                    isScore = true
                    if let high = highest, let low = lowest {
                        highest = max(score.avg!, Float(score.high!), Float(score.low!), high)
                        lowest = min(score.avg!, Float(score.high!), Float(score.low!), low)
                    }
                    else {
                        highest = max(score.avg!, Float(score.high!), Float(score.low!))
                        lowest = min(score.avg!, Float(score.high!), Float(score.low!))
                    }
                }
            }
        }
        let diff = isScore ? 20 : 10
        if highest == nil {
            highest = 250
            lowest = 150
        }
        else {
            highest = Int(highest! / Float(diff)) * diff < (isScore ? 280 : 90) ? Float(Int(highest! / Float(diff)) * diff + diff) : (isScore ? 300 : 100)
            lowest = Int(lowest! / Float(diff)) * diff > diff ? Float(Int(lowest! / Float(diff)) * diff - diff) : 0
        }
        // draw labels and lines
        let yLabelCount = Int(highest! - lowest!) / diff + 1
        let yLabelHeight = height / CGFloat(yLabelCount + 1)
        let xLabelWidth = width / CGFloat(period.count)
        
        for i in 0 ..< yLabelCount {
            let label = UILabel()
            label.text = "\(Int(lowest!) + i * diff)"
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            addSubview(label)
            let labelMidYPos = origin.y + height - (CGFloat(i) + 1) * yLabelHeight
            label.frame = CGRect(x: 0, y: origin.y + height - (CGFloat(i) + 1.25) * yLabelHeight , width: origin.x, height: yLabelHeight / 2)

            let from = CGPoint(x: origin.x, y: labelMidYPos)
            let to = CGPoint(x: origin.x + width, y: labelMidYPos)
            context.move(to: from)
            context.addLine(to: to)
            context.setLineWidth(0.5)
            context.setStrokeColor(UIColor.white.cgColor)
            context.drawPath(using: .stroke)
            yAxisLabels.append(label)
        }
        
        for i in 0 ..< period.count {
            let label = UILabel()
            label.text = "\(period[i])"
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .center
            label.textColor = .white
            addSubview(label)
            xAxisLabels.append(label)
            let labelMidXpos = origin.x + CGFloat(CGFloat(i) + 0.5) * xLabelWidth
            label.frame = CGRect(x: origin.x + CGFloat(i) * xLabelWidth, y: origin.y + height + 5, width: xLabelWidth, height: 2 * bounds.maxY / 15 - 5)
            
            let from = CGPoint(x: labelMidXpos, y: origin.y + height)
            let to = CGPoint(x: labelMidXpos, y: origin.y + height - 5)
            context.move(to: from)
            context.addLine(to: to)
            context.setLineWidth(0.5)
            context.setStrokeColor(UIColor.white.cgColor)
            context.drawPath(using: .stroke)
            
            if let temp = graphData[i].data {
                var redData = CGFloat()
                var greenData = CGFloat()
                var blueData = CGFloat()
                if let value = temp as? StatFormat {
                    redData = CGFloat(Float(value.strikeCount) / Float(value.num) * 100 - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                    greenData = CGFloat(Float(value.spareCount) / Float(value.num) * 100 - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                    blueData = CGFloat(Float(value.openCount) / Float(value.num) * 100 - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                }
                else if let value = temp as? ScoreOverallFormat {
                    redData = CGFloat(value.avg! - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                    greenData = CGFloat(Float(value.high!) - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                    blueData = CGFloat(Float(value.low!) - lowest!) / CGFloat(diff) * yLabelHeight + yLabelHeight
                }
                let curRed = CGPoint(x: labelMidXpos, y: origin.y + height - redData)
                let curGreen = CGPoint(x: labelMidXpos, y: origin.y + height - greenData)
                let curBlue = CGPoint(x: labelMidXpos, y: origin.y + height - blueData)
                
                if prevRedValue != nil && prevGreenValue != nil && prevBlueValue != nil {
                    drawLine(context: context, color: UIColor.red.cgColor, from: prevRedValue!, to: curRed)
                    drawLine(context: context, color: UIColor.green.cgColor, from: prevGreenValue!, to: curGreen)
                    drawLine(context: context, color: UIColor.blue.cgColor, from: prevBlueValue!, to: curBlue)
                }
                drawDot(context: context, color: UIColor.red.cgColor, at: curRed)
                drawDot(context: context, color: UIColor.green.cgColor, at: curGreen)
                drawDot(context: context, color: UIColor.blue.cgColor, at: curBlue)
                
                prevRedValue = curRed
                prevGreenValue = curGreen
                prevBlueValue = curBlue
            }
        }
    }
    private func drawDot(context: CGContext, color: CGColor, at: CGPoint) {
        let centerRect = CGRect(x: at.x - 2, y: at.y - 2, width: 4, height: 4)
        context.setFillColor(color)
        context.setLineWidth(0.1)
        context.addEllipse(in: centerRect)
        context.drawPath(using: .fillStroke)
    }
    
    private func drawLine(context: CGContext, color: CGColor, from: CGPoint, to: CGPoint) {
        context.move(to: from)
        context.addLine(to: to)
        context.setLineWidth(1.5)
        context.setStrokeColor(color)
        context.drawPath(using: .stroke)
    }
    private func drawGrid() {
        let context = UIGraphicsGetCurrentContext()!
        let rawLength = height / 12
        for i in 0 ..< 13 {
            let label = UILabel()
            label.text = "\(i * 25)"
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.adjustsFontForContentSizeCategory = true
            addSubview(label)
            label.frame = CGRect(x: 0, y: origin.y - rawLength / 4 + CGFloat(12 - i) * rawLength, width: origin.x, height: rawLength / 2)
        }
        for i in 0 ..< 12 {
            let from = CGPoint(x: origin.x, y: CGFloat(i + 1) * (rawLength) + origin.y)
            let to = CGPoint(x: origin.x + width, y: CGFloat(i + 1) * (rawLength) + origin.y)
            context.move(to: from)
            context.addLine(to: to)
            if i % 2 == 0 {
                context.setLineWidth(0.5)
                context.setStrokeColor(UIColor.white.cgColor)
                context.drawPath(using: .stroke)
            }
            else {
                context.setLineWidth(0.5)
                context.setStrokeColor(UIColor.white.cgColor)
                context.drawPath(using: .eoFillStroke)
            }
        }
    }
    func drawBorder() {
        let context = UIGraphicsGetCurrentContext()!
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
    }
}
