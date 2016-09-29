//
//  BallBehavior.swift
//  Breakout
//
//  Created by Danil Denshin on 14.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreMotion

class BallBehavior: UIDynamicBehavior {
	
	var gravityMagnitude: CGFloat = GameSettings.gravityMagnitude {
		didSet {
			GameSettings.gravityMagnitude = gravityMagnitude
			gravity.magnitude = gravityActive ? gravityMagnitude : 0
		}
	}
	
	var gravityActive: Bool = GameSettings.gravityActive {
		didSet {
			GameSettings.gravityActive = gravityActive
			if gravityActive {
				gravity.magnitude = gravityMagnitude
				gravity.angle = CGFloat(M_PI/2)
			} else {
				gravity.magnitude = 0
			}
			
		}
	}
	
	var collisionDelegate: UICollisionBehaviorDelegate? {
		set {
			collider.collisionDelegate = newValue
		}
		get {
			return collider.collisionDelegate
		}
	}
	
	let gravity: UIGravityBehavior = {
		let gravity = UIGravityBehavior()
		gravity.magnitude = GameSettings.gravityMagnitude
//		gravity.angle = CGFloat(M_PI/2)
		return gravity
	}()
	
	let collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
		return collider
	}()
	
	fileprivate let itemBehavior: UIDynamicItemBehavior = {
		let itemBehavior = UIDynamicItemBehavior()
		itemBehavior.allowsRotation = false
		itemBehavior.elasticity = 1
		itemBehavior.resistance = 0
		itemBehavior.friction = 0
		itemBehavior.density = 15
		return itemBehavior
	}()
	
	func addBarrier(_ path: UIBezierPath, named name: String) {
		collider.removeBoundary(withIdentifier: name as NSCopying)
		collider.addBoundary(withIdentifier: name as NSCopying, for: path)
	}
	
	func removeBarrier(_ name: String) {
		collider.removeBoundary(withIdentifier: name as NSCopying)
	}
	
	func currentVelocity(_ item: UIDynamicItem) -> CGPoint {
		return itemBehavior.linearVelocity(for: item)
	}
	
	func addVelocity(_ item: UIDynamicItem, velocity: CGPoint) {
		itemBehavior.addLinearVelocity(velocity, for: item)
	}
	
	override init() {
		super.init()
		
		addChildBehavior(collider)
		addChildBehavior(itemBehavior)
		addChildBehavior(gravity)
	}
	
	func addItem(_ item: UIDynamicItem) {
		collider.addItem(item)
		itemBehavior.addItem(item)
		gravity.addItem(item)
	}
	
	func removeItem(_ item: UIDynamicItem) {
		collider.removeItem(item)
		itemBehavior.removeItem(item)
		gravity.removeItem(item)
	}
	
}

class MotionManager: CMMotionManager {
	static let sharedInstance = MotionManager()
}
