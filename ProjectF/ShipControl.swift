//
//  ShipControl.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/14/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class ShipControl: UIControl {
    
    var position = 0
    
    init(frame: CGRect, position: Int) {
        super.init(frame: frame)
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: rect)
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        context.setFillColor(color.cgColor)
        context.drawPath(using: .fill)
    }
    
    func inside(x: CGFloat, y:CGFloat) -> Bool {
        let newx = x - bounds.midX
        let newy = y - bounds.midY
        let distance = sqrt((newx*newx) + (newy*newy))
        return distance <= bounds.width/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //TODO: Investigate multitouch
        let touch = touches.first!.location(in: self)
        if(inside(x: touch.x, y: touch.y)) {
            sendActions(for: .touchDown)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!.location(in: self)
        if(inside(x: touch.x, y: touch.y)) {
            sendActions(for: .touchDown)
        } else {
            sendActions(for: .touchCancel)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchCancel)
    }
}
