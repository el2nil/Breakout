//
//  BrickView.swift
//  Breakout
//
//  Created by Danil Denshin on 18.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class BrickView: UIView {
	
	var color: UIColor
	var hitPoints: Int = 1
	var boundary: UIBezierPath { return UIBezierPath(roundedRect: frame, cornerRadius: 5) }
	
	init(frame: CGRect, color: UIColor) {
		self.color = color
		super.init(frame: frame)
//		backgroundColor = UIColor.whiteColor()
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.color = UIColor.white
		super.init(coder: aDecoder)
	}
	
	
	override func draw(_ rect: CGRect) {
		color.set()
		
		
		let path = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
		path.fill()
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.cornerRadius = 5
		
		gradientLayer.colors = [
			UIColor(white: 1, alpha: 0).cgColor,
			UIColor(white: 1, alpha: 0.3).cgColor,
			UIColor(white: 1, alpha: 0.7).cgColor,
			UIColor(white: 1, alpha: 0.3).cgColor,
			UIColor(white: 1, alpha: 0).cgColor]
		gradientLayer.locations = [0, 0.1, 0.3, 0.6, 0.7]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0, y: 0.7)
		gradientLayer.frame = CGRect(center: bounds.mid, size: CGSize(width: bounds.width - 2, height: bounds.height - 2))

		layer.insertSublayer(gradientLayer, at: 0)
	}
	

}
