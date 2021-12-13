//
//  AppDelegate.swift
//  Shopify Demo
//
//  Created by Intempt on 29/08/20.
//  Copyright © 2020 Intempt. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //  MARK: - Application Launch -
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //decideInitialViewController()
        
        /* ----------------------------------------
         ** Initialize the cart controller and pre-
         ** load any cached cart items.
         */
        UNUserNotificationCenter.current().delegate = PushManager.sharedInstance
        PushManager.sharedInstance.registerForPushNotifications()
        _ = CartController.shared
        
        //register a user for apple review
        var foundUser:UserModel?
        var allUsers = UserSession.getAllUsers()
        for item in allUsers{
            if item.email?.lowercased() == "raka@gmail.com"{
                foundUser = item
            }
        }
        if foundUser == nil{
            let user = UserModel()
            user.email = "raka@gmail.com"
            user.fname = "Jeeny"
            user.lname = "Raka"
            user.phone = "+1234234023"
            user.password = "123456"
            allUsers.append(user)
            UserSession.saveNewUser(user: allUsers)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushManager.sharedInstance.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    private func decideInitialViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

