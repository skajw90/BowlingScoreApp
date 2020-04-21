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
    func addNewGame(date: CalendarData, index: Int)
    func editGame(date: CalendarData, index: Int)
}

protocol ScoreListViewDataSource {
    func getCurrentDate() -> CalendarData
    func getScores(tag: Int) -> GameScore
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat
    func getNumOfData(date: CalendarData) -> Int
}

class ScoreListView: UIView, CalendarTopViewDelegate, CalendarTopViewDataSoucre, CalendarBottomViewDataSource, ScoreFrameViewDataSource {
    
    // MARK: - Properties
    var selectedHeaderNum = -1
    var delegate: ScoreListViewDelegate?
    var dataSource: ScoreListViewDataSource?
    
    // MARK: - UI Properties
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
    
    // MARK: - UI overrride functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (calendarTopView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        (tableView.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 10, from: .minYEdge)
        (calendarBottomView.frame, rect) = rect.divided(atDistance: frame.maxY / 10, from: .minYEdge)
        tableView.rowHeight = tableView.bounds.maxY / 6
    }
    
    // MARK: - UI update all views
    func updateAll() {
        calendarTopView.updateDateLabel()
        calendarBottomView.updateDateLabel()
        tableView.reloadData()
    }
    
    // MARK: - CalendarTopViewDataSource Functions
    func getCurrentDate() -> CalendarData { dataSource!.getCurrentDate() }
    
    // MARK: - CalendarTopViewDelegate Functions
    func setCalendar(index: Int) { delegate!.setCalendar(index: index) }
    
    // MARK: - CalendarBottomViewDataSource Functions
    func getAverages(interval: IntervalFormat) -> ScoreOverallFormat { return dataSource!.getAverages(interval: interval)}
    
    // MARK: - ScoreFrameViewDataSource Functions
    func getSelectedFrame() -> (frame: Int, turn: Int) { return (frame: 0, turn: 0) }
    func getScores(tag: Int) -> GameScore { return dataSource!.getScores(tag: tag) }
}

// MARK: - UITableView Datasource
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
//        cell.selectionStyle = .none
        let cellTagGesture = UITapGestureRecognizer()
        cellTagGesture.addTarget(self, action: #selector(rowSelected))
        cell.addGestureRecognizer(cellTagGesture)
        if !cell.hasView {
            let numberingLabel = UILabel()
            let gameNum = (dataSource!.getNumOfData(date: getCurrentDate()) + 1) - indexPath.row
            numberingLabel.text = "\(gameNum)"
            numberingLabel.textAlignment = .center
            numberingLabel.textColor = .black
            numberingLabel.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            numberingLabel.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            numberingLabel.layer.borderWidth = 1
            var rect = CGRect(x: 0, y: 0, width: frame.maxX, height: tableView.rowHeight)
            (numberingLabel.frame, rect) = rect.divided(atDistance: frame.maxX / 10, from: .minXEdge)
            let view = ScoreFrameView()
            (view.frame, rect) = rect.divided(atDistance: 9 * frame.maxX / 10, from: .minXEdge)
            view.tag = gameNum
            view.dataSource = self
            cell.addSubview(view)
            cell.addSubview(numberingLabel)
        }
        return cell
    }
    
    // MARK: - UITapGesture handler
    @objc func rowSelected(sender: UITapGestureRecognizer) {
        let cell = sender.view as! CellView
        let row = cell.tag
        let date = getCurrentDate()
        if row == 0 {
            delegate!.addNewGame(date: date, index: dataSource!.getNumOfData(date: date) + 1)
        }
        else {
            delegate!.editGame(date: date, index: row)
        }
    }
    
}

// MARK: - UITableViewCell
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
