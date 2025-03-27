//
//  TabBarViewController.swift
//  HVACApp
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
        
    private let heatEngeniringTableViewController: UINavigationController = {
        let viewController = HeatEngeniringTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: "Утеплитель", image: #imageLiteral(resourceName: "heatEngeniring"), selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }()
    
    private let heatLossTableViewController: UINavigationController = {
        let viewController = HeatLossTableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: "Теплопотери", image: #imageLiteral(resourceName: "heatLoss"), selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }()
    
    private let heatFloorViewController: UINavigationController = {
        let viewController = HeatFloorCalculationViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: "Теплый пол", image: #imageLiteral(resourceName: "heatFloor"), selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([heatEngeniringTableViewController, heatLossTableViewController, heatFloorViewController], animated: false)
    }
    
}
