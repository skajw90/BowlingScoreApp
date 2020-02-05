//
//  CalendarGridView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol CalendarGridViewDelegate {
    func changeCalendar(isPrev: Bool)
    func openEditGames(pos: Int)
}

protocol CalendarGridViewDataSource {
    func getSelectedCell() -> Int?
    func getCalendarData() -> [Int]
    func hasContent(index: Int) -> Bool
}

class CalendarGridView: UIView {
    var dataSource: CalendarGridViewDataSource?
    var delegate: CalendarGridViewDelegate?
    var todayCell: CalendarCell?
    var selectedCell: Int?
    var firstTouchedCell: Int?
    var cells: [CalendarCell] = []
    var map: [Int] = []
    
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
    
    func updateCells() {
        updateCells(map: map)
    }
    
    func updateCells(map: [Int]) {
        self.map = map
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
                if isMain {
                    if dataSource!.hasContent(index: map[7 * y + x]) {
                        cell.hasContent = true
                    }
                    else {
                        cell.hasContent = false
                    }
                }
                else {
                    cell.hasContent = false
                }
                cell.update(date: map[7 * y + x], avg: nil)
                cells.append(cell)
                addSubview(cells[7 * y + x])
            }
        }
        if let cellIndex = dataSource!.getSelectedCell() {
            todayCell = cells[cellIndex]
            todayCell!.isToday = true
        }
        else if let cell = todayCell {
            cell.isToday = false
        }
        if let selectedCell = selectedCell {
            cells[selectedCell].backgroundColor = .lightGray
            cells[selectedCell].alpha = 0.7
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        firstTouchedCell = getTouchedCell(location: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let endLocation = getTouchedCell(location: location)
        if firstTouchedCell == endLocation {
            if let selectedCell = selectedCell {
                if selectedCell == firstTouchedCell {
                    self.selectedCell = nil
                    print("open edit games")
                    delegate!.openEditGames(pos: selectedCell)
                }
                else {
                    self.selectedCell = firstTouchedCell
                }
            }
            else {
                self.selectedCell = firstTouchedCell
            }
            updateCells()
        }
    }
    
    func getTouchedCell(location: CGPoint) -> Int {
        return Int(location.x / (bounds.maxX / 7)) + Int(location.y / (bounds.maxY / 6)) * 7
    }
}
