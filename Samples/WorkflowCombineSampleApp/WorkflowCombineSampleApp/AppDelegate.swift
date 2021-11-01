//
//  AppDelegate.swift
//  WorkflowCombineSampleApp
//
//  Created by Soo Rin Park on 10/28/21.
//

import UIKit
import WorkflowUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ContainerViewController(workflow: DemoWorkflow())
        window?.makeKeyAndVisible()

        return true
    }
}
