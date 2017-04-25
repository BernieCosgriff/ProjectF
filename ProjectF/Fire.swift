//
//  Fire.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/21/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Fire: Sprite {
    
    init(position: (x: Float, y: Float)) {
        super.init(image: UIImage(named: "Fire")!)
        self.scale = (x: 0.2,y: 0.15)
        self.position = position
    }
}
