//
//  NewGameController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class NewGameController: NewGameViewDataSource {
    var newGameView: NewGameView
    var selectedDate: CalendarData
    var selectedFrame: Int = 0
    
    init(view: NewGameView, date: CalendarData) {
        newGameView = view
        selectedDate = date
        newGameView.dataSource = self
    }
    
    func getSelectedFrame() -> Int {
        return selectedFrame
    }
    
    func getDate() -> CalendarData {
        return selectedDate
    }
}
