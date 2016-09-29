//
//  PaddleView.swift
//  Breakout
//
//  Created by Danil Denshin on 16.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class PaddleView: UIView {
	
	var boundary: UIBezierPath {
		return UIBezierPath(ovalIn: frame)
	}

	override func draw(_ rect: CGRect) {
		
		UIColor.red.set()
		let paddlePath = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
		paddlePath.fill()
		
		UIColor.blue.set()
		UIBezierPath(rect: CGRect(center: bounds.mid, size: CGSize(width: bounds.width * 0.7, height: bounds.height))).fill()
		
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
