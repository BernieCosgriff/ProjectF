//
//  PlayerLife.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/21/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class PlayerLife: Sprite {
    
    init(position: (x: Float, y: Float)) {
        super.init(image: UIImage(named: "PlayerLife")!)
        self.position = position
        self.scale = (x: 0.1, y: 0.1)
    }
}
