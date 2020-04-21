//
//  ProfileNameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/14/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol ProfileInfoViewDelegate {
    func openSearchRequestController()
    func openClubViewController(index: Int)
}

protocol ProfileInfoViewDataSource {
    func getProfileInfo() -> (String, ScoreOverallFormat?)
    func getNumOfClub() -> Int
    func getClubName(indexAt: Int) -> String
}

class ProfileInfoView: UIView, ProfileInfoDataSource {
    
    // MARK: - Properties
    var delegate: ProfileInfoViewDelegate?
    var dataSource: ProfileInfoViewDataSource?
    
    // MARK: - UI Properties
    lazy var profileInfo: ProfileInfo = {
        let view = ProfileInfo()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    lazy var joinedClubView: UITableView = {
        let view = UITableView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = .white
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (_, rect) = rect.divided(atDistance: bounds.maxX / 6, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxX / 6, from: .maxXEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxY / 12, from: .maxYEdge)
        (profileInfo.frame, rect) = rect.divided(atDistance: rect.height / 2, from: .minYEdge)
        (_, rect) = rect.divided(atDistance: bounds.maxY / 24, from: .minYEdge)
        (joinedClubView.frame, rect) = rect.divided(atDistance: rect.height, from: .minYEdge)
    }
    
    // MARK: - ProfileInfoDataSource Functions
    func getProfileInfo() -> (String, ScoreOverallFormat?) {
        return dataSource!.getProfileInfo()
    }
}

extension ProfileInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.getNumOfClub() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellView()
        cell.backgroundColor = .white
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        let cellTagGesture = UITapGestureRecognizer()
        cellTagGesture.addTarget(self, action: #selector(rowSelected))
        cell.addGestureRecognizer(cellTagGesture)
        let count = dataSource!.getNumOfClub()
        let label = PaddingLabel()
        if indexPath.row == count {
            label.text = "(+) add new Club"
        }
        else {
            label.text = dataSource!.getClubName(indexAt: indexPath.row)
        }
        label.frame = cell.frame
        label.textColor = .black
        label.textAlignment = .left
        // TODO: - add gesture
        cell.addSubview(label)
        return cell
    }
    
    @objc func rowSelected(sender: UITapGestureRecognizer) {
        let cell = sender.view as! CellView
        let row = cell.tag
        if row == dataSource!.getNumOfClub() {
            delegate!.openSearchRequestController()
        }
        else {
            delegate!.openClubViewController(index: row)
            print("joint club \(dataSource!.getClubName(indexAt: row))")
        }
    }
    
}
