//
//  AppDelegate.swift
//  TestAssessment
//
//  Created by sandhya ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let listViewController = ListTableViewController()
    let navigationController = UINavigationController.init(rootViewController: listViewController)
    self.window?.rootViewController = navigationController
    return true
  }
}
