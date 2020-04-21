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
    
    // MARK: - Properties
    var delegate: NewGameControllerDelegate?
    var newGameView: NewGameView
    var selectedDate: CalendarData
    var gameScore: GameScore
    var selectedFrame: Int = 0
    var turn: Int = 0
    var curFrame: Int = 0
    
    // MARK: - Initialize
    init(view: NewGameView, date: CalendarData, gameID: Int) {
        newGameView = view
        selectedDate = date
        gameScore = GameScore(gameID: gameID)
        newGameView.dataSource = self
        newGameView.delegate = self
    }

    // MARK: - NewGameViewDataSource Functions
    func getSelectedFrame() -> (frame: Int, turn: Int) { return (frame: selectedFrame, turn: turn) }
    func getDate() -> CalendarData { return selectedDate }
    func getNextAvailable(index: Int) -> Bool { return checkAvailability(index: index) }
    func getScores() -> GameScore { return gameScore }
    func getAvailableScores() -> [Bool] {
        var result = Array(repeating: true, count: 12)
        if turn > 0 && gameScore.getInput(index: selectedFrame - 1)! < 10 {
            for i in 10 - gameScore.getInput(index: selectedFrame - 1)! ..< 10 { result[i] = false }
        }
        return result
    }
    func getPinSet(frame: Int) -> [Int]? { return gameScore.leftPins[frame] }
    func isFirstPinInput() -> Bool {
        if selectedFrame > 18 {
            if selectedFrame == 19 && gameScore.input[18] == 11 { return true }
            else if selectedFrame == 20 && gameScore.input[19] == 11 { return true }
            else if selectedFrame == 20 && gameScore.input[18] == 11 && gameScore.input[19] != 11 { return false }
        }
        else if turn == 0 { return true }
        return false
    }
   
    // MARK: - NewGameViewDelegate Functions
    func setSelectedFrame(index: Int) {
        var moveTo = index
        if index == -1 && selectedFrame > 0 && gameScore.getInput(index: selectedFrame - 1) == nil { moveTo = -2 }
        if index == 1 && gameScore.getInput(index: selectedFrame)! == 11 && turn == 0 && selectedFrame < 18 && gameScore.getInput(index: selectedFrame + 1) == nil { moveTo = 2 }
        if index == 1 && selectedFrame == 19 && !(gameScore.getInput(index: selectedFrame)! == 11 || gameScore.getInput(index: selectedFrame - 1) == 11) { moveTo = 0 }
        if turn == 0 && index == -1 {
            setPrevPinsetTopView(index: selectedFrame)
        }
        moveFrameFocus(index: moveTo)
    }
    
    func setPrevPinsetTopView(index: Int) {
        if gameScore.leftPins[selectedFrame] != nil {
            if selectedFrame < 18 {
                let from = selectedFrame / 2 * 2 + 1
                if gameScore.leftPins[from] != nil {
                    newGameView.scoreInputPinsetTopView.pinsetPreview[selectedFrame / 2].updateWith(frame: from, isFirst: false)
                }
                else {
                    newGameView.scoreInputPinsetTopView.pinsetPreview[selectedFrame / 2].updateWith(frame: selectedFrame, isFirst: true)
                }
            }
            else {
                if gameScore.leftPins[20] != nil {
                    let isFirst = gameScore.getInput(index: 19) == 11 ? true : false
                    newGameView.scoreInputPinsetTopView.pinsetPreview[9].updateWith(frame: 20, isFirst: isFirst)
                }
                else if gameScore.leftPins[19] != nil {
                    let isFirst = gameScore.getInput(index: 18) == 11 ? true : false
                    newGameView.scoreInputPinsetTopView.pinsetPreview[9].updateWith(frame: 19, isFirst: isFirst)
                }
                else {
                    newGameView.scoreInputPinsetTopView.pinsetPreview[9].updateWith(frame: 18, isFirst: true)
                }
            }
        }
    }
    
    func moveFrameTo(index: Int) {
        if index * 2 > curFrame {
            return
        }
        setPrevPinsetTopView(index: index)
        moveFrameFocus(frame: index * 2)
        if gameScore.leftPins[index * 2] != nil {
            newGameView.scoreInputPinsetView.pinsetView.update()
            newGameView.scoreInputPinsetTopView.pinsetPreview[index].update()
        }
        else {
            newGameView.scoreInputPadView.setNeedsDisplay()
        }
    }
    func setScoreByPad(score: Int, isSplit: Bool) {
        gameScore.leftPins[selectedFrame] = nil
        if (turn == 0 && selectedFrame < 18) || selectedFrame == 19 {
            gameScore.leftPins[selectedFrame + 1] = nil
        }
        else if selectedFrame == 18 {
            gameScore.leftPins[19] = nil
            gameScore.leftPins[20] = nil
        }
        setScore(score: score, isSplit: isSplit)
    }
    func setPin(leftPin: Int?) {
        if turn == 1 && gameScore.leftPins[selectedFrame - 1] == nil {
            return
        }
        if gameScore.leftPins[selectedFrame] == nil {
            gameScore.leftPins[selectedFrame] = []
        }
        
        if let left = leftPin {
            if gameScore.leftPins[selectedFrame]!.contains(left) {
                gameScore.leftPins[selectedFrame] = gameScore.leftPins[selectedFrame]!.filter { $0 != left }
            }
            else { gameScore.leftPins[selectedFrame]!.append(left) }
        }
        
        if selectedFrame == 18 {
            gameScore.leftPins[19] = nil
            gameScore.leftPins[20] = nil
        }
        else if (turn == 0 && selectedFrame < 18) || selectedFrame == 19 { gameScore.leftPins[selectedFrame + 1] = nil }
        
        gameScore.leftPins[selectedFrame]!.sort()
        var leftPinStringForm = ""
        var isSplit = false
        for left in gameScore.leftPins[selectedFrame]! { leftPinStringForm += "\(left + 1)," }
        isSplit = SPLITCASES.contains(leftPinStringForm)
        var score = 0
        let leftPinCount = gameScore.leftPins[selectedFrame]!.count
        var isFirstShot = false
        if selectedFrame < 19 { isFirstShot = turn == 0 }
        else if selectedFrame == 19 { isFirstShot = gameScore.getInput(index: 18) == 11 }
        else { isFirstShot = gameScore.getInput(index: 19) == 11 }

        if isFirstShot { score = leftPinCount == 0 ? 11 : 10 - leftPinCount }
        else { score = leftPinCount == gameScore.leftPins[selectedFrame - 1]!.count ? 11 : leftPinCount }
        
        if isFirstShot && selectedFrame != 20 {
            gameScore.leftPins[selectedFrame + 1] = []
        }
        
        gameScore.setInput(index: selectedFrame, score: score, isSplit: isSplit)
        newGameView.scoreInputPinsetTopView.pinsetPreview[selectedFrame < 19 ? selectedFrame / 2 : 9].update()
        update()
    }
    func saveScore() { delegate!.saveScores(score: gameScore, date: selectedDate)}
    func moveToNext() {
        setPin(leftPin: nil)
        setPrevPinsetTopView(index: selectedFrame)
        setSelectedFrame(index: 1)
        if gameScore.leftPins[selectedFrame] == nil {
            gameScore.leftPins[selectedFrame] = []
        }
        if selectedFrame > curFrame {curFrame = selectedFrame }
        newGameView.scoreInputPinsetView.pinsetView.update()
    }

    // MARK: - Helper Methods
    private func setScore(score: Int, isSplit: Bool) {
       gameScore.setInput(index: selectedFrame, score: score, isSplit: isSplit)
       var index = 1
       if turn == 0 && score == 11 && selectedFrame < 18 {
           if selectedFrame <= curFrame { gameScore.setInput(index: selectedFrame + 1, score: nil, isSplit: isSplit) }
           index = 2
       }
       setSelectedFrame(index: index)
       if selectedFrame > curFrame { curFrame = selectedFrame }
    }
    private func checkAvailability(index: Int) -> Bool {
        if selectedFrame == 0 && curFrame == 0 && gameScore.getInput(index: selectedFrame) == nil { return false }
        if index == 1 && (gameScore.getInput(index: selectedFrame) == nil || selectedFrame == 20 || selectedFrame > curFrame || (selectedFrame == 19 && gameScore.getInput(index: selectedFrame) != nil && gameScore.getInput(index: selectedFrame) != 11)) { return false }
        if index == -1 && selectedFrame <= 0 { return false }
        return true
    }
    private func update() {
        newGameView.scoreFrameView.update()
        if selectedFrame < 20 {
            newGameView.scoreInputPinsetTopView.pinsetPreview[selectedFrame / 2].update()
        }
        else {
            var isFirst = false
            if gameScore.getInput(index: 19) == 11 {
                isFirst = true
            }
            newGameView.scoreInputPinsetTopView.pinsetPreview[9].updateWith(frame: 20, isFirst: isFirst)
        }
        
    }
    private func highlightCurrentPos(prev: Int?, prevTurn: Int, cur: Int) {
        if var prev = prev {
            if prev == 10 {
                prev = 9
            }
            newGameView.scoreFrameView.frameViews[prev].scoreInputView.highlightBorder(turn: prevTurn, on: false)
        }
        newGameView.scoreFrameView.frameViews[cur / 2].scoreInputView.highlightBorder(turn: turn, on: true)
    }
    private func moveFrameFocus(frame: Int) {
        let prev = selectedFrame
        let prevTurn = turn
        turn = 0
        selectedFrame = frame
        highlightCurrentPos(prev: prev / 2, prevTurn: prevTurn, cur: selectedFrame)
        update()
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
                if index == -1 { turn = 1 }
            }
        }
        if selectedFrame == 21 && turn == 2 {
            selectedFrame = 20
            highlightCurrentPos(prev: 9, prevTurn: 3, cur: 19)
        }
        else if selectedFrame == 19 && index == -1 && turn == 1 { highlightCurrentPos(prev: 9, prevTurn: 2, cur: 18) }
        else {
            if index == 2 { highlightCurrentPos(prev: (selectedFrame - index) / 2, prevTurn: 0, cur: (selectedFrame < 20) ? selectedFrame: 19) }
            else if index == -2 { highlightCurrentPos(prev: (selectedFrame + 1 - index) / 2, prevTurn: 0, cur: (selectedFrame < 20) ? selectedFrame: 19) }
            else { highlightCurrentPos(prev: (selectedFrame - index) / 2, prevTurn: (turn + 1) % 2, cur: (selectedFrame < 20) ? selectedFrame: 19) }
        }
        update()
    }
}
