//
//  HighScoreView.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/28/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class HighScoreView: UIView {
    
    var firstLabel: UILabel!
    var secondLabel: UILabel!
    var thirdLabel: UILabel!
    var menuBtn: UIButton!
    var privateScores = [0,0,0]
    var menuHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        firstLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.1, width: 200, height: 50))
        firstLabel.text = "First: \(scores[0])"
        firstLabel.textColor = .white
        firstLabel.textAlignment = .center
        addSubview(firstLabel)
        
        secondLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.3, width: 200, height: 50))
        secondLabel.text = "Second: \(scores[0])"
        secondLabel.textColor = .white
        secondLabel.textAlignment = .center
        addSubview(secondLabel)
        
        thirdLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.5, width: 200, height: 50))
        thirdLabel.text = "Third: \(scores[2])"
        thirdLabel.textColor = .white
        thirdLabel.textAlignment = .center
        addSubview(thirdLabel)
        
        menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: bounds.midX - 35, y: bounds.height * 0.7, width: 70, height: 25)
        menuBtn.setTitleColor(.green, for: .normal)
        menuBtn.setTitle("Menu", for: .normal)
        menuBtn.addTarget(self, action: #selector(mainMenu), for: .touchDown)
        addSubview(menuBtn)
        
        backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    var scores: [Int] {
        get {
            return privateScores
        }
        set {
            privateScores = newValue
            firstLabel.text = "First: \(privateScores[0])"
            secondLabel.text = "Second: \(privateScores[1])"
            thirdLabel.text = "Third: \(privateScores[2])"
        }
    }
    
    func mainMenu() {
        menuHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
