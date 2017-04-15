//
//  ShipControls.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/14/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class ShipControlSet: UIControl {
    
    private var top: ShipControl!
    private var left: ShipControl!
    private var middle: ShipControl!
    private var right: ShipControl!
    private var bottom: ShipControl!
    
    var controlHandler: ((_ value: value) -> Void)?
    
    enum value {
        case topStart
        case topStop
        case leftStart
        case leftStop
        case middleStart
        case middleStop
        case rightStart
        case rightStop
        case bottomStart
        case bottomStop
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let w = frame.size.width/3
        let h = frame.size.height/3
        top = ShipControl(frame: CGRect(x: w, y: 0, width: w, height: h), position: 0)
        top.addTarget(self, action: #selector(sendStart), for: .touchDown)
        top.addTarget(self, action: #selector(sendStop), for: .touchCancel)
        left = ShipControl(frame: CGRect(x: 0, y: h, width: w, height: h), position: 1)
        left.addTarget(self, action: #selector(sendStart), for: .touchDown)
        left.addTarget(self, action: #selector(sendStop), for: .touchCancel)
        middle = ShipControl(frame: CGRect(x: w, y: h, width: w, height: h), position: 2)
        middle.addTarget(self, action: #selector(sendStart), for: .touchDown)
        middle.addTarget(self, action: #selector(sendStop), for: .touchCancel)
        right = ShipControl(frame: CGRect(x: 2*w, y: h, width: w, height: h), position: 3)
        right.addTarget(self, action: #selector(sendStart), for: .touchDown)
        right.addTarget(self, action: #selector(sendStop), for: .touchCancel)
        bottom = ShipControl(frame: CGRect(x: w, y: 2*h, width: w, height: h), position: 4)
        bottom.addTarget(self, action: #selector(sendStart), for: .touchDown)
        bottom.addTarget(self, action: #selector(sendStop), for: .touchCancel)
        top.backgroundColor = UIColor.clear
        left.backgroundColor = UIColor.clear
        middle.backgroundColor = UIColor.clear
        right.backgroundColor = UIColor.clear
        bottom.backgroundColor = UIColor.clear
        
        addSubview(top)
        addSubview(left)
        addSubview(middle)
        addSubview(right)
        addSubview(bottom)
    }
    
    func sendStart(sender: ShipControl) {
        switch sender.position {
        case 0:
            controlHandler?(value.topStart)
        case 1:
            controlHandler?(value.leftStart)
        case 2:
            controlHandler?(value.middleStart)
        case 3:
            controlHandler?(value.rightStart)
        case 4:
            controlHandler?(value.bottomStart)
        default:
            break;
        }
    }
    
    func sendStop(sender: ShipControl) {
        switch sender.position {
        case 0:
            controlHandler?(value.topStop)
        case 1:
            controlHandler?(value.leftStop)
        case 2:
            controlHandler?(value.middleStop)
        case 3:
            controlHandler?(value.rightStop)
        case 4:
            controlHandler?(value.bottomStop)
        default:
            break;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
