//
//  SearchClubViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 2/26/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol SearchClubViewControllerDelegate {
    func removeSearchClubViewController(_ controller: SearchClubViewController)
}

class SearchClubViewController: UIViewController, SearchClubViewDelegate {
    var delegate: SearchClubViewControllerDelegate?
    
    var searchClubView: SearchClubView { return view as! SearchClubView }
    
    override func loadView() { view = SearchClubView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchClubView.frame = view.frame
        searchClubView.delegate = self
    }
    
    func requestSearchClubName(code: String) {
        // HTTP request to server to check code correct, and then get result
        // succeed to send request to host of club
        print("\(code)")
    }
    
    func removeSearchClubViewController() {
        delegate!.removeSearchClubViewController(self)
    }
}
