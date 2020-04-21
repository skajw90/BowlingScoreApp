//
//  GraphView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol GraphViewDelegate {
    func setCategory(period: CategoryPeriod, type: Category)
}

protocol GraphViewDataSource {
    func getNumOfData() -> Int
    func getDataAtSC(index: Int) -> (date: (from: CalendarData, to: CalendarData), score: ScoreOverallFormat)
    func getDataAtST(index: Int) -> (date: (from: CalendarData, to: CalendarData), stat: StatFormat, numOfGame: Int)
    func getXValuesForGraph(period: CategoryPeriod, type: Category) -> [(from: CalendarData, to: CalendarData, data: Any?)]
}

class GraphView: UIView, DrawGraphViewDataSource {
    // MARK: - Properties
    var dataSource: GraphViewDataSource?
    var delegate: GraphViewDelegate?
    var numOfData: Int = 0
    var data: [ScoreOverallFormat] = []
    var pageContainerInitialHeight = CGFloat()
    var currentType: Category = .score
    var currentPeriod: CategoryPeriod = .month1
    
    // MARK: - UI Properties
    lazy var drawGraphView: DrawGraphView = {
        let view = DrawGraphView()
        view.backgroundColor = .black
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    lazy var segmentControl: UISegmentedControl = {
        let items: [String] = ["1month", "3month", "6month", "1year"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.layer.cornerRadius = 10
        control.backgroundColor = .lightGray
        control.tintColor = .white
        control.layer.borderColor = UIColor.black.cgColor
        control.layer.borderWidth = 1
        control.addTarget(self, action: #selector(segmentCategorySelectHandler), for: .valueChanged)
        addSubview(control)
        return control
    } ()
    lazy var categories: [UIButton] = []
    
    // MARK: - Initialize GraphView
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0 ..< 3 {
            let button = UIButton()
            button.setTitle("\(Category(rawValue: i)!)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = i == 0 ? .white : .lightGray
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 1
            button.tag = i
            button.addTarget(self, action: #selector(buttonCategorySelectHandler), for: UIControl.Event.touchDown)
            categories.append(button)
            addSubview(button)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: UIView Override Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (drawGraphView.frame, rect) = rect.divided(atDistance: 10 * frame.maxY / 20, from: .minYEdge)
        (tableView.frame, rect) = rect.divided(atDistance: 8 * frame.maxY / 20, from: .minYEdge)
        (segmentControl.frame, rect) = rect.divided(atDistance: frame.maxY / 20, from: .minYEdge)
        for i in 0 ..< 3 {
            (categories[i].frame, rect) = rect.divided(atDistance: frame.maxX / 3, from: .minXEdge)
        }
        tableView.rowHeight = tableView.bounds.maxY / 7
        tableView.sectionHeaderHeight = tableView.rowHeight
        pageContainerInitialHeight = tableView.bounds.maxY / 7
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        update()
    }
    
    // MARK: UIButton Action Handler Functions
    @objc func segmentCategorySelectHandler(sender: Any) {
        let seg = sender as! UISegmentedControl
        if currentPeriod != CategoryPeriod(rawValue: seg.selectedSegmentIndex)! {
           currentPeriod = CategoryPeriod(rawValue: seg.selectedSegmentIndex)!
            update()
        }
    }
    @objc func buttonCategorySelectHandler(sender: UIButton) {
        for i in 0 ..< 3 {
            if sender.tag == i { categories[i].backgroundColor = .white }
            else { categories[i].backgroundColor = .lightGray }
        }
        if currentType != Category(rawValue: sender.tag) {
            currentType = Category(rawValue: sender.tag)!
            update()
        }
    }
    
    // MARK: - DrawGraphViewDataSource Functions
    func getXValuesForGraph() -> [(from: CalendarData, to: CalendarData, data: Any?)] { return dataSource!.getXValuesForGraph(period: currentPeriod, type: currentType) }
    
    func getLabelText() -> (String, String, String) {
        if currentType == .score { return ("AVG", "H/G", "L/G") }
        else { return ("Strike", "Spare", "Open") }
    }
    func getSelectedSegment() -> Int { return segmentControl.selectedSegmentIndex }
    
    func update() {
        delegate!.setCategory(period: currentPeriod, type: currentType)
        numOfData = dataSource!.getNumOfData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.drawGraphView.setNeedsDisplay()
        }
    }
}

// MARK: GraphView UITableViewDataSource
extension GraphView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = GraphTableHeaderView()
        if currentType == .score {
            view.graphTableViewComponentView.averageLabel.text = "AVG"
            view.graphTableViewComponentView.highLabel.text = "H/G"
            view.graphTableViewComponentView.lowLabel.text = "L/G"
        }
        else {
            view.graphTableViewComponentView.averageLabel.text = "Strike"
            view.graphTableViewComponentView.highLabel.text = "Spare"
            view.graphTableViewComponentView.lowLabel.text = "Open"
            
        }
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return numOfData }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GraphTableCellView()
        cell.backgroundColor = .white
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 0.5
        cell.isUserInteractionEnabled = false
        var period: (from: CalendarData, to: CalendarData) = (from: CalendarData(), to: CalendarData())
        if currentType == .score {
            let data = dataSource!.getDataAtSC(index: indexPath.row)
            period = data.date
            cell.graphTableViewComponentView.numOfGameLabel.text = "\(data.score.numOfGame)"
            cell.graphTableViewComponentView.highLabel.text = "\(data.score.high!)"
            cell.graphTableViewComponentView.lowLabel.text = "\(data.score.low!)"
            cell.graphTableViewComponentView.averageLabel.text = "\(String(format: "%.1f", data.score.avg!))"
        }
        else {
            let data = dataSource!.getDataAtST(index: indexPath.row)
            period = data.date
            cell.graphTableViewComponentView.numOfGameLabel.text = "\(data.numOfGame)"
            cell.graphTableViewComponentView.highLabel.text = "\(String(format: "%.1f", Float(data.stat.spareCount) * 100 / Float(data.stat.num)))"
            cell.graphTableViewComponentView.lowLabel.text = "\(String(format: "%.1f", Float(data.stat.openCount) * 100 / Float(data.stat.num)))"
            cell.graphTableViewComponentView.averageLabel.text = "\(String(format: "%.1f", Float(data.stat.strikeCount) * 100 / Float(data.stat.num)))"
        }
        
        let from = period.from
        if segmentControl.selectedSegmentIndex == 0 || segmentControl.selectedSegmentIndex == 3 {
            cell.graphTableViewComponentView.dateLabel.text = "\(from.toString()!)"
        }
        else {
            var to = period.to
            to.month! -= 1
            if to.month == 0 {
                to.year! -= 1
                to.month = 12
            }
            cell.graphTableViewComponentView.dateLabel.text = "\(from.toString()!) ~ \(to.toString()!)"
        }
        cell.graphTableViewComponentView.dateLabel.backgroundColor?.withAlphaComponent(0.8)
        cell.graphTableViewComponentView.numOfGameLabel.backgroundColor?.withAlphaComponent(0.8)
        cell.graphTableViewComponentView.highLabel.backgroundColor?.withAlphaComponent(0.8)
        cell.graphTableViewComponentView.lowLabel.backgroundColor?.withAlphaComponent(0.8)
        cell.graphTableViewComponentView.averageLabel.backgroundColor?.withAlphaComponent(0.8)
        
        return cell
    }
}
