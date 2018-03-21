//
//  HeatEngeniringTableViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class HeatEngeniringTableViewController: UITableViewController, EngeniringCalculationViewControllerDelegate {

    // MARK: - Properties
    
    var myVC : EngeniringCalculationViewController?
    var engeniringArray : [EngeniringResult] = []

    // MARK: - viewDidLoad

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myVC = EngeniringCalculationViewController()
        myVC?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engeniringArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "heatEngeniringCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        let result = self.engeniringArray[indexPath.row]
        cell.textLabel?.text = result.nameOfCalculation
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        myVC?.calculationResult = engeniringArray[indexPath.row]
        present(myVC!, animated: true) {
            print("EngeniringViewController opened")
        }
    }
    
    //MARK: - EngeniringCalculationViewControllerDelegate
    
    func addCalculation(result: EngeniringResult) {
        engeniringArray.append(result)
    }
}
