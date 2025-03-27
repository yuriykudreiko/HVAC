//
//  TabBarViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    enum ScreenType: Int {
        case heatEngeniring
        case heatLoss
        case heatFloor
    }
    
    // MARK: - Properties
    
    var indexOfTabBarItem: Int = 0
    
    private let heatEngeniringTableViewController: UITableViewController = {
        let viewController = HeatEngeniringTableViewController()
        let tabBarItem = UITabBarItem(title: "Утеплитель", image: #imageLiteral(resourceName: "heatEngeniring"), selectedImage: nil)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    private let heatLossTableViewController: UITableViewController = {
        let viewController = HeatLossTableViewController()
        let tabBarItem = UITabBarItem(title: "Теплопотери", image: #imageLiteral(resourceName: "heatLoss"), selectedImage: nil)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    private let heatFloorViewController: UIViewController = {
        let viewController = HeatFloorCalculationViewController()
        let tabBarItem = UITabBarItem(title: "Теплый пол", image: #imageLiteral(resourceName: "heatFloor"), selectedImage: nil)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Теплотехнический расчет"
        viewControllers = [heatEngeniringTableViewController, heatLossTableViewController, heatFloorViewController]
        addRightBarButtonItem()
    }
    
    // MARK: - Actions
    @objc private func addButton(_ sender: UIBarButtonItem) {
        if indexOfTabBarItem == 0 {
            let vc = EngeniringCalculationViewController()
            vc.delegate = heatEngeniringTableViewController as? EngeniringCalculationViewControllerDelegate
            vc.overwriteMainResult = false
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true) {
                print("EnginiringCalculationTableViewController create")
            }
        } else if indexOfTabBarItem == 1 {
            let vc = HeatLossCalculationViewController()
            vc.delegate = heatLossTableViewController as? HeatLossCalculationViewControllerDelegate
            vc.overwriteHeatLossResult = false
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true) {
                print("EngeniringViewController create")
            }
        }
    }
}

// MARK: - Private

private extension TabBarViewController {
    func addRightBarButtonItem() {
        guard navigationItem.rightBarButtonItem == nil else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButton(_:))
        )
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              let type = ScreenType(rawValue: indexOfTabBarItem) else { return }
        
        indexOfTabBarItem = index
        
        switch type {
        case .heatEngeniring:
            navigationItem.title = "Теплотехнический расчет"
            addRightBarButtonItem()
        case .heatLoss:
            navigationItem.title = "Расчет теплопотерь"
            addRightBarButtonItem()
        case .heatFloor:
            navigationItem.title = "Расчет внутрипольного отопления"
            if navigationItem.rightBarButtonItem != nil {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
}
