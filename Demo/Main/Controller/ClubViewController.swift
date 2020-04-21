//
//  ClubViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/26/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ClubViewControllerDelegate {
    func exitClubView(_ controller: UIViewController)
}

class ClubViewController: UIViewController, ClubViewDelegate, ClubViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CalendarControllerDelegate, CalendarControllerDataSource {
    
    var delegate: ClubViewControllerDelegate?
    var clubName: String = "CLUB NAME"
    var userName: String = "USER NAME"
    var isMaster: Bool = false
    var userOverallScores = ScoreFormats()
    var userSetting = (0, 0 , IntervalFormat.year)
    var selectedDate: CalendarData = CalendarData()
    var overallScores: ScoreFormats = ScoreFormats()
    var selectedDetailScore: [GameScore] = []
    var contentsInMonth: [Bool] = []
    var today = CalendarData()
    var imagePicker = UIImagePickerController()
    var profileImage = UIImage()
    var clubView: ClubView { return view as! ClubView }
    
    override func loadView() { view = ClubView() }
    
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
        // load scores from server
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubView.frame = view.frame
        NSLayoutConstraint.activate([
            clubView.clubNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clubView.clubNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clubView.clubNameLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            clubView.clubNameLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            
            clubView.exitClubButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clubView.exitClubButton.leftAnchor.constraint(equalTo: clubView.clubNameLabel.rightAnchor),
            clubView.exitClubButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            clubView.exitClubButton.heightAnchor.constraint(equalTo: clubView.clubNameLabel.heightAnchor),
            
            clubView.clubTopMenuView.topAnchor.constraint(equalTo: clubView.clubNameLabel.bottomAnchor),
            clubView.clubTopMenuView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clubView.clubTopMenuView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            clubView.clubTopMenuView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.07),
            
            clubView.contentsView.topAnchor.constraint(equalTo: clubView.clubTopMenuView.bottomAnchor),
            clubView.contentsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clubView.contentsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            clubView.contentsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        clubView.delegate = self
        clubView.dataSource = self
    }
    
    
    func getClubName() -> String {
        return clubName
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func isClubMaster() -> Bool {
        return isMaster
    }
    
    func openContentsView(with: String) {
        clubView.contentsView.switchViews(selectedType: with)
        if with == "Calendar" {
            let controller = CalendarController(view: clubView.contentsView.curView as! CalendarView)
            controller.delegate = self
            controller.dataSource = self
            getContentsInMonth(year: selectedDate.year!, month: selectedDate.month!)
        }
        print("\(with)")
    }
    
    func exitClubView() {
        delegate!.exitClubView(self)
    }
    
    func openEditGame(date: CalendarData) {
        // instead of edit game, open user's scores in club
        print("open club score at \(date.toString()!)!")
    }
    
    func setMonthlyScores(date: CalendarData) {
        // request server to gather all info within selected month
        print("get all overall at : \(date.toString()!)")
    }
    
    func getCurrentDate() -> CalendarData {
        return selectedDate
    }
    
    func getAverages(date: CalendarData, interval: IntervalFormat) -> ScoreOverallFormat {
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
    
    func hasContentsInMonth(date: CalendarData) -> [Bool] {
        return contentsInMonth
    }
    
    func getContentsInMonth(year: Int, month: Int) {
        contentsInMonth = []
        let contentsDays: [Int] = []
        do {
            // TODO: - Request server to gather user info
        } catch { print("error no Data") }
        for i in 0 ..< 32 {
            if contentsDays.contains(i) { contentsInMonth.append(true) }
            else { contentsInMonth.append(false) }
        }
    }
}
