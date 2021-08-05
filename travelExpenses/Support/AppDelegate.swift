//
//  AppDelegate.swift
//  report
//
//  Created by osa on 21.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let tabBarController = UITabBarController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: TripsViewController()),
            UINavigationController(rootViewController: SettingsViewController())
        ]
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarController
        
        setupTabBar()

        return true
    }
    // MARK: -  TabBar
    private func setupTabBar() {
        let tabBarAppearance = UITabBarAppearance()

        // MARK: - Items
        let homeItem = UITabBarItem(
            title: "Поездки",
            image: UIImage(systemName:"house")?.withRenderingMode(.alwaysOriginal),
            tag: 1)
        
        let secondItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysOriginal),
            tag: 2)
        
        let items = [homeItem, secondItem]
        
        guard let viewControllers = tabBarController.viewControllers else { return }

        for index in 0...items.count - 1 {
            viewControllers[index].tabBarItem = items[index]
        }
        
        // MARK: - color
        tabBarAppearance.backgroundColor = UIColor(
            red: 0/255,
            green: 125/255,
            blue: 252/255,
            alpha: 0.8)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tabBarController.tabBar.standardAppearance = tabBarAppearance
    }
}

