//
//  newGameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ScoreListViewDelegate {
    func setCalendar(index: Int)
    func addNewGame(date: CalendarData)
    func editGame(date: CalendarData, index: Int)
}

protocol ScoreListViewDataSource {
    func getCurrentDate() -> CalendarData
    func getScores(tag: Int) -> GameScore
    func getAverages(interval: IntervalFormat) -> ScoreFormat
    func getNumOfData(date: CalendarData) -> Int
}

class ScoreListView: UIView, CalendarTopViewDelegate, CalendarTopViewDataSoucre, CalendarBottomViewDataSource, ScoreFrameViewDataSource {
    
    var selectedHeaderNum = -1
    var delegate: ScoreListViewDelegate?
    var dataSource: ScoreListViewDataSource?
    
    lazy var calendarTopView: CalendarTopView = {
        let view = CalendarTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.isCalendar = false
        addSubview(view)
        return view
    } ()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    lazy var calendarBottomView: CalendarBottomView = {
        let view = CalendarBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.isCalendar = false
        addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (calendarTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        
        (tableView.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 10, from: .minYEdge)
        
        (calendarBottomView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        
        tableView.rowHeight = tableView.bounds.maxY / 5
    }
    
    func setCalendar(index: Int) {
        delegate!.setCalendar(index: index)
    }
    
    func getCurrentDate() -> CalendarData {
        dataSource!.getCurrentDate()
    }
    
    func updateAll() {
        calendarTopView.updateDateLabel()
        calendarBottomView.updateDateLabel()
        tableView.reloadData()
    }
    
    func getAverages(interval: IntervalFormat) -> ScoreFormat {
        return dataSource!.getAverages(interval: interval)
    }
    
    func getSelectedFrame() -> (frame: Int, turn: Int) {
        return (frame: 0, turn: 0)
    }
    
    func getScores(tag: Int) -> GameScore {
        return dataSource!.getScores(tag: tag)
    }
}

extension ScoreListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.getNumOfData(date: getCurrentDate()) + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource!.getCurrentDate().toString()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellView()
        cell.backgroundColor = .white
        
        // TODO: add view to show pins or add new game
        if indexPath.row == 0 {
            cell.hasView = true
            let label = cell.textLabel!
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.text = "(+) add new game"
            label.textColor = .black
            label.textAlignment = .center
        }
        
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        let cellTagGesture = UITapGestureRecognizer()
        cellTagGesture.addTarget(self, action: #selector(rowSelected))
        cell.addGestureRecognizer(cellTagGesture)
        if !cell.hasView {
            let view = ScoreFrameView(frame: CGRect(x: 1 * frame.maxX / 36, y: 1 * tableView.rowHeight / 36, width: 34 * frame.maxX / 36, height: 34 * tableView.rowHeight / 36))
            view.tag = indexPath.row
            view.dataSource = self
            cell.addSubview(view)
        }
        return cell
    }
    
    @objc func rowSelected(sender: UITapGestureRecognizer) {
        let cell = sender.view as! CellView
        let row = cell.tag
        if row == 0 {
            delegate!.addNewGame(date: getCurrentDate())
        }
        else {
            delegate!.editGame(date: getCurrentDate(), index: row)
        }
    }
    
}

class CellView: UITableViewCell {
    var hasView: Bool = false
    var clicked: Bool = false
    static let lock = NSLock()
    static var count = 0
    
    let incrment: Void = {
        CellView.lock.lock()
        defer { CellView.lock.unlock() }
        CellView.count += 1
    }()
    
    deinit {
        CellView.lock.lock()
        defer { CellView.lock.unlock() }
        CellView.count -= 1
    }
}
