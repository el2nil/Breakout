//
//  SphereView.swift
//  Breakout
//
//  Created by Danil Denshin on 16.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class SphereView: UIView {

	override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .ellipse }
	
	override func draw(_ rect: CGRect) {
		let path = UIBezierPath(ovalIn: bounds)
		UIColor.red.set()
		path.fill()
	}

}
