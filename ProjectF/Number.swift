//
//  Number.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/22/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Number: Sprite {
    
    init(number: Int) {
        let image: UIImage!
        switch number {
        case 1:
            image = UIImage(named: "1")!
        case 2:
            image = UIImage(named: "2")!
        case 3:
            image = UIImage(named: "3")!
        case 4:
            image = UIImage(named: "4")!
        case 5:
            image = UIImage(named: "5")!
        case 6:
            image = UIImage(named: "6")!
        case 7:
            image = UIImage(named: "7")!
        case 8:
            image = UIImage(named: "8")!
        case 9:
            image = UIImage(named: "9")!
        default:
            image = UIImage(named: "0")!
        }
        super.init(image: image)
        self.position = position
        self.scale = (x: 0.1, y: 0.1)
    }
    
    func move() {
        position.x = position.x + velocity.x
        position.y = position.y + velocity.y
    }
}
