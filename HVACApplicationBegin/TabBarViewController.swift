//
//  TabBarViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let heatEngeniringTableViewController : UITableViewController = {
        let firstTab = HeatEngeniringTableViewController()
        let firstTabBarItem = UITabBarItem(title: "Теплотехнический рассчет", image: nil, selectedImage: nil)
        firstTab.tabBarItem = firstTabBarItem
        return firstTab
    }()
    
    private let heatLossTableViewController : UITableViewController = {
        let secondTab = HeatLossTableViewController()
        let secondTabBarItem = UITabBarItem(title: "Рассчет теплопотерь", image: nil, selectedImage: nil)
        secondTab.tabBarItem = secondTabBarItem
        return secondTab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Теплотехнический рассчет"

        self.viewControllers = [heatEngeniringTableViewController, heatLossTableViewController]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @objc private func addButton() {
       
        if  self.tabBar.selectedItem?.title == "Теплотехнический рассчет" {

            let vc = EngeniringCalculationViewController()
            vc.delegate = heatEngeniringTableViewController as? EngeniringCalculationViewControllerDelegate
            vc.overwriteMainResult = false
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: {
                print("EnginiringCalculationTableViewController create")
            })
        } else if self.tabBar.selectedItem?.title == "Рассчет теплопотерь" {
            
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
        
        if  item.title == "Теплотехнический рассчет" {
            self.navigationItem.title = "Теплотехнический рассчет"
        } else if item.title == "Рассчет теплопотерь" {
            self.navigationItem.title = "Рассчет теплопотерь"
        }
    }
}
