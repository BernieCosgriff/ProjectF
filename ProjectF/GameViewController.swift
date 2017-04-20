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
    
    init(model: GameModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    private var glkView: GLKView {
        return view as! GLKView
    }
    
    func update() {
        model.update(timeInterval: timeSinceLastUpdate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        model.player = Player()
        model.background = Background()
        let w = view.bounds.width
        
        controls = ShipControlSet(frame: CGRect(x: 0, y: view.bounds.height - w, width: w, height: w))
        controls.controlHandler = {
            [weak self] value in
            self?.model.setPlayerMovement(value: value)
        }
        view.addSubview(controls)
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.75, 0.75, 0.75, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        model.background?.draw()
        model.player?.draw()
        for bullet in model.playerBullets + model.enemyBullets {
            bullet.draw()
        }
        for enemy in model.enemies {
            enemy.draw()
        }
    }
}
