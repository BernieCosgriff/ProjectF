//
//  MenuView.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//
import UIKit

class MenuView: UIView {
    var resumeGameBtn: UIButton!
    var highScoreBtn: UIButton!
    var resumeHandler: (() -> Void)?
    var newGameHandler: (() -> Void)?
    var highScoresHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resumeGameBtn = UIButton(type: .custom)
        resumeGameBtn.frame = CGRect(x: bounds.midX - 100, y: bounds.height * 0.1, width: 200, height: 50)
        resumeGameBtn.setTitleColor(.green, for: .normal)
        resumeGameBtn.setTitle("Start New Game", for: .normal)
        resumeGameBtn.addTarget(self, action: #selector(resumeGame), for: .touchDown)
        addSubview(resumeGameBtn)
        
        highScoreBtn = UIButton(type: .custom)
        highScoreBtn.frame = CGRect(x: bounds.midX - 100, y: bounds.height * 0.3, width: 200, height: 50)
        highScoreBtn.setTitleColor(.green, for: .normal)
        highScoreBtn.setTitle("High Scores", for: .normal)
        highScoreBtn.addTarget(self, action: #selector(highScores), for: .touchDown)
        addSubview(highScoreBtn)
        backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func resumeGame() {
        if resumeGameBtn.title(for: .normal) == "Resume Game" {
            resumeHandler?()
        } else {
            newGameHandler?()
        }
        
    }
    
    func highScores() {
        highScoresHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
