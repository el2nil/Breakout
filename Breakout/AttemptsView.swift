//
//  AttemptsView.swift
//  Breakout
//
//  Created by Danil Denshin on 19.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class AttemptsView: UIView {
	
	var attempts: Int = 0 { didSet { setNeedsLayout() } }
	
	fileprivate let spacing: CGFloat = 5
	fileprivate var imageWidth: CGFloat { return min((bounds.width / CGFloat(max(attempts, 3))) - spacing, bounds.height) }

	
	fileprivate var images = [UIImageView]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
	}
	
	override func layoutSubviews() {
		
		if attempts >= 0 {
			
			for sub in images {
				sub.removeFromSuperview()
			}
			
			images.removeAll()
			
			for index in 0..<attempts {
				
				let imageCenter = CGPoint(x: CGFloat(index)*(imageWidth + spacing), y: bounds.midY)
				
				let imageFrame = CGRect(center: imageCenter, size: CGSize(width: imageWidth, height: imageWidth))
				let imageView = UIImageView(frame: imageFrame)
				imageView.image = UIImage(named: "Ball")
				imageView.contentMode = .scaleAspectFit
				addSubview(imageView)
				images.append(imageView)
				
				
			}
		}
	}
	
	
	
	
	
}
