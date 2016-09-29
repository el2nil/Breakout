//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Danil Denshin on 14.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, GameViewDelegate, UITabBarControllerDelegate {
	
	var attempts: Int = 0 { didSet { attemptsView.attempts = attempts-1 } }
	var gameOver = true { didSet { gameOverLabel.isHidden = !gameOver } }

	@IBOutlet weak var scroreLabel: UILabel!
	@IBOutlet weak var gameOverLabel: UILabel!
	@IBOutlet weak var attemptsView: AttemptsView!
	@IBOutlet weak var gameView: GameView! {
		didSet {
			gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
			gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(GameView.movePaddle(_:))))
		}
	}
	
	func gameView(_ gameView: GameView, missedBall: BallView) {
		attempts -= 1
		if attempts <= 0 {
			gameOver = true
			gameView.animating = false
		}
	}
	
	fileprivate var score: Int = 0 { didSet { scroreLabel.text = String(score) } }
	
	func gameView(_ gameView: GameView, didHitBrick brick: BrickView) {
		score += 100
	}
	
	func tapAction() {
		if gameOver {
			showMenu()
		} else {
			gameView.pushBall()
		}
	}
	
	func gameViewCanContinueGame(_ gameView: GameView) -> Bool {
		return !gameOver
	}
	
	func gameView(_ gameView: GameView, win: Bool) {
	
		let alert = UIAlertController(title: nil, message: "Congratulations! You win!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { alertAction in self.newGame() } ))
		present(alert, animated: true, completion: nil)
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarController?.delegate = self
		gameView.delegate = self
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if let settings = viewController as? SettingsTableViewController {
			settings.gameView = gameView
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if gameView.isGamePaused() { showMenu() }
	}
	
	fileprivate func showMenu() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { alertAction in self.newGame()} ))
		if gameView.isGamePaused() && !gameOver {
			alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { alertACtion in self.continueGame() }))
		}
		
		present(alertController, animated: true, completion: nil)
	}
	
	func newGame() {
		attempts = 3
		score = 0
		gameOver = false
		gameView.newGame()
		gameView.animating = true
	}
	
	func continueGame() {
		gameView.animating = true
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		gameView.animating = false
	}


}
