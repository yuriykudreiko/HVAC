//
//  TabBarViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Properties

    var indexOfTabBarItem: Int = 0
    
    private let heatEngeniringTableViewController : UITableViewController = {
        let firstTab = HeatEngeniringTableViewController()
        let firstTabBarItem = UITabBarItem(title: "Утеплитель", image: #imageLiteral(resourceName: "heatEngeniring"), selectedImage: nil)
        firstTab.tabBarItem = firstTabBarItem
        return firstTab
    }()
    
    private let heatLossTableViewController : UITableViewController = {
        let secondTab = HeatLossTableViewController()
        let secondTabBarItem = UITabBarItem(title: "Теплопотери", image: #imageLiteral(resourceName: "heatLoss"), selectedImage: nil)
        secondTab.tabBarItem = secondTabBarItem
        return secondTab
    }()
    
    private let heatFloorViewController: UIViewController = {
        let thirdTab = HeatFloorCalculationViewController()
        let thirdTabBarItem = UITabBarItem(title: "Теплый пол", image: #imageLiteral(resourceName: "heatFloor"), selectedImage: nil)
        thirdTab.tabBarItem = thirdTabBarItem
        return thirdTab
    }()
    
    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Теплотехнический расчет"
        self.viewControllers = [heatEngeniringTableViewController, heatLossTableViewController, heatFloorViewController]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
    }

    // MARK: - Actions
    
    @objc private func addButton() {
       
        if  self.indexOfTabBarItem == 0 {
            let vc = EngeniringCalculationViewController()
            vc.delegate = heatEngeniringTableViewController as? EngeniringCalculationViewControllerDelegate
            vc.overwriteMainResult = false
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true) {
                print("EnginiringCalculationTableViewController create")
            }
        } else if self.indexOfTabBarItem == 1 {
            let vc = HeatLossCalculationViewController()
            vc.delegate = heatLossTableViewController as? HeatLossCalculationViewControllerDelegate
            vc.overwriteHeatLossResult = false
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true) {
                print("EngeniringViewController create")
            }
        }
    }

    // MARK: - UITabBarDelegate
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.indexOfTabBarItem = (tabBar.items?.index(of: item))!
        if  self.indexOfTabBarItem == 0 {
            self.navigationItem.title = "Теплотехнический расчет"
            if self.navigationItem.rightBarButtonItem == nil {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
            }
        } else if self.indexOfTabBarItem == 1 {
            self.navigationItem.title = "Расчет теплопотерь"
            if self.navigationItem.rightBarButtonItem == nil {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
            }
        } else if self.indexOfTabBarItem == 2 {
            self.navigationItem.title = "Расчет внутрипольного отопления"
            if self.navigationItem.rightBarButtonItem != nil {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}
