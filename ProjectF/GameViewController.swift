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
    var highScoresView: HighScoreView!
    var pauseBtn: UIButton!
    var menuBtn: UIButton!
    var gameOverLabel: UILabel!
    
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
            model.gameOverHandler = gameOver
        }
        
        highScoresView = HighScoreView(frame: UIScreen.main.bounds)
        highScoresView.menuHandler = mainMenu
        highScoresView.alpha = 0
        
        menuView = MenuView(frame: UIScreen.main.bounds)
        menuView.resumeHandler = resumeGame
        menuView.highScoresHandler = highScores
        menuView.newGameHandler = newGame
        menuView.alpha = 1
        
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
        
        gameOverLabel = UILabel(frame: CGRect(x: view.bounds.midX - 100, y: view.bounds.height * 0.3, width: 200, height: 50))
        gameOverLabel.text = "Game Over"
        gameOverLabel.textColor = .green
        gameOverLabel.textAlignment = .center
        gameOverLabel.alpha = 0
        
        view.addSubview(gameOverLabel)
        view.addSubview(controls)
        view.addSubview(pauseBtn)
        view.addSubview(menuBtn)
        view.addSubview(menuView)
        view.addSubview(highScoresView)
        
        pauseOnWillResignActive = false
        resumeOnDidBecomeActive = false
        
        mainMenu()
    }

    func gameOver() {
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0.5
            self.gameOverLabel.alpha = 1
            self.menuView.alpha = 0
            self.highScoresView.alpha = 0
            self.pauseBtn.alpha = 0
            self.menuBtn.alpha = 0
        }, completion: {
            finished in
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {
                _ in
                UIView.animate(withDuration: 1, animations: {
                    self.gameOverLabel.alpha = 0
                }, completion: {
                    finished in
                    self.getNameForHighScore()
                })
            })
        })
    }
    
    func getNameForHighScore() {
        if model.isHighScore() {
            let input = UIAlertController(title: "You got a High Score!", message: "Please enter your name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default, handler: {
                [weak input] (_) in
                self.model.setHighScores(name: input!.textFields![0].text!)
                self.view.alpha = 1
                self.highScores()
            })
            action.isEnabled = false
            input.addTextField(configurationHandler: {
                textField in
                textField.placeholder = "Name"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue(), using: {
                    notification in
                    action.isEnabled = textField.hasText
                })
            })
            input.addAction(action)
            present(input, animated: true, completion: nil)
        } else {
            highScores()
        }
    }

    func highScores() {
        model.save()
        if model.isGameOver {
            controls.isUserInteractionEnabled = false
        }
        highScoresView.scores = model.highScores
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 1
            self.menuView.alpha = 0
            self.highScoresView.alpha = 1
            self.pauseBtn.alpha = 0
            self.menuBtn.alpha = 0
        })
    }
    
    func newGame() {
        model.reset()
        model.save()
        UIView.animate(withDuration: 1, animations: {
            self.menuView.alpha = 0
            self.highScoresView.alpha = 0
            self.pauseBtn.alpha = 1
            self.menuBtn.alpha = 1
        }, completion: {
            finished in
            self.controls.isUserInteractionEnabled = true
            self.isPaused = false
        })
    }
    
    func mainMenu() {
        model.save()
        isPaused = true
        controls.isUserInteractionEnabled = false
        if model.isGameOver {
            menuView.resumeGameBtn.setTitle("Start New Game", for: .normal)
        } else {
            menuView.resumeGameBtn.setTitle("Resume Game", for: .normal)
        }
        UIView.animate(withDuration: 1, animations: {
            self.highScoresView.alpha = 0
            self.menuView.alpha = 1
            self.pauseBtn.alpha = 0
            self.menuBtn.alpha = 0
        }, completion: {
            finished in
            self.pauseBtn.setTitle("Pause", for: .normal)
        })
    }
    
    func pause(sender: UIButton) {
        model.save()
        if sender.title(for: .normal) == "Pause" {
            pauseBtn.setTitle("Resume", for: .normal)
            controls.isUserInteractionEnabled = false
        } else if sender.title(for: .normal) == "Resume" {
            pauseBtn.setTitle("Pause", for: .normal)
            controls.isUserInteractionEnabled = true
        }
        isPaused = !isPaused
    }
    
    func resumeGame() {
        UIView.animate(withDuration: 1, animations: {
            self.menuView.alpha = 0
            self.highScoresView.alpha = 0
            self.pauseBtn.alpha = 1
            self.menuBtn.alpha = 1
        }, completion: {
            finished in
            self.controls.isUserInteractionEnabled = true
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
