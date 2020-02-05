//
//  NewGameController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol NewGameControllerDelegate {
    func saveScores(score: GameScore, date: CalendarData)
}

class NewGameController: NewGameViewDataSource, NewGameViewDelegate {
    var delegate: NewGameControllerDelegate?
    
    var newGameView: NewGameView
    var selectedDate: CalendarData
    var gameScore: GameScore
    var selectedFrame: Int = 0
    var turn: Int = 0
    var curFrame: Int = 0
    
    init(view: NewGameView, date: CalendarData) {
        newGameView = view
        selectedDate = date
        gameScore = GameScore()
        newGameView.dataSource = self
        newGameView.delegate = self
    }
    
    func getSelectedFrame() -> (frame: Int, turn: Int) {
        return (frame: selectedFrame, turn: turn)
    }
    
    func getDate() -> CalendarData {
        return selectedDate
    }
    
    func getNextAvailable(index: Int) -> Bool {
        return checkAvailability(index: index)
    }
    
    func getAvailableScores() -> [Bool] {
        var result = Array(repeating: true, count: 12)
        if turn > 0 && gameScore.getInput(index: selectedFrame - 1)! < 10 {
            for i in 10 - gameScore.getInput(index: selectedFrame - 1)! ..< 10 {
                result[i] = false
            }
        }
        return result
    }
    
    private func checkAvailability(index: Int) -> Bool {
        if selectedFrame == 0 && curFrame == 0 && gameScore.getInput(index: selectedFrame) == nil {
            return false
        }
        if index == 1 && (selectedFrame == 20 || selectedFrame > curFrame || (selectedFrame == 19 && gameScore.getInput(index: selectedFrame) != nil && gameScore.getInput(index: selectedFrame) != 11) || (selectedFrame == 19 && gameScore.getInput(index: selectedFrame - 1)! != 11)) {
            return false
        }
        
        if index == -1 && selectedFrame <= 0 {
            return false
        }
        return true
    }
    
    func setSelectedFrame(index: Int) {
        var moveTo = index
        
        if index == -1 && selectedFrame > 0 && gameScore.getInput(index: selectedFrame - 1) == nil {
            moveTo = -2
        }
        if index == 1 && selectedFrame < curFrame && gameScore.getInput(index: selectedFrame)! == 11 && turn == 0 && selectedFrame < 18 {
            moveTo = 2
        }
        if index == 1 && selectedFrame == 19 && !(gameScore.getInput(index: selectedFrame)! == 11 || gameScore.getInput(index: selectedFrame - 1) == 11) {
            moveTo = 0
        }
        moveFrameFocus(index: moveTo)
    }
    
    func setScore(score: Int) {
        gameScore.setInput(index: selectedFrame, score: score)
        var index = 1
        if turn == 0 && score == 11 && selectedFrame < 18 {
            if selectedFrame <= curFrame {
                gameScore.setInput(index: selectedFrame + 1, score: nil)
            }
            index = 2
        }
        if selectedFrame > curFrame {
            curFrame = selectedFrame
        }
        setSelectedFrame(index: index)
    }
    
    func getScores() -> GameScore {
        return gameScore
    }
    
    func saveScore() {
        delegate!.saveScores(score: gameScore, date: selectedDate)
    }
    
    func update() {
        newGameView.scoreFrameView.update()
    }
    
    private func highlightCurrentPos(prev: Int?, prevTurn: Int, cur: Int) {
        if let prev = prev {
            newGameView.scoreFrameView.frameViews[prev].scoreInputView.highlightBorder(turn: prevTurn, on: false)
        }
        newGameView.scoreFrameView.frameViews[cur / 2].scoreInputView.highlightBorder(turn: turn, on: true)
    }
    
    private func moveFrameFocus(index: Int) {
        if selectedFrame < 19 {
            selectedFrame += index
            turn = selectedFrame % 2
        }
        else {
            if selectedFrame < 20 {
                selectedFrame += index
                turn += index
            }
            else {
                selectedFrame += index
                if index == -1 {
                    turn = 1
                }
            }
        }
        
        if selectedFrame == 21 && turn == 2 {
            selectedFrame = 20
            highlightCurrentPos(prev: 9, prevTurn: 3, cur: 19)
        }
        else if selectedFrame == 19 && index == -1 && turn == 1 {
            highlightCurrentPos(prev: 9, prevTurn: 2, cur: 18)
        }
        else {
            if index == 2 {
                highlightCurrentPos(prev: (selectedFrame - index) / 2, prevTurn: 0, cur: (selectedFrame < 20) ? selectedFrame: 19)
            }
            else if index == -2 {
                highlightCurrentPos(prev: (selectedFrame + 1 - index) / 2, prevTurn: 0, cur: (selectedFrame < 20) ? selectedFrame: 19)
            }
            else {
                highlightCurrentPos(prev: (selectedFrame - index) / 2, prevTurn: (turn + 1) % 2, cur: (selectedFrame < 20) ? selectedFrame: 19)
            }
        }
        update()
    }
}
