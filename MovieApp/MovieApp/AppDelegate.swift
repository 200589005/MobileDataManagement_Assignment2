//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Mitul Patel on 29/06/24.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        if !UserDefaults.standard.bool(forKey: "DBSavedFirstTime") {
            self.getAndSetupInitialDB()
            UserDefaults.standard.setValue(true, forKey: "DBSavedFirstTime")
            UserDefaults.standard.synchronize()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func getAndSetupInitialDB() {
        if let path = Bundle.main.path(forResource: "db_movies", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String:Any]] {
                            // do stuff
                    for item in jsonResult {
                        _ = MoviesEntity.createOrUpdateMovies(dictData: item, context: CoreDataStackManager.sharedInstance.managedObjectContext)
                    }
                  }
              } catch {
                   // handle error
              }
        }
    }

}

