//
//  HeatLossTableViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 24.02.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class HeatLossTableViewController: UITableViewController, HeatLossCalculationViewControllerDelegate {

    // MARK: - Properties
    
    var myVC : HeatLossCalculationViewController?
    var heatLossArray : [HeatLossResult] = []
    var rememberingNumberOfRow : Int?
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLayerAction(sander:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Actions
    
    @objc private func addLayerAction(sander: UIBarButtonItem) {
        let vc = HeatLossCalculationViewController()
        vc.delegate = self
        vc.overwriteHeatLossResult = false
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heatLossArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HeatLossCell"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = heatLossArray[indexPath.row].calculationName
        
        var sum : Double = 0
        
        for item in heatLossArray[indexPath.row].constructionArray {
            sum += item.heatLoss
        }
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "\(sum) Вт"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.rememberingNumberOfRow = indexPath.row
        let vc = HeatLossCalculationViewController()
        vc.delegate = self
        vc.calculationResult = heatLossArray[indexPath.row]
        vc.overwriteHeatLossResult = true
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    // MARK: - AddNewConstructionViewControllerDelegate
    
    func addHeatLossCalculationWith(result: HeatLossResult, overwrite: Bool) {
        if overwrite {
            if let index = rememberingNumberOfRow {
                heatLossArray[index] = result
            }
        } else {
            heatLossArray.append(result)
        }
    }
}






