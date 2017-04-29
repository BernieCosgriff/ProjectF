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
    var fourthLabel: UILabel!
    var fifthLabel: UILabel!
    var menuBtn: UIButton!
    var privateScores: [(name: String, score: Int)] = [(name: "", score: 0),(name: "", score: 0),(name: "", score: 0)]
    var menuHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        firstLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.1, width: 200, height: 50))
        firstLabel.text = "No Score Yet!"
        firstLabel.textColor = .white
        firstLabel.textAlignment = .center
        addSubview(firstLabel)
        
        secondLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.2, width: 200, height: 50))
        secondLabel.text = "No Score Yet!"
        secondLabel.textColor = .white
        secondLabel.textAlignment = .center
        addSubview(secondLabel)
        
        thirdLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.3, width: 200, height: 50))
        thirdLabel.text = "No Score Yet!"
        thirdLabel.textColor = .white
        thirdLabel.textAlignment = .center
        addSubview(thirdLabel)
        
        fourthLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.4, width: 200, height: 50))
        fourthLabel.text = "No Score Yet!"
        fourthLabel.textColor = .white
        fourthLabel.textAlignment = .center
        addSubview(fourthLabel)
        
        fifthLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.5, width: 200, height: 50))
        fifthLabel.text = "No Score Yet!"
        fifthLabel.textColor = .white
        fifthLabel.textAlignment = .center
        addSubview(fifthLabel)
        
        menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: bounds.midX - 35, y: bounds.height * 0.6, width: 70, height: 25)
        menuBtn.setTitleColor(.green, for: .normal)
        menuBtn.setTitle("Menu", for: .normal)
        menuBtn.addTarget(self, action: #selector(mainMenu), for: .touchDown)
        addSubview(menuBtn)
        
        backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    var scores: [(name:String, score: Int)] {
        get {
            return privateScores
        }
        set {
            privateScores = newValue
            if privateScores[0].name != "" {
                firstLabel.text = "\(privateScores[0].name): \(privateScores[0].score)"
            } else {
                firstLabel.text = "No Score Yet!"
            }
            if privateScores[1].name != "" {
                secondLabel.text = "\(privateScores[1].name): \(privateScores[1].score)"
            } else {
                secondLabel.text = "No Score Yet!"
            }
            if privateScores[2].name != "" {
                thirdLabel.text = "\(privateScores[2].name): \(privateScores[2].score)"
            } else {
                thirdLabel.text = "No Score Yet!"
            }
            if privateScores[3].name != "" {
                fourthLabel.text = "\(privateScores[3].name): \(privateScores[3].score)"
            } else {
                fourthLabel.text = "No Score Yet!"
            }
            if privateScores[4].name != "" {
                fifthLabel.text = "\(privateScores[4].name): \(privateScores[4].score)"
            } else {
                fifthLabel.text = "No Score Yet!"
            }
        }
    }
    
    func mainMenu() {
        menuHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
