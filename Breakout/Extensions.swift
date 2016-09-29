//
//  Extensions.swift
//  Breakout
//
//  Created by Danil Denshin on 14.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

extension UIBezierPath {
	class func addLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat) -> UIBezierPath {
		let path = UIBezierPath()
		path.lineWidth = lineWidth
		path.move(to: from)
		path.addLine(to: to)
		return path
	}
}

extension CGRect {
	
	var mid: CGPoint {
		get {
			return CGPoint(x: midX, y: midY)
		}
		set {
			origin = CGPoint(x: newValue.x - width/2, y: newValue.y - height/2)
		}
	}
	var upperLeft: CGPoint { return CGPoint(x: minX, y: minY) }
	var lowerLeft: CGPoint { return CGPoint(x: minX, y: maxY) }
	var upperRight: CGPoint { return CGPoint(x: maxX, y: minY) }
	var lowerRight: CGPoint { return CGPoint(x: maxX, y: maxY) }
	init(center: CGPoint, size: CGSize) {
		let upperLeft = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
		self.init(origin: upperLeft, size: size)
	}
}

