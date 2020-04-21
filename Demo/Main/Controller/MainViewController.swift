//
//  ViewController.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuSetControllerDataSource, MenuSetControllerDelegate, MenuPreviewDelegate, CameraControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SearchClubViewControllerDelegate, ClubViewControllerDelegate {
    // MARK: - Properties
    let dispatchGroup = DispatchGroup()
    var menuSetController: MenuSetController?
    var userData: UserData = UserData(userID: "USER NAME", joinedClub: ["sample1", "sample2"])
    var userSetting = (0, 0 , IntervalFormat.year)
    var selectedDate: CalendarData = CalendarData()
    var overallScores: ScoreFormats = ScoreFormats()
    var selectedDetailScore: [GameScore] = []
    var contentsInMonth: [Bool] = []
    var today = CalendarData()
    var mainView: MainView { return view as! MainView }
    var imagePicker = UIImagePickerController()
    var profileImage = UIImage()
    
    // MARK: - Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        today.year = Calendar.current.component(.year, from: Date())
        today.month = Calendar.current.component(.month, from: Date())
        today.day = Calendar.current.component(.day, from: Date())
        today.weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: Date()))
        selectedDate.year = Calendar.current.component(.year, from: Date())
        selectedDate.month = Calendar.current.component(.month, from: Date())
        selectedDate.day = Calendar.current.component(.day, from: Date())
        selectedDate.weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: Date()))
        
        requestUserData()
        loadUserScore(date: selectedDate)
        loadProfileImage()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Load Data Methods
    func loadDailyScoreDetail(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode([GameScore].self, from: jsonData)
                selectedDetailScore = data
            } catch { print("error") }
        }
    }
    func loadOverallScores(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let jsonData = try Data(contentsOf: url)
                let data = try! JSONDecoder().decode(ScoreFormats.self, from: jsonData)
                overallScores = data
            } catch { print("error") }
        }
        else { overallScores = ScoreFormats() }
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
        } catch { print("error no files") }
        for i in 0 ..< 32 {
            if contentsDays.contains(i) { contentsInMonth.append(true) }
            else { contentsInMonth.append(false) }
        }
    }
    
    // MARK: - Save Data Methods
    func saveDailyScoreDetail(score: GameScore, url: URL, prevScore: inout GameScore?) {
        var changeAt: Int?
        for i in 0 ..< selectedDetailScore.count {
            if selectedDetailScore[i].gameID == score.gameID {
                changeAt = i
                prevScore = selectedDetailScore[i]
            }
        }
        if let index = changeAt { selectedDetailScore[index] = score }
        else { selectedDetailScore.append(score) }
        do {
            try selectedDetailScore.save(to: url)
        } catch { print("error save daily scores") }
        selectedDetailScore = []
    }
    func saveOverallScores(score: GameScore, url: URL, prevScore: GameScore?) {
        let scoreStat = score.getNumOfStat()
        var hasLeftPins = false
        for leftPin in score.leftPins {
            if leftPin != nil {
                hasLeftPins = true
            }
        }
        let dayInfo = ScoreOverallFormat(date: selectedDate, high: score.finalScore!, low: score.finalScore!, avg: Float(score.finalScore!), numOfGame: 1, details: [Details(score: score.finalScore!, strikeCount: scoreStat.strike, spareCount: scoreStat.spare, openCount: scoreStat.open, splitCount: scoreStat.split, splitMakeCount: scoreStat.splitMake, count: scoreStat.count, leftPins: hasLeftPins ? score.leftPins : nil)])
        if let prev = prevScore {
            let prevScoreStat = prev.getNumOfStat()
            var prevHasLeftPins = false
            for leftPin in score.leftPins {
                if leftPin != nil {
                    prevHasLeftPins = true
                }
            }
            let prevInfo = ScoreOverallFormat(date: selectedDate, high: prev.finalScore!, low: prev.finalScore!, avg: Float(prev.finalScore!), numOfGame: 1, details: [Details(score: prev.finalScore!, strikeCount: prevScoreStat.strike, spareCount: prevScoreStat.strike, openCount: prevScoreStat.open, splitCount: prevScoreStat.split, splitMakeCount: prevScoreStat.splitMake, count: prevScoreStat.count, leftPins: prevHasLeftPins ? prev.leftPins : nil)])
            overallScores.insert(newInfo: dayInfo, prevInfo: prevInfo, gameID: prevScore!.gameID - 1)
        }
        else {
            overallScores.add(newInfo: dayInfo)
        }
        do {
            try overallScores.save(to: url)
        } catch { print("error save daily scores") }
    }
    
    override func loadView() { view = MainView() }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.frame = view.frame
        NSLayoutConstraint.activate([
            mainView.menuPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.menuPreview.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.menuPreview.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.menuPreview.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            
            mainView.topMenuSetView.topAnchor.constraint(equalTo: mainView.menuPreview.bottomAnchor),
            mainView.topMenuSetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.topMenuSetView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.topMenuSetView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.07),
            
            mainView.contentsView.topAnchor.constraint(equalTo: mainView.topMenuSetView.bottomAnchor),
            mainView.contentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.contentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.contentsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            
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
    
    // MARK: - MenuSetControllerDataSource Functions
    func getUserID() -> String { return userData.userID }
    func getUserOverall() -> ScoreOverallFormat? {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        return overallData.getOverallInfo()
    }
    func getCurrentDate() -> CalendarData { return selectedDate }
    func getUserScore(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat {
        var from: CalendarData?
        var to: CalendarData = today
        if interval == .month { from = CalendarData(year: date.year!, month: date.month!, day: 1) }
        else if interval == .day {
            from = CalendarData(year: date.year!, month: date.month!, day: date.day!)
            to = CalendarData(year: date.year!, month: date.month!, day: date.day!)
        }
        else { from = CalendarData(year: date.year!, month: 1, day: 1) }
        let overallData = overallScores.getInfoByPeriod(from: from!, to: to)
        return overallData.getOverallInfo()
    }
    func getToday() -> CalendarData { return today }
    func getUserDetailScores(index: Int) -> GameScore { return selectedDetailScore[index - 1] }
    func getNumUserScoreData() -> Int { return selectedDetailScore.count }
    func hasContentsInMonth(date: CalendarData) -> [Bool] { return contentsInMonth }
    func getRecordScoreDatas() -> [(date: CalendarData?, num: Float?)?] {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        return overallScores.getRecordInfoByPeriod(from: from, to: today).toArray()
    }
    func getUserOverallAnalysis() -> StatFormat {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        return overallData.getOverallStats()
    }
    func getRecordInfo() -> (from: CalendarData, to: CalendarData, num: Int) {
        let from = CalendarData(year: today.year! - 1, month: 1, day: 1, weekday: nil)
        let overallData = overallScores.getInfoByPeriod(from: from, to: today)
        var firstDate = overallData.getFirstDateInData()
        if firstDate == nil { firstDate = today }
        return (from: firstDate!, to: today, num: overallData.getNumberOfGame())
    }
    func getScoreFormats(period: CategoryPeriod) -> (periods: [(from: CalendarData, to: CalendarData)], scores: [ScoreFormats]) {
        var prevDate = overallScores.getFirstDateInData()
        if prevDate == nil { prevDate = today }
        var isYear = false
        var addMonthBy = 0
        switch period {
        case .month1: addMonthBy = 1
        case .month3: addMonthBy = 3
        case .month6: addMonthBy = 6
        default: isYear = true
        }
        if isYear { prevDate!.month = 1 }
        if period != .month1 && prevDate!.month! % 3 != 1 {
            prevDate!.month = period == .month3 ? (prevDate!.month! / 3) * 3 + 1 : (prevDate!.month! / 6) * 6 + 1
        }
        prevDate!.day = 1
        var scoreResult: [ScoreFormats] = []
        var periodsResult: [(from: CalendarData, to: CalendarData)] = []
        while(prevDate!.compareTo(with: today) <= 0) {
            var nextDate = CalendarData(year: prevDate!.year, month: prevDate!.month)
            var tempPeriod = (from: CalendarData(), to: CalendarData())
            if isYear {
                nextDate.year! += 1
                nextDate.month = 0
                tempPeriod = (from: CalendarData(year: prevDate!.year), to: CalendarData(year: nextDate.year))
            }
            else {
                nextDate = prevDate!.add(month: addMonthBy)
                nextDate.day = 0
                tempPeriod = (from: CalendarData(year: prevDate!.year, month: prevDate!.month), to: CalendarData(year: nextDate.year, month: nextDate.month!))
            }
            let temp = overallScores.getInfoByPeriod(from: prevDate!, to: nextDate)
            if temp.getOverallInfo().high == nil {
                prevDate = nextDate
                continue
            }
            scoreResult.append(overallScores.getInfoByPeriod(from: prevDate!, to: nextDate))
            periodsResult.append(tempPeriod)
            prevDate = nextDate
        }
        return (periodsResult, scoreResult)
    }
    func getAnalysisOverallData(period: CategoryPeriod, frame: Int) -> Details {
        // within period from today to past
        // get scores
        var result = Details(score: 0, strikeCount: 0, spareCount: 0, openCount: 0, splitCount: 0, splitMakeCount: 0, count: 0, leftPins: [])
        let tempScores = getScoreInfoByCategoryPeriod(period: period)
        if frame == 0 { result = tempScores.getAllFrameStatusInfo() }
        else { result = tempScores.getFrameStatusInfo(frame: frame) }
        
        return result
    }
    
    func getAnalysisPinSets(period: CategoryPeriod, frame: Int) -> (pins: [PinStatInfo], num: Int) {
        let temp = getScoreInfoByCategoryPeriod(period: period)
        var result = (pins: [PinStatInfo(num: 0, spareCount: 0, PinSet: [])], num: 0)
        if frame == 0 { result = temp.getPinsOverallInfo() }
        else { result = temp.getPinsInfoBy(frame: frame) }
        return result
    }
    
    func getScoreInfoByCategoryPeriod(period: CategoryPeriod) -> ScoreFormats {
        var prevDate = today
        var minusMonthBy = 0
        var isYear = false
        switch period {
        case .month1:
            minusMonthBy = -1
        case .month3:
            minusMonthBy = -3
        case .month6:
            minusMonthBy = -6
        default:
            isYear = true
        }
        if isYear { prevDate.year! -= 1}
        prevDate = prevDate.add(month: minusMonthBy)
        let temp = overallScores.getInfoByPeriod(from: prevDate, to: today)
        return temp
    }
    
    func saveProfileImage() {
        let fileName = "profileImage.png"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = documentsDirectory.appendingPathComponent(fileName)
        guard let data = profileImage.jpegData(compressionQuality: 1) else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("save img error: \(error)")
        }
    }
    
    func loadProfileImage() {
        let fileName = "profileImage.png"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let image = UIImage(contentsOfFile: url.path) {
                profileImage = image
            }
        }
    }
    
    // MARK: - MenuSetControllerDelegate Functions
    func saveUserInfo(score: GameScore, date: CalendarData) {
        var month = "\(date.month!)"
        if date.month! < 10 { month = "0\(date.month!)" }
        var day = "\(date.day!)"
        if date.day! < 10 { day = "0\(date.day!)" }
        let fileName = "\(date.year!)\(month)\(day).json"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let overallUrl = documentsDirectory.appendingPathComponent("overall.json")
        let url = documentsDirectory.appendingPathComponent(fileName)
        print(documentsDirectory)
        var prevScore: GameScore?
        saveDailyScoreDetail(score: score, url: url, prevScore: &prevScore)
        saveOverallScores(score: score, url: overallUrl, prevScore: prevScore)
        menuSetController!.openScoreListView(date: date)
    }
    func setCurrentDate(date: CalendarData) {
        selectedDate = date
        loadUserScore(date: selectedDate)
    }
    func loadUserScore(date: CalendarData) {
        selectedDetailScore = []
        var month = "\(date.month!)"
        if date.month! < 10 { month = "0\(date.month!)" }
        var day = "\(date.day!)"
        if date.day! < 10 { day = "0\(date.day!)" }
        let fileName = "\(date.year!)\(month)\(day).json"
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = documentsDirectory.appendingPathComponent(fileName)
        let overallUrl = documentsDirectory.appendingPathComponent("overall.json")
        loadDailyScoreDetail(url: url)
        loadOverallScores(url: overallUrl)
        getContentsInMonth(year: date.year!, month: date.month!)
    }
    func openCamera() {
        let controller = VisionViewController()
        controller.delegate = self
        add(controller)
    }
    
    // MARK: - CameraControllerDelegate
    func cancelCamera(controller: CameraController) {
        controller.remove()
        menuSetController!.openProfile()
    }
    func saveData(data: [String]) { }
    
    // MARK: - MenuPreviewDelegate Functions
    func openMenu() {
    }
    
    func openPictureLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    func openSearchRequestController() {
        print("open")
        let searchController = SearchClubViewController()
        searchController.delegate = self
        add(searchController)
    }
    
    func openClubViewController(index: Int) {
        print("club name: \(userData.joinedClub[index])")
        // clear memory
        overallScores = ScoreFormats()
        let clubViewController = ClubViewController()
        clubViewController.clubName = userData.joinedClub[index]
        clubViewController.userName = userData.userID
        clubViewController.delegate = self
        add(clubViewController)
    }
    
    func getNumOfClub() -> Int {
        return userData.joinedClub.count
    }
    
    func getClubName(indexAt: Int) -> String {
        return userData.joinedClub[indexAt]
    }
    
    func getProfileImage() -> UIImage? {
        return profileImage
    }
    
    func exitClubView(_ controller: UIViewController) {
        controller.remove()
        loadUserScore(date: selectedDate)
        loadProfileImage()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage = image
            saveProfileImage()
            (menuSetController!.mainView.contentsView.curView as! ProfileView).setNeedsDisplay()
        }
    }
    
    // MARK: - SearchClubViewControllerDelegate Function
    func removeSearchClubViewController(_ controller: SearchClubViewController) {
        controller.remove()
    }
}


extension MainViewController {
    
    func requestUserData() {
        dispatchGroup.enter()
        let dataURL = URL(string: "\(serverURL)")!
        let session = URLSession.shared
        var request = URLRequest(url: dataURL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                print("error nil")
                return
            }
            guard let data = data else {
                print("data cannot convert")
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(UserData.self, from: data)
                self.userData = jsonData
                // save to local
                self.dispatchGroup.leave()
            } catch {
                print(error)
            }
        })
        task.resume()
    }
}
