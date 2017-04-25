//
//  GameViewController.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import GLKit

class GameViewController: GLKViewController {
    
    var model: GameModel!
    var controls: ShipControlSet!
    
    private var glkView: GLKView {
        return view as! GLKView
    }
    
    func update() {
        model.update(timeInterval: timeSinceLastUpdate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sprite stuff
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        //Model stuff
        model = GameModel()
        
        let w = view.bounds.width
        controls = ShipControlSet(frame: CGRect(x: 0, y: view.bounds.height - w, width: w, height: w))
        controls.controlHandler = {
            [weak self] value in
            self?.model.setPlayerMovement(value: value)
        }
        view.addSubview(controls)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        model.draw()
    }
}
