//
//  HeatEngeniringTableViewController.swift
//  HVACApp
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class HeatEngeniringTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var engeniringArray: [EngeniringResult] = []
    var rememberingNumberOfRow: Int?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Теплотехнический расчет"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButton(_:))
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        dispatchPrecondition(condition: .onQueue(.global()))
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addButton(_ sender: UIBarButtonItem) {
        let viewController = EngeniringCalculationViewController()
        viewController.delegate = self
        viewController.overwriteMainResult = false
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension HeatEngeniringTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engeniringArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "heatEngeniringCell"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        let result = engeniringArray[indexPath.row]
        cell.textLabel?.text = result.nameOfCalculation
        let insulationWidth = Double(round(1000 * result.insulationMaterial.width) / 1000)
        cell.detailTextLabel?.text = "\(insulationWidth) мм"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension HeatEngeniringTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rememberingNumberOfRow = indexPath.row
        
        let viewController = EngeniringCalculationViewController()
        viewController.delegate = self
        viewController.calculationResult = engeniringArray[indexPath.row]
        viewController.overwriteMainResult = true
        viewController.delegate = self
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
}

//MARK: - EngeniringCalculationViewControllerDelegate

extension HeatEngeniringTableViewController: EngeniringCalculationViewControllerDelegate {
    
    func addCalculation(result: EngeniringResult, overwrite: Bool) {
        if overwrite {
            engeniringArray[rememberingNumberOfRow!] = result
        } else {
            engeniringArray.append(result)
        }
    }
    
}
