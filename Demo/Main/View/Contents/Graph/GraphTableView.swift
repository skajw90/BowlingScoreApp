//
//  GraphTableView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/9/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class GraphTableView: UITableView {
}


extension GraphTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        
        return cell
    }
    
    
}
