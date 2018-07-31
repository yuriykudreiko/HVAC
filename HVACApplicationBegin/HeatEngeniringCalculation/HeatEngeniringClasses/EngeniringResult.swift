//
//  EngeniringCalculationResult.swift
//  HVACApplicationBegin
//
//  Created by User3 on 07.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import Foundation

struct EngeniringResult {
    
    var nameOfCalculation : String
    var normalizedWallResistance : Double
    var materialArray : [Material]
    var insulationMaterial : Material
    
    init(calculationName: String, thermalInsulationName: String, normalizedWallResistance: Double, materialArray: [Material], thermalInsulationConductivity: Double) {
        
        var sum = 1/8.7 + 1/23
        
        for layer in materialArray {
            sum += (layer.width / layer.thermalConductivity)
        }
        print("sum:\(sum)")

        let R = normalizedWallResistance
        print("R:\(normalizedWallResistance)")

        let λ = thermalInsulationConductivity
        print("λ:\(thermalInsulationConductivity)")
        
        let insulationWidth = (R - sum) * λ
        
        print("Width:\(insulationWidth)")
        
        self.nameOfCalculation = calculationName
        self.normalizedWallResistance = normalizedWallResistance
        self.materialArray = materialArray
        self.insulationMaterial = Material(name: thermalInsulationName, width: insulationWidth, thermalConductivity: thermalInsulationConductivity)
    }
}
