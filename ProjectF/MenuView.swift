//
//  MenuView.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//
import UIKit

class MenuView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let background = UIImageView(image: UIImage(named: "Background1"))
//        background.frame = frame
//        addSubview(background)
//        sendSubview(toBack: background)
        backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
