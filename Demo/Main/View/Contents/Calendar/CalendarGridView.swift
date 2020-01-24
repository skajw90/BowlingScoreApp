//
//  CalendarGridView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarGridViewDataSource {
    func getSelectedCell() -> Int?
    func getCalendarData() -> [Int]
}

class CalendarGridView: UIView {
    var dataSource: CalendarGridViewDataSource?
    var selectedCell: CalendarCell?
    var cells: [CalendarCell] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let xbound = bounds.maxX / 7
        let ybound = bounds.maxY / 6
        for i in 0 ..< 11 {
            context.move(to: CGPoint(x: 0, y: CGFloat(i) * ybound))
            context.addLine(to: CGPoint(x: bounds.width, y: CGFloat(i) * ybound))
            
            context.move(to: CGPoint(x: CGFloat(i) * xbound, y: 0))
            context.addLine(to: CGPoint(x: CGFloat(i) * xbound, y: bounds.height))
            
        }
        context.setStrokeColor(UIColor.black.cgColor)
        context.drawPath(using: .stroke)
        updateCells(map: dataSource!.getCalendarData())
    }
    
    func initializeCells() {
        for cell in cells {
            cell.removeFromSuperview()
        }
        cells = []
    }
    
    func updateCells(map: [Int]) {
        initializeCells()
        let width = bounds.width / 7
        let height = bounds.height / 6
        var isMain: Bool = false
        for y in 0 ..< 6 {
            for x in 0 ..< 7 {
                let cell = CalendarCell()
                cell.frame = CGRect(x: CGFloat(x) * width, y: CGFloat(y) * height, width: width, height: height)
                cell.x = x
                cell.y = y
                
                if map[7 * y + x] == 1 && !isMain {
                    isMain = true
                }
                else if isMain && map[7 * y + x] == 1 {
                    isMain = false
                }
            
                cell.isMainDaysInMonth = isMain
                cell.update(date: map[7 * y + x], avg: nil)
                cells.append(cell)
                addSubview(cells[7 * y + x])
            }
        }
        if let cellIndex = dataSource!.getSelectedCell() {
            selectedCell = cells[cellIndex]
            selectedCell!.isToday = true
        }
        else if let cell = selectedCell {
            cell.isToday = false
        }
    }
    
    var touchedCell: Int?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
