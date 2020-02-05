//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuSetControllerDataSource, MenuSetControllerDelegate, MenuPreviewDelegate {
    
    // add profile to initialize each controllers
    var menuSetController: MenuSetController?
    var userData: UserData = UserData(userID: "TEST", overall: nil, dataFiles: nil, joinedClub: nil)
    var userSetting = (0, 0 , IntervalFormat.year)
    var selectedDate: CalendarData = CalendarData()
    var monthlyData: ScoreFormat = ScoreFormat(numOfGame: 0)
    var selectedScores: ScoreFormat = ScoreFormat(numOfGame: 0)
    var contentsInMonth: [Bool] = []
    
    func loadUserInfo() {
        selectedDate.year = Calendar.current.component(.year, from: Date())
        selectedDate.month = Calendar.current.component(.month, from: Date())
        selectedDate.day = Calendar.current.component(.day, from: Date())
        selectedDate.weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: Date()))
        loadUserScore(date: selectedDate)
    }
    
    func loadUserScore(date: CalendarData) {
        var month = "\(date.month!)"
        if date.month! < 10 {
            month = "0\(date.month!)"
        }
        var day = "\(date.day!)"
        if date.day! < 10 {
            day = "0\(date.day!)"
        }
        let fileName = "\(date.year!)\(month)\(day).json"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let url = documentsDirectory.appendingPathComponent(fileName)
        let monthUrl = documentsDirectory.appendingPathComponent("monthly\(date.year!)\(month).json")
        loadDailyScores(url: url)
        loadMonthlyData(url: monthUrl)
        getContentsInMonth(year: date.year!, month: date.month!)
    }
    
    func getContentsInMonth(year: Int, month: Int) {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        contentsInMonth = []
        var contentsDays: [Int] = []
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for i in 0 ..< contents.count {
                let filename = String(contents[i].lastPathComponent)
                var monthString = "\(month)"
                if month < 10 {
                    monthString = "0\(month)"
                }
                let param = "\(year)\(monthString)"
                if filename.starts(with: param) {
                    let start = filename.index(filename.startIndex, offsetBy: 6)
                    let end = filename.index(filename.endIndex, offsetBy: -5)
                    let range = start ..< end
                    let result = filename[range]
                    let day = Int(result)
                    contentsDays.append(day!)
                }
            }
        } catch {
            print("error no files")
        }
        for i in 0 ..< 32 {
            if contentsDays.contains(i) {
                contentsInMonth.append(true)
            }
            else {
                contentsInMonth.append(false)
            }
        }
    }
    
    func loadDailyScores(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode(ScoreFormat.self, from: jsonData)
                selectedScores = data
            } catch {
                print("error")
            }
        }
        else {
            selectedScores = ScoreFormat(high: nil, low: nil, avg: nil, numOfGame: 0, scores: [])
        }
    }
    
    func loadMonthlyData(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode(ScoreFormat.self, from: jsonData)
                monthlyData = data
            } catch {
                print("error")
            }
        }
        else {
            monthlyData = ScoreFormat(high: nil, low: nil, avg: nil, numOfGame: 0, scores: [])
        }
    }
    
    func saveUserInfo(score: GameScore, date: CalendarData) {
        var month = "\(date.month!)"
        if date.month! < 10 {
            month = "0\(date.month!)"
        }
        var day = "\(date.day!)"
        if date.day! < 10 {
            day = "0\(date.day!)"
        }
        let fileName = "\(date.year!)\(month)\(day).json"
        
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let dailyUrl = documentsDirectory.appendingPathComponent(fileName)
        let monthlyUrl = documentsDirectory.appendingPathComponent("monthly\(date.year!)\(month).json")
        print(documentsDirectory)
        saveDailyScores(score: score, url: dailyUrl)
        saveMonthlyOverall(score: score.getOutput(index: 9).score!, url: monthlyUrl)
        menuSetController!.openScoreListView(date: date)
    }
    
    func saveDailyScores(score: GameScore, url: URL) {
        selectedScores.scores!.append(score)
        
        if let high = selectedScores.high {
            let recentValue = score.getOutput(index: 9).score!
            if high < recentValue {
                selectedScores.high = score.getOutput(index: 9).score!
            }
            if selectedScores.low! > recentValue {
                selectedScores.low = recentValue
            }
            selectedScores.avg = (selectedScores.avg! * selectedScores.numOfGame + recentValue) / (selectedScores.numOfGame + 1)
            selectedScores.numOfGame += 1
        }
        else {
            let recentValue = score.getOutput(index: 9).score!
            selectedScores.high = recentValue
            selectedScores.low = recentValue
            selectedScores.avg = recentValue
            selectedScores.numOfGame = 1
        }
        do {
            try selectedScores.save(to: url)
        } catch {
            print("error save daily scores")
        }
    }
    
    func saveMonthlyOverall(score: Int, url: URL) {
        if monthlyData.numOfGame == 0 {
            monthlyData.avg = score
            monthlyData.high = score
            monthlyData.low = score
        }
        else {
            monthlyData.avg = (monthlyData.avg! * monthlyData.numOfGame + score) / (monthlyData.numOfGame + 1)
            monthlyData.high = max(monthlyData.high!, score)
            monthlyData.low = min(monthlyData.low!, score)
        }
        monthlyData.numOfGame += 1
        
        do {
            try monthlyData.save(to: url)
        } catch {
            print("error save monthly overall")
        }
    }
    
    var mainView: MainView {
        return view as! MainView
    }

    override func loadView() {
        view = MainView()
        loadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.frame = view.frame
        
        NSLayoutConstraint.activate([
            mainView.menuPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.menuPreview.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.menuPreview.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.menuPreview.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.topMenuSetView.topAnchor.constraint(equalTo: mainView.menuPreview.bottomAnchor),
            mainView.topMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.topMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.topMenuSetView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08),
            
            mainView.contentsView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.contentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.contentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.contentsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.76),
            
            mainView.bottomMenuSetView.topAnchor.constraint(equalTo: mainView.contentsView.bottomAnchor),
            mainView.bottomMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.bottomMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomMenuSetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        menuSetController = MenuSetController(mainView: mainView)
        mainView.menuPreview.delegate = self
        menuSetController!.dataSource = self
        menuSetController!.delegate = self
        menuSetController!.openProfile()
    }
    
    // top Menu delegate functions
    func openMenu() {
    }
    
    func setCurrentDate(date: CalendarData) {
        selectedDate = date
        loadUserScore(date: selectedDate)
    }
    
    func getUserID() -> String {
        return userData.userID!
    }
    
    func getUserOverall() -> ScoreFormat? {
        return userData.overall
    }
    
    func getCurrentDate() -> CalendarData {
        return selectedDate
    }
    
    func getUserScore(date: CalendarData, interval: IntervalFormat) -> ScoreFormat {
        // TODO:: interval!
        if interval == .month {
            return monthlyData
        }
        else if interval == .day {
            return selectedScores
        }
        else {
            return selectedScores
        }
    }
    
    func hasContentsInMonth(date: CalendarData) -> [Bool] {
        return contentsInMonth
    }
    
    func getUserDetailScores(index: Int) -> GameScore {
        return selectedScores.scores![index - 1]
    }
    
    func getNumUserScoreData() -> Int {
        return selectedScores.scores!.count
    }
}

