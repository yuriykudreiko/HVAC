//
//  HeatFloorCalculation.swift
//  HVACApplicationBegin
//
//  Created by Yra on 03.09.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import Foundation

class HeatFloorCalculation {
    
    var pipeLength: Double?         //+
    var waterFlow: Double?          //+
    var heatFlow: Double?           //+
    var pipeDiameter: String?       //+
    var pressureDrop: Double?
    var maxFloorTemperature: Double?//+
    
    private func calculatePipeDiameterWith(manufacture: String, heatLoss: Double) -> (outsideDiameter: Double, insideDiameter: Double) {
        
        var currentDiameter: (Double, Double)?
        var pipesStandardSizes: [(Double, Double)] = []

        let Qt = heatLoss
        let c = 4.2
        let Δt = 10.0
        
        switch manufacture {
            case "Kan": pipesStandardSizes = [(0.014, 0.010), (0.016, 0.012), (0.018, 0.014), (0.020, 0.016), (0.025, 0.018)]
            case "Herz": pipesStandardSizes = [(0.014, 0.012), (0.016, 0.014), (0.018, 0.016), (0.020, 0.018)]
            case "Rehau": pipesStandardSizes = [(0.010, 0.0078), (0.014, 0.011), (0.017, 0.013), (0.020, 0.016), (0.025, 0.0204)]
            default: pipesStandardSizes = []
        }
        
        let V = 3.6 * Qt / (c * Δt * 1000)
        self.waterFlow = V 
        print("V: \(V) м3/ч")
        
        for pipe in pipesStandardSizes {
            let S = Double.pi * pow((pipe.1), 2) / 4
            let speed = V / S / 3600

            //print("speed: \(speed) м/с, pressureDrop: \(pressureDropPerMeter)")
            if speed < 0.25 {
                currentDiameter = pipesStandardSizes.first
                if let d = currentDiameter {
                    self.pressureDrop = calcilatePressureDropPerMeterWith(diameter: d.1, speed: speed)
                }
            }else if 0.25 <= speed && speed <= 0.7 {
                currentDiameter = pipe
                if let d = currentDiameter {
                    self.pressureDrop = calcilatePressureDropPerMeterWith(diameter: d.1, speed: speed)
                }
                break
            } else if speed > 0.7 {
                currentDiameter = pipesStandardSizes.last
                if let d = currentDiameter {
                    self.pressureDrop = calcilatePressureDropPerMeterWith(diameter: d.1, speed: speed)
                }
            }
        }
        return currentDiameter!
    }
    
    private func calcilatePressureDropPerMeterWith(diameter: Double, speed: Double) -> Double {
        
        var hydraulicFriction: Double?
        // 0,659 - 40
        let dynamicViscosity = 0.659 / 1000000 // 0.00000116 //0.659 / 1000000
        let Δэ  = 0.000007
        
        let Re = diameter * speed / dynamicViscosity
        let first = (10 * diameter / Δэ)
        let second = (500 * diameter / Δэ)
//        print("Re: \(Re), first: \(first), second: \(second)")

        switch Re {
        case 0..<2300:
            hydraulicFriction = 64 / Re
        case 2300..<4000:
            hydraulicFriction = 2.7 / pow(Re, 0.53)
        case 4000..<first:
            hydraulicFriction = 0.3164 / pow(Re, 0.25)
        case first..<second:
            hydraulicFriction = 0.11 * pow(Δэ / diameter + 68 / Re, 0.25)
        case let x where x > second : hydraulicFriction = 0
            hydraulicFriction = 0.11 * pow(Δэ / diameter, 0.25)
        default:
            hydraulicFriction = 0
        }

        let pressureDropPerMeter = ((hydraulicFriction! * pow(speed, 2.0)) / (2.0 * 9.81 * diameter)) * 100000
        return pressureDropPerMeter
    }

    private func calculateThermalResistanceOfAbovePipes(layer: String) -> Double {
        
        var firstLayerResistance: Double
        switch layer {
            case "Плитка": firstLayerResistance = 0.0057
            case "Мрамор": firstLayerResistance = 0.0057
            case "Ковер": firstLayerResistance = 0.017
            case "Паркет": firstLayerResistance = 0.038
            case "Ламинат": firstLayerResistance = 0.053
            default: firstLayerResistance = 0
        }
        let secondLayerResistance = 0.06 / 0.93
        return firstLayerResistance + secondLayerResistance
    }
    
    init(square: Double, heatLoss: Double, pipeManufacture: String, floorConstruction: String, waterTemperature: Double, distanceBetweenPipes: Double, indoorTemperature: Double) {

        let pipe = calculatePipeDiameterWith(manufacture: pipeManufacture, heatLoss: heatLoss)
        let diameterPrefix = pipe.0 * 1000
        let diameterSuffix = (pipe.0 - pipe.1) * 1000 / 2
        self.pipeDiameter = "\(diameterPrefix)x\(diameterSuffix)"
        
        let outsideDiameter = pipe.outsideDiameter
        let insideDiameter = pipe.insideDiameter
        
        let layersAbovePipesThermalResistance = calculateThermalResistanceOfAbovePipes(layer: floorConstruction)
        let layersBelowPipesThermalResistance = 1.06
        let pipeThermalConductivity = 0.35
        let pipeHeatTransfer = 400.0
        
        let averageWaterTemperature = (waterTemperature + (waterTemperature - 10)) / 2  //1)tср, оС
        let thermalResistanceAbovePipes = layersAbovePipesThermalResistance + 1 / 12     //2)Rвв, м2К/Вт
        let thermalResistanceBelowPipes = layersBelowPipesThermalResistance + 1 / 8.7    //3)Rнн, м2К/Вт
        let floorSurfaceAndThermalResistanceAngle =  atan((2 * (0.052 + outsideDiameter / 2)) / distanceBetweenPipes) //4) W, о
        let maxThermalResistance = layersAbovePipesThermalResistance / sin(floorSurfaceAndThermalResistanceAngle) //5) Rвmax, м2К/Вт
        let belowQ = (averageWaterTemperature - 18) * (thermalResistanceAbovePipes + (outsideDiameter - insideDiameter) / (2 * pipeThermalConductivity) + 1/pipeHeatTransfer)//qн
        let aboveQ = (averageWaterTemperature - indoorTemperature) * (thermalResistanceBelowPipes + (outsideDiameter - insideDiameter) / (2 * pipeThermalConductivity) + 1/pipeHeatTransfer)//qв
        let ratioOfHeatFluxes = belowQ / aboveQ // 6)a, qн/qв
        let pipeWallsThеhermalResistance = 1 / (Double.pi * pipeHeatTransfer * insideDiameter) + ((log(outsideDiameter / insideDiameter) / log(2.7182)) / (2 * Double.pi * pipeThermalConductivity)) //7) Rтр, м2К/Вт
        let currentAboveQ = (averageWaterTemperature - indoorTemperature) / (thermalResistanceAbovePipes + (distanceBetweenPipes * pipeWallsThеhermalResistance) / (1 - ratioOfHeatFluxes)) //8) qв
        let currentBelowQ = currentAboveQ * ratioOfHeatFluxes // 9) qн
        let totalHeatFlow = currentAboveQ + currentBelowQ // 10) qa
        let totalHeatFlowPerMeter = totalHeatFlow * distanceBetweenPipes // 11) ql
        let maxFloorTemperature = averageWaterTemperature - currentAboveQ * (layersAbovePipesThermalResistance + (distanceBetweenPipes * pipeWallsThеhermalResistance) / (1 - ratioOfHeatFluxes)) // 12)  tпmax, oC
        let minFloorTemperature = indoorTemperature + (maxFloorTemperature - indoorTemperature) * sin(floorSurfaceAndThermalResistanceAngle)// 13) tпmin, oC
        let averidgeFloorTemperature = (maxFloorTemperature + minFloorTemperature) / 2 // 14) tпср, oC
        
        self.maxFloorTemperature = averidgeFloorTemperature
        self.heatFlow = currentAboveQ * square
        self.pipeLength = square / distanceBetweenPipes
        
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
            "14)averidgeFloorTemperature: \(averidgeFloorTemperature)\n" +
            "15)heatFlow: \(heatFlow!)\n" +
            "16)pipeLength: \(pipeLength!)\n")
    }
}
