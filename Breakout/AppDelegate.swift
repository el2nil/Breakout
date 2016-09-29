//
//  AppDelegate.swift
//  Breakout
//
//  Created by Danil Denshin on 14.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

class GameSettings {
	
	private static let defaults = UserDefaults.standard
	
	private struct Keys {
		static let GravityActive = "BreakoutGame.GravityActive"
		static let GravityMagnitude = "BreakoutGame.GravityMagnitude"
		static let PushPower = "BreakoutGame.PushPower"
		static let RealGravity = "BreakoutGame.RealGravity"
	}
	
	static var realGravity: Bool {
		set {
			defaults.set(newValue, forKey: Keys.RealGravity)
		}
		get {
			return (defaults.object(forKey: Keys.RealGravity) as? Bool) ?? false
		}
	}
	
	static var pushPower: CGFloat {
		set {
			defaults.set(newValue, forKey: Keys.PushPower)
		}
		get {
			return (defaults.object(forKey: Keys.PushPower) as? CGFloat) ?? 1
		}
	}
	
	static var gravityMagnitude: CGFloat {
		get {
			return (defaults.object(forKey: Keys.GravityMagnitude) as? CGFloat) ?? 0.5
		}
		set {
			defaults.set(newValue, forKey: Keys.GravityMagnitude)
		}
	}
	
	static var gravityActive: Bool {
		get {
			return (defaults.object(forKey: Keys.GravityActive) as? Bool) ?? false
		}
		set {
			defaults.set(newValue, forKey: Keys.GravityActive)
		}
	}
	
	
}

