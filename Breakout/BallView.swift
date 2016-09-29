//
//  BallView.swift
//  Breakout
//
//  Created by Danil Denshin on 16.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class BallView: UIView {
	
	let image = UIImage(named: "Ball")
	
	override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
		return UIDynamicItemCollisionBoundsType.ellipse
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let imageView = UIImageView(image: image)
		imageView.frame = CGRect(center: bounds.mid, size: bounds.size)
		imageView.contentMode = .scaleAspectFit
		backgroundColor = UIColor.clear
		addSubview(imageView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}


}
