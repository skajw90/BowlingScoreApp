//
//  WeekDay.swift
//  Demo
//
//  Created by Jiwon Nam on 1/21/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

enum WeekDay: Int, Codable {
    case Sun = 1, Mon, Tue, Wed, Thu, Fri, Sat
}
enum InputMode {
    case pad, pin
}
enum ContentsType {
    case profile, scorelist, newGame, camera, calendar, record, graph, analysis, setting
}

enum IntervalFormat {
    case day, month, year
}
