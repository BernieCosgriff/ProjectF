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
    var menuView: MenuView!
    var pauseBtn: UIButton!
    var menuBtn: UIButton!
    var resumeGameBtn: UIButton!
    var highScoreBtn: UIButton!
    
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
        if model == nil {
            model = GameModel()
        }
        
        menuView = MenuView(frame: UIScreen.main.bounds)
        menuView.alpha = 0
        
        resumeGameBtn = UIButton(type: .custom)
        resumeGameBtn.frame = CGRect(x: view.bounds.midX - 100, y: view.bounds.height * 0.1, width: 200, height: 50)
        resumeGameBtn.setTitleColor(.green, for: .normal)
        resumeGameBtn.setTitle("Resume Game", for: .normal)
        resumeGameBtn.addTarget(self, action: #selector(resumeGame), for: .touchDown)
        menuView.addSubview(resumeGameBtn)
        
        highScoreBtn = UIButton(type: .custom)
        highScoreBtn.frame = CGRect(x: view.bounds.midX - 100, y: view.bounds.height * 0.3, width: 200, height: 50)
        highScoreBtn.setTitleColor(.green, for: .normal)
        highScoreBtn.setTitle("High Scores", for: .normal)
//        highScoreBtn.addTarget(self, action: #selector(resumeGame), for: .touchDown)
        menuView.addSubview(highScoreBtn)
        
        let w = view.bounds.width
        controls = ShipControlSet(frame: CGRect(x: 0, y: view.bounds.height - w, width: w, height: w))
        controls.controlHandler = {
            [weak self] value in
            self?.model.setPlayerMovement(value: value)
        }
        pauseBtn = UIButton(type: .custom)
        pauseBtn.frame = CGRect(x:10, y: view.bounds.height - 35, width: 70, height: 30)
        pauseBtn.setTitle("Resume", for: .normal)
        pauseBtn.addTarget(self, action: #selector(pause), for: .touchDown)
        pauseBtn.setTitleColor(.green, for: .normal)
        menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x:view.bounds.width - 55, y: view.bounds.height - 35, width: 50, height: 30)
        menuBtn.setTitle("Menu", for: .normal)
        menuBtn.addTarget(self, action: #selector(mainMenu), for: .touchDown)
        menuBtn.setTitleColor(.green, for: .normal)
        view.addSubview(controls)
        view.addSubview(pauseBtn)
        view.addSubview(menuBtn)
        view.addSubview(menuView)
    }
    
    func mainMenu() {
        isPaused = true
        UIView.animate(withDuration: 1, animations: {
            self.menuView.alpha = 1
            self.pauseBtn.alpha = 0
            self.menuBtn.alpha = 0
        }, completion: {
            finished in
            self.pauseBtn.setTitle("Pause", for: .normal)
        })
    }
    
    func pause(sender: UIButton) {
        if sender.title(for: .normal) == "Pause" {
            pauseBtn.setTitle("Resume", for: .normal)
        } else if sender.title(for: .normal) == "Resume" {
            pauseBtn.setTitle("Pause", for: .normal)
        }
        isPaused = !isPaused
    }
    
    func resumeGame() {
        UIView.animate(withDuration: 1, animations: {
            self.menuView.alpha = 0
            self.pauseBtn.alpha = 1
            self.menuBtn.alpha = 1
        }, completion: {
            finished in
            self.isPaused = false
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isPaused = true
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        model.draw()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        model.save()
    }
}
