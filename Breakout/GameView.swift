//
//  GameView.swift
//  Breakout
//
//  Created by Danil Denshin on 14.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreMotion

protocol GameViewDelegate {
	func gameView(_ gameView: GameView, missedBall: BallView)
	func gameViewCanContinueGame(_ gameView: GameView) -> Bool
	func gameView(_ gameView: GameView, didHitBrick brick: BrickView)
	func gameView(_ gameView: GameView, win: Bool)
}

class GameView: UIView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
	
	// MARK: Properties
	
	
	let maxPushPower: CGFloat = 3
	let minPushPower: CGFloat = 0
	var pushPower: CGFloat = GameSettings.pushPower {
		didSet {
			GameSettings.pushPower = pushPower
		}
	}
	
	var delegate: GameViewDelegate?
	
	var paused: Bool = false
	
	var wallColor = UIColor.gray
	let wallThickness: CGFloat = 10
	var ballFrameSize: CGFloat { return bounds.size.height / 40 }
	
	var paddleWidth: CGFloat { return bounds.size.width / 4 }
	var paddleHeight: CGFloat { return bounds.size.height / 40 }
	fileprivate var lineOfPadlle: CGFloat { return bounds.maxY - bounds.size.height / 20 }
	
	// MARK: Delegate
	
	func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
		//		print("bounds: \(ballBehavior.collider.boundaryIdentifiers?.count ?? 0)")
		//		print("subviews: \(subviews.count)")
	}
	
	func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
		if gamePaused, let ball = ball, let ballVelociry = ballVelociry {
			ballBehavior.addVelocity(ball, velocity: ballVelociry)
			gamePaused = false
		}
	}
	
	func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
		if let identifier = identifier as? String {
			if let brick = bricks[identifier] {
				
				// delegate
				delegate?.gameView(self, didHitBrick: brick)
				
				let whiteBrick = BrickView(frame: brick.frame, color: UIColor.white)
				whiteBrick.alpha = 0
				UIView.animate(withDuration: 0.1,
				                           animations: {
											self.addSubview(whiteBrick)
											whiteBrick.alpha = 1
											whiteBrick.alpha = 0 },
				                           completion: {
											success in whiteBrick.removeFromSuperview() }
				)
				
				
				brick.hitPoints -= 1
				if brick.hitPoints <= 0  {
					
					UIView.transition(with: brick,
					                          duration: 0.3,
					                          options: [UIViewAnimationOptions.allowAnimatedContent],
					                          animations: {
												self.ballBehavior.removeBarrier(identifier)
												self.bricks[identifier] = nil
												brick.alpha = 0 },
					                          completion: { (success) in
												brick.removeFromSuperview()
												if self.bricks.count == 0 {
													self.delegate?.gameView(self, win: true)
													self.animating = false
												}
						}
					)
				}
			}
		}
	}
	
	
	// MARK: Gravity
	
	let maxGravityMagnitude: CGFloat = 5
	let minGravityMagnitude: CGFloat = 0
	
	var gravityMagnitude: CGFloat {
		get {
			return ballBehavior.gravityMagnitude
		}
		set {
			ballBehavior.gravityMagnitude = min(max(newValue, minGravityMagnitude), maxGravityMagnitude)
		}
	}
	
	var realGravity: Bool = GameSettings.realGravity {
		didSet {
			GameSettings.realGravity = realGravity
			updateGravity()
		}
	}
	
	fileprivate func updateGravity() {
		if gravityActive && realGravity {
			if MotionManager.sharedInstance.isAccelerometerAvailable && !MotionManager.sharedInstance.isAccelerometerActive {
				MotionManager.sharedInstance.accelerometerUpdateInterval = 0.1
				MotionManager.sharedInstance.startAccelerometerUpdates(to: OperationQueue.main) {
					[unowned self] data, error in
					if self.ballBehavior.dynamicAnimator != nil {
						if let dx = data?.acceleration.x, let dy = data?.acceleration.y {
							self.ballBehavior.gravity.gravityDirection = CGVector(dx: Double(self.gravityMagnitude) * dx, dy: -dy * Double(self.gravityMagnitude))
						}
						
					} else {
						MotionManager.sharedInstance.stopAccelerometerUpdates()
						self.ballBehavior.gravity.gravityDirection = CGVector(dx: 0, dy: self.gravityMagnitude)
					}
				}
			}
		} else {
			MotionManager.sharedInstance.stopAccelerometerUpdates()
			ballBehavior.gravity.gravityDirection = CGVector(dx: 0, dy: gravityActive ? gravityMagnitude : 0)
		}
	}
	
	func printMagnitude(_ magnitude: CGFloat) {
		let numb = NSNumber(value: Float(magnitude))
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.maximumIntegerDigits = 10
		let str = formatter.string(from: numb)
		print("magnitude: " + str!)
	}
	
	var gravityActive: Bool {
		set {
			ballBehavior.gravityActive = newValue
		}
		get {
			return ballBehavior.gravityActive
		}
	}
	
	// MARK: Animation
	
	fileprivate let motionManager = CMMotionManager()
	
	fileprivate lazy var ballBehavior: BallBehavior = {
		let ballBehavior = BallBehavior()
		ballBehavior.collisionDelegate = self
		ballBehavior.action = { [unowned self] in
			if let ball = self.ball  {
				if !self.point(inside: ball.frame.mid, with: nil) {
					self.addBall()
					self.resetPaddle()
					self.delegate?.gameView(self, missedBall: ball)
				}
			}
		}
		return ballBehavior
	}()
	
	fileprivate var ballVelociry: CGPoint?
	fileprivate var gamePaused: Bool = false {
		didSet {
			if let ball = ball {
				if gamePaused {
					ballVelociry = ballBehavior.currentVelocity(ball)
				} else {
					ballVelociry = nil
				}
			}
		}
	}
	
	func isGamePaused() -> Bool {
		return gamePaused
	}
	
	var animating: Bool = false {
		didSet {
			if animating {
				animator.addBehavior(ballBehavior)
				updateBoundaries()
				updateGravity()
			} else {
				gamePaused = true
				animator.removeBehavior(ballBehavior)
			}
		}
	}
	
	fileprivate var boundaries = [String: ColoredPath]() {
		didSet {
			setNeedsDisplay()
		}
	}
	
	fileprivate lazy var animator: UIDynamicAnimator = {
		let animator = UIDynamicAnimator(referenceView: self)
		animator.delegate = self
		return animator
	}()
	
	func pushBall() {
		
		if !(delegate?.gameViewCanContinueGame(self) ?? false) {
			return
		}
		
		if let ball = ball , ballBehavior.currentVelocity(ball) == CGPoint.zero {
			
			ballBehavior.addItem(ball)
			
			let angle = -M_PI/2
			let rand = Double(arc4random() % 10 + 1) * (-M_PI/1000) + M_PI/500
			
			let push = UIPushBehavior(items: [ball], mode: .instantaneous)
			push.setAngle(CGFloat(angle + rand), magnitude: pushPower)
			push.action = { [unowned push] in
				push.dynamicAnimator!.removeBehavior(push)
			}
			animator.addBehavior(push)
			
		}
		
	}
	
	// MARK: Bricks
	
	var firstBrickLine: CGFloat { return bounds.height / 5 }
	var bricks = [String: BrickView]()
	var brickSize: CGSize { return CGSize(width: 50, height: 15) }
	let lineSpacing: CGFloat = 2
	
	func addBricks() {
		
		for (name, brick) in bricks {
			brick.removeFromSuperview()
			bricks[name] = nil
		}
		
		let brickLines = [
			UIColor.blue,
			UIColor.blue,
			UIColor.yellow,
			UIColor.yellow,
			UIColor.green,
			UIColor.green,
			UIColor.red,
			UIColor.red
		]
		
		let numberOfBricksInLine = floor((bounds.width - wallThickness*2) / brickSize.width)
		
		let startX = wallThickness + (bounds.width - wallThickness*2 - brickSize.width * numberOfBricksInLine) / 2
		var brickPoint = CGPoint(x: startX, y: firstBrickLine)
		
		for color in brickLines {
			repeat {
				let brickFrame = CGRect(origin: brickPoint, size: brickSize)
				let brick = BrickView(frame: brickFrame, color: color)
				brick.hitPoints = (max(Int(arc4random() % 3), 1))
				bricks["brick_\(bricks.count + 1)"] = brick
				addSubview(brick)
				
				brickPoint.x += brickSize.width
			} while bricks.count % Int(numberOfBricksInLine) != 0
			
			brickPoint.x = startX
			brickPoint.y += brickSize.height + lineSpacing
			
		}
		for (name, brick) in bricks {
			ballBehavior.addBarrier(brick.boundary, named: name)
		}
	}
	
	// MARK: Walls
	
	fileprivate struct PathNames {
		static let LightedWall = "Lighted Wall"
		static let LeftWall = "Left Wall"
		static let UpperWall = "Upper Wall"
		static let RightWall = "Right Wall"
		static let Paddle = "BallCrusher"
	}
	
	fileprivate func offset(point: CGPoint, x: CGFloat, y: CGFloat) -> CGPoint {
		return CGPoint(x: point.x + x, y: point.y + y)
	}
	
	fileprivate func addThreeSideLine(rect: CGRect, lineWidth: CGFloat, lineOffset: CGFloat) -> UIBezierPath {
		let path = UIBezierPath()
		path.lineWidth = lineWidth
		
		path.move(to: offset(point: rect.lowerLeft, x: lineWidth/2 + lineOffset, y: 0))
		path.addLine(to: offset(point: rect.upperLeft, x: lineWidth/2 + lineOffset, y: 0 + lineOffset))
		
		path.move(to: offset(point: rect.upperLeft, x: 0 + lineOffset, y: lineWidth/2 + lineOffset))
		path.addLine(to: offset(point: rect.upperRight, x: 0 - lineOffset, y: lineWidth/2 + lineOffset))
		
		path.move(to: offset(point: rect.upperRight, x: -lineWidth/2 - lineOffset, y: 0 + lineOffset))
		path.addLine(to: offset(point: rect.lowerRight, x: -lineWidth/2 - lineOffset, y: 0))
		
		return path
	}
	
	fileprivate struct ColoredPath {
		var path: UIBezierPath
		var color: UIColor?
	}
	
	fileprivate var wallsExist = false
	
	func addWalls() {
		
		if !wallsExist {
			
			let leftWall = UIBezierPath.addLine(from: offset(point: bounds.lowerLeft, x: wallThickness/2, y: 0), to: offset(point: bounds.upperLeft, x: wallThickness/2, y: 0), lineWidth: wallThickness)
			let upperWall = UIBezierPath.addLine(from: offset(point: bounds.upperLeft, x: 0, y: wallThickness/2), to: offset(point: bounds.upperRight, x: 0, y: wallThickness/2), lineWidth: wallThickness)
			let rightWall = UIBezierPath.addLine(from: offset(point: bounds.upperRight, x: 0 - wallThickness/2, y: 0), to: offset(point: bounds.lowerRight, x: 0 - wallThickness/2, y: 0), lineWidth: wallThickness)
			let lightedWall = addThreeSideLine(rect: bounds, lineWidth: wallThickness/4, lineOffset: wallThickness/2)
			
			boundaries[PathNames.LeftWall] = ColoredPath(path: leftWall, color: wallColor)
			boundaries[PathNames.UpperWall] = ColoredPath(path: upperWall, color: wallColor)
			boundaries[PathNames.RightWall] = ColoredPath(path: rightWall, color: wallColor)
			boundaries[PathNames.LightedWall] = ColoredPath(path: lightedWall, color: UIColor(white: 0.8, alpha: 1))
			
			wallsExist = true
		}
	}
	
	// MARK: Paddle
	
	fileprivate var paddle: PaddleView?
	
	fileprivate var paddleCenter: CGPoint? {
		didSet {
			if paddleCenter != nil {
				if paddle == nil {
					let paddleSize = CGSize(width: paddleWidth, height: paddleHeight)
					paddle = PaddleView(frame: CGRect(center: paddleCenter!, size: paddleSize))
					addSubview(paddle!)
				}
				paddle!.frame.mid = paddleCenter!
				
				if let ball = ball , paddle!.point(inside: ball.convert(ball.bounds.mid, to: paddle!), with: nil) {
					ballBehavior.removeBarrier(PathNames.Paddle)
				} else {
					ballBehavior.addBarrier(paddle!.boundary, named: PathNames.Paddle)
				}
				
			} else {
				if let paddle = paddle {
					paddle.removeFromSuperview()
				}
				ballBehavior.removeBarrier(PathNames.Paddle)
			}
		}
	}
	
	func resetPaddle() {
		paddleCenter = CGPoint(x: bounds.midX, y: lineOfPadlle)
	}
	
	func removePaddle() {
		paddleCenter = nil
	}
	
	fileprivate var maxPaddleX: CGFloat { return bounds.maxX - paddleWidth/2 - wallThickness }
	fileprivate var minPaddleX: CGFloat { return bounds.minX + paddleWidth/2 + wallThickness }
	
	func movePaddle(_ recognizer: UIPanGestureRecognizer) {
		
		if !(delegate?.gameViewCanContinueGame(self) ?? false) {
			recognizer.setTranslation(CGPoint.zero, in: self)
			return
		}
		
		if paddleCenter != nil {
			switch recognizer.state {
			case .changed:
				
				let translation = recognizer.translation(in: self)
				paddleCenter = CGPoint(x: max(min(paddleCenter!.x + translation.x, maxPaddleX), minPaddleX), y: lineOfPadlle)
				
				// if ball not pushed
				if let ball = ball , ballBehavior.currentVelocity(ball) == CGPoint.zero {
					ball.center = CGPoint(x: paddleCenter!.x, y: ball.center.y)
				}
				
				recognizer.setTranslation(CGPoint.zero, in: self)
			default: break
			}
		}
		
	}
	
	// MARK: Ball
	
	fileprivate var ball: BallView?
	
	func addBall() {
		
		if ball != nil {
			ballBehavior.removeItem(ball!)
			ball!.removeFromSuperview()
		}
		
		let ballCenter = CGPoint(x: bounds.midX, y: lineOfPadlle - paddleHeight/2 - ballFrameSize/2)
		let ballFrame = CGRect(center: ballCenter, size: CGSize(width: ballFrameSize, height: ballFrameSize))
		ball = BallView(frame: ballFrame)
		if ball != nil {
			addSubview(ball!)
		}
	}
	
	// MARK: Lifecycle
	
	func newGame() {
		
		addBricks()
		addBall()
		resetPaddle()
		
	}
	
	fileprivate func updateBoundaries() {
		for (name, coloredPath) in boundaries {
			ballBehavior.addBarrier(coloredPath.path, named: name)
		}
		for (name, brick) in bricks {
			ballBehavior.addBarrier(brick.boundary, named: name)
		}
		if let paddle = paddle {
			ballBehavior.addBarrier(paddle.boundary, named: PathNames.Paddle)
		}
	}
	
	override func draw(_ rect: CGRect) {
		addWalls()
		for (name, coloredPath) in boundaries {
			if let color = coloredPath.color {
				color.set()
				coloredPath.path.stroke()
				coloredPath.path.fill()
			}
			ballBehavior.addBarrier(coloredPath.path, named: name)
		}
	}
	
	
	
}
