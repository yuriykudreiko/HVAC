//
//  HeatCalculationResultViewController.swift
//  HVACApplicationBegin
//
//  Created by Yra on 03.09.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class HeatFloorCalculationResultViewController: UIViewController, HeatFloorCalculationViewControllerDelegate {

    // MARK: - Properties

    // MARK: - Items

    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Рассчет внутрипольного отопления"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backAction))
    }
    
    // MARK: - Actions
    
    @objc func backAction() {
        dismiss(animated: true) {
            
        }
    }
    
    // MARK: - HeatFloorCalculationViewControllerDelegate
    
    func addHeatFloorCalculationWith(square: Double,
                                     pipeManufacturer: String,
                                     floorConstruction: String,
                                     waterTemperature: String,
                                     distanceBetweenPipes: Double,
                                     indoorTemperature: Double) {
        
        print("square: \(square)\n" +
            "pipeManufacturer: \(pipeManufacturer)\n" +
            "floorConstruction: \(floorConstruction)\n" +
            "waterTemperature: \(waterTemperature)\n" +
            "distanceBetweenPipes: \(distanceBetweenPipes)\n" +
            "indoorTemperature: \(indoorTemperature)")
        
        let hfc = HeatFloorCalculation(square: 10, pipeManufacture: "", floorConstruction: "", waterTemperature: 45, distanceBetweenPipes: 0.15, indoorTemperature: 20)
        
        
        
    }
}
