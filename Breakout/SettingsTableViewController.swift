//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Danil Denshin on 20.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
	
	var gameView: GameView?
	
	let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 0
		return formatter
	}()
	
	@IBOutlet weak var minGravityMagnitudeLabel: UILabel!
	@IBOutlet weak var maxGravityMagnitudeLabel: UILabel!
	@IBOutlet weak var gravityMagnitudeSlider: UISlider!
	@IBAction func changeGravityMagnitude(_ sender: UISlider) {
		gameView?.gravityMagnitude = CGFloat(sender.value)
	}
	
	fileprivate var maxGravityMagnitude: CGFloat = 10 {
		didSet {
			if let gameView = gameView {
				maxGravityMagnitudeLabel.text = formatter.string(from: NSNumber(value: Float(gameView.maxGravityMagnitude)))
				gravityMagnitudeSlider.maximumValue = Float(gameView.maxGravityMagnitude)
			}
		}
	}
	fileprivate var minGravityMagnitude: CGFloat = 0 {
		didSet {
			if let gameView = gameView {
				minGravityMagnitudeLabel.text = formatter.string(from: NSNumber(value: Float(gameView.minGravityMagnitude)))
				gravityMagnitudeSlider.minimumValue = Float(gameView.minGravityMagnitude)
			}
		}
	}
	
	
	
	@IBOutlet weak var minPushPowerLabel: UILabel!
	@IBOutlet weak var maxPushPowerLabel: UILabel!
	@IBOutlet weak var pushPowerSlider: UISlider!
	
	@IBOutlet weak var typeOfGravity: UISegmentedControl!
	@IBAction func chooseTypeOfGravity(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: gameView?.realGravity = true
		case 1: gameView?.realGravity = false
		default: break
		}
		
	}
	
	private var realGravityOn: Bool = false {
		didSet {
			typeOfGravity.selectedSegmentIndex = realGravityOn ? 0 : 1
		}
	}
	
	@IBAction func pushPowerChanged(_ sender: UISlider) {
		gameView?.pushPower = CGFloat(sender.value)
	}
	
	fileprivate var maxPushPower: CGFloat = 10 {
		didSet {
			maxPushPowerLabel.text = formatter.string(from: NSNumber(value: Float(maxPushPower)))
			pushPowerSlider.maximumValue = Float(maxPushPower)
		}
	}
	
	fileprivate var minPushPower: CGFloat = 0 {
		didSet {
			minPushPowerLabel.text = formatter.string(from: NSNumber(value: Float(minPushPower)))
			pushPowerSlider.minimumValue = Float(minPushPower)
		}
	}
	
	
	@IBAction func gravityChanged(_ sender: UISwitch) {
		if let gameView = gameView {
			gameView.gravityActive = sender.isOn
			typeOfGravity.isEnabled = sender.isOn
			gravityMagnitudeSlider.isEnabled = sender.isOn
		}
	}
	@IBOutlet weak var gravitySwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let gameView = gameView {
			gravitySwitch.isOn = gameView.gravityActive
			typeOfGravity.isEnabled = gravitySwitch.isOn
			gravityMagnitudeSlider.isEnabled = gravitySwitch.isOn
			
			// push power
			minPushPower = gameView.minPushPower
			maxPushPower = gameView.maxPushPower
			pushPowerSlider.value = Float(gameView.pushPower)
			
			// real gravity
			realGravityOn = gameView.realGravity
			
			//gravity magnitude
			minGravityMagnitude = gameView.minGravityMagnitude
			maxGravityMagnitude = gameView.maxGravityMagnitude
			gravityMagnitudeSlider.value = Float(gameView.gravityMagnitude)
			
		}
	}
	
	// MARK: - Table view data source
	
	fileprivate struct Section {
		var name: String
		var numberOfRows: Int
	}
	
	fileprivate let sections: [Section] = [
		Section(name: "Gravity", numberOfRows: 3),
		Section(name: "Push Power", numberOfRows: 1)
	]
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].numberOfRows
		
	}
	
}
