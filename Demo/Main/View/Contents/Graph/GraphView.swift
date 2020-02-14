//
//  GraphView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/16/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class GraphView: UIView {
    lazy var drawGraphView: DrawGraphView = {
        let view = DrawGraphView()
        view.backgroundColor = .black
        addSubview(view)
        return view
    } ()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.backgroundColor = .white
        addSubview(view)
        return view
    } ()
    
    lazy var segmentControl: UISegmentedControl = {
        let items: [String] = ["All", "1month", "3month", "6month", "1year"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.layer.cornerRadius = 10
        control.backgroundColor = .lightGray
        control.tintColor = .white
        control.layer.borderColor = UIColor.black.cgColor
        control.layer.borderWidth = 1
        control.addTarget(self, action: #selector(changeTableViewList), for: .valueChanged)
        addSubview(control)
        return control
    } ()
    
    enum Category: Int {
        case score = 0, st_sp, numOfPlay
        
        func toString() -> String {
            switch self {
            case .score:
                return "Score"
            case .st_sp:
                return "ST/SP"
            default:
                return "Played"
            }
        }
    }
    
    lazy var categories: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 0 ..< 3 {
            let button = UIButton()
            button.setTitle("\(Category(rawValue: i)!)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 1
            button.tag = i
            button.addTarget(self, action: #selector(categorySelectHandler), for: UIControl.Event.touchDown)
            categories.append(button)
            addSubview(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @objc func changeTableViewList(sender: Any) {
        
    }
    
    @objc func categorySelectHandler(sender: UIButton) {
        for i in 0 ..< 3 {
            if sender.tag == i {
                categories[i].backgroundColor = .white
            }
            else {
                categories[i].backgroundColor = .lightGray
            }
        }
    }
    
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
    }
}


extension GraphView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "need to set header here data, game avg, h/g, l/g"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GraphTableCellView()
        cell.backgroundColor = .white
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 0.5
        // TODO: add view to show pins or add new game
        if indexPath.row != 0 {
            cell.dateLabel.text = "X월 20XX"
            cell.numOfGameLabel.text = "55"
            cell.highLabel.text = "220.2"
            cell.lowLabel.text = "\(4 - indexPath.row)"
        }
        
        return cell
    }
}

class GraphTableCellView: UITableViewCell {
    static let lock = NSLock()
    static var count = 0
       
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var numOfGameLabel: UILabel = {
        let label = UILabel()
        label.text = "Game"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.alpha = 0.7
        addSubview(label)
        return label
    } ()
    
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.text = "AVG"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .red
        label.alpha = 0.7
        addSubview(label)
        return label
    } ()
    
    lazy var highLabel: UILabel = {
        let label = UILabel()
        label.text = "H/G"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .green
        label.alpha = 0.7
        addSubview(label)
        return label
    } ()
    
    lazy var lowLabel: UILabel = {
        let label = UILabel()
        label.text = "L/G"
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .blue
        label.alpha = 0.7
        addSubview(label)
        return label
    } ()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        
        (dateLabel.frame, rect) = rect.divided(atDistance: 3 * frame.maxX / 7, from: .minXEdge)
        (numOfGameLabel.frame, rect) = rect.divided(atDistance: 1 * frame.maxX / 7, from: .minXEdge)
        (averageLabel.frame, rect) = rect.divided(atDistance: 1 * frame.maxX / 7, from: .minXEdge)
        (highLabel.frame, rect) = rect.divided(atDistance: 1 * frame.maxX / 7, from: .minXEdge)
        (lowLabel.frame, rect) = rect.divided(atDistance: 1 * frame.maxX / 7, from: .minXEdge)
    }
}
