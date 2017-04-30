//
//  GameOver.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/29/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class GameOverView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gameOverLabel = UILabel(frame: CGRect(x: bounds.midX - 100, y: bounds.height * 0.3, width: 200, height: 50))
        gameOverLabel.textAlignment = .center
        gameOverLabel.textColor = .red
        gameOverLabel.text = "Game Over"
        addSubview(gameOverLabel)
        backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
