//
//  AppDelegate.swift
//  Yaddoey
//
//  Created by Khalid SH on 23/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do{
            let _ = try Realm()
        } catch {
            print("Error while trying install Realm!\n\(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

}

