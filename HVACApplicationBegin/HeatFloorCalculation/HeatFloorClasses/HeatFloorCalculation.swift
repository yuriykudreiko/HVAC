//
//  HeatFloorCalculation.swift
//  HVACApplicationBegin
//
//  Created by Yra on 03.09.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import Foundation

class HeatFloorCalculation {
    
    var pipeLength: Double?
    var waterFlow: Double?
    var heatFlow: Double?
    var pipeDiameter: Double?
    var pressureDrop: Double?

    init(square: Double, pipeManufacture: String, floorConstruction: String, waterTemperature: Double, distanceBetweenPipes: Double, indoorTemperature: Double) {

        let averageWaterTemperature = (waterTemperature + (waterTemperature - 5)) / 2  //1)tср, оС
        let thermalResistanceAbovePipes = 0.19 + 1 / 12     //2)Rвв, м2К/Вт
        let thermalResistanceBelowPipes = 1.06 + 1 / 8.7    //3)Rнн, м2К/Вт
        let floorSurfaceAndThermalResistanceAngle =  atan((2 * (0.052 + 0.016 / 2)) / distanceBetweenPipes) //4) W, о
        let maxThermalResistance = 0.19 / sin(floorSurfaceAndThermalResistanceAngle) //5) Rвmax, м2К/Вт
        let belowQ = (averageWaterTemperature - 18)*(thermalResistanceAbovePipes + (0.016 - 0.013) / (2 * 0.35) + 1/400)//qн
        let aboveQ = (averageWaterTemperature - indoorTemperature)*(thermalResistanceBelowPipes + (0.016 - 0.013) / (2 * 0.35) + 1/400)//qв
        let ratioOfHeatFluxes = belowQ / aboveQ // 6)a, qн/qв
        let pipeWallsThеhermalResistance = 1 / (Double.pi * 400 * 0.013) + ((log(0.016/0.013) / log(2.7182)) / (2 * Double.pi * 0.35)) //7) Rтр, м2К/Вт
        let currentAboveQ = (averageWaterTemperature - indoorTemperature) / (thermalResistanceAbovePipes + (distanceBetweenPipes * pipeWallsThеhermalResistance) / (1 - ratioOfHeatFluxes)) //8) qв
        let currentBelowQ = currentAboveQ * ratioOfHeatFluxes // 9) qн
        let totalHeatFlow = currentAboveQ + currentBelowQ // 10) qa
        let totalHeatFlowPerMeter = totalHeatFlow * distanceBetweenPipes // 11) ql
        let maxFloorTemperature = averageWaterTemperature - currentAboveQ * (0.19 + (distanceBetweenPipes * pipeWallsThеhermalResistance) / (1 - ratioOfHeatFluxes)) // 12)  tпmax, oC
        let minFloorTemperature = indoorTemperature + (maxFloorTemperature - indoorTemperature) * sin(floorSurfaceAndThermalResistanceAngle)// 13) tпmin, oC
        let averidgeFloorTemperature = (maxFloorTemperature + minFloorTemperature) / 2 // 14) tпср, oC
        
        print("1)averageWaterTemperature: \(averageWaterTemperature)\n" +
            "2)thermalResistanceAbovePipes: \(thermalResistanceAbovePipes)\n" +
            "3)thermalResistanceBelowPipes: \(thermalResistanceBelowPipes)\n" +
            "4)waterTefloorSurfaceAndThermalResistanceAngle: \(floorSurfaceAndThermalResistanceAngle)\n" +
            "5)maxThermalResistance: \(maxThermalResistance)\n" +
            "6)ratioOfHeatFluxes: \(ratioOfHeatFluxes)\n" +
            "7)pipeWallsThеhermalResistance: \(pipeWallsThеhermalResistance)\n" +
            "8)currentAboveQ: \(currentAboveQ)\n" +
            "9)currentBelowQ: \(currentBelowQ)\n" +
            "10)totalHeatFlow: \(totalHeatFlow)\n" +
            "11)totalHeatFlowPerMeter: \(totalHeatFlowPerMeter)\n" +
            "12)maxFloorTemperature: \(maxFloorTemperature)\n" +
            "13)minFloorTemperature: \(minFloorTemperature)\n" +
            "14)averidgeFloorTemperature: \(averidgeFloorTemperature)")




        



    }

    
}
