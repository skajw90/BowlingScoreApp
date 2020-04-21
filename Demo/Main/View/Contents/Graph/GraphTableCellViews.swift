//
//  GraphTableCellViews.swift
//  Demo
//
//  Created by Jiwon Nam on 2/15/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class GraphTableViewComponentView: UIView {
     // MARK: - UI Properties
     lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
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
    
     // MARK: - UITableViewCell Override Functions
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

class GraphTableHeaderView: UITableViewHeaderFooterView {
    lazy var graphTableViewComponentView: GraphTableViewComponentView = {
        let view = GraphTableViewComponentView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphTableViewComponentView.frame = bounds
    }
}

// MARK: - Customed UITableViewCell
class GraphTableCellView: UITableViewCell {
    // MARK: - Properties
    lazy var graphTableViewComponentView: GraphTableViewComponentView = {
        let view = GraphTableViewComponentView()
        self.addSubview(view)
        return view
    } ()
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphTableViewComponentView.frame = bounds
    }
}
