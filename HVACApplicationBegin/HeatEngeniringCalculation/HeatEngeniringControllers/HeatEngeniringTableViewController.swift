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
    var rememberingNumberOfRow : Int?
    
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        let result = self.engeniringArray[indexPath.row]
        cell.textLabel?.text = result.nameOfCalculation
        let insulationWidth = Double(round(1000 * result.insulationMaterial.width)/1000)
        cell.detailTextLabel?.text = "\(insulationWidth)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        rememberingNumberOfRow = indexPath.row
        myVC?.calculationResult = engeniringArray[indexPath.row]
        myVC?.overwriteMainResult = true
        myVC?.delegate = self
        let navVC = UINavigationController(rootViewController: myVC!)
        present(navVC, animated: true) {
            print("EngeniringViewController opened")
        }
    }
    
    //MARK: - EngeniringCalculationViewControllerDelegate
    
    func addCalculation(result: EngeniringResult, overwrite: Bool) {
        if overwrite {
            engeniringArray[rememberingNumberOfRow!] = result
        } else {
            engeniringArray.append(result)
        }
    }
}
