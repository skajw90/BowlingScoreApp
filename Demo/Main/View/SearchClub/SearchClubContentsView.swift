//
//  SearchClubContentsView.swift
//  Demo
//
//  Created by Jiwon Nam on 2/26/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol SearchClubContentsViewDelegate {
    func requestSearchClubName(code: String)
    func removeSearchClubViewController()
}

class SearchClubContentsView: UIView {
    var delegate: SearchClubContentsViewDelegate?
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Enter Your Club Code"
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.backgroundColor = .white
        addSubview(textField)
        return textField
    } ()
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(searchActionHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelActionHandler), for: UIControl.Event.touchDown)
        addSubview(button)
        return button
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = bounds
        (messageLabel.frame, rect) = rect.divided(atDistance: bounds.maxY / 3, from: .minYEdge)
        textField.frame = CGRect(origin: CGPoint(x: bounds.maxX / 8, y: bounds.maxY / 3), size: CGSize(width: 3 * bounds.maxX / 4, height: bounds.maxX / 10))
        cancelButton.frame = CGRect(origin: CGPoint(x: bounds.maxX / 8, y: bounds.maxY / 3 + bounds.maxX / 6), size: CGSize(width: textField.frame.width / 3, height: textField.frame.height))
        searchButton.frame = CGRect(origin: CGPoint(x: 7 * bounds.maxX / 8 - cancelButton.frame.width, y: cancelButton.frame.minY), size: cancelButton.frame.size)
    }
    
    @objc func searchActionHandler(sender: UIButton) {
        if let text = textField.text {
            delegate!.requestSearchClubName(code: text)
        }
        else {
            // TODO: - Need error handler
            print("error: code not filled")
        }
    }
    
    @objc func cancelActionHandler(sender: UIButton) {
        delegate!.removeSearchClubViewController()
    }
}

extension SearchClubContentsView: UITextFieldDelegate {
    // MARK: - UITextfieldDelegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .lightGray
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            print(text)
            
        }
        else {
            textField.backgroundColor = .red
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
