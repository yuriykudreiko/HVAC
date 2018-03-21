//
//  HeatLossResult.swift
//  HVACApplicationBegin
//
//  Created by User3 on 17.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

//Q = A(tp − text)(1 + ∑β)n/Rт, (Ж.1)
//где
//А — расчетная площадь ограждающей конструкции, м2;
//Rт — сопротивление теплопередаче ограждающей конструкции, м2 · °С/Вт определяемое по СНБ 2.04.01 (кроме полов на грунте); для полов на грунте — в соответствии с Ж.3, принимая Rт = Rс — для неутепленных полов и Rт = Rh — для утепленных;
//tp — расчетная температура воздуха в помещении, °С, с учетом повышения ее в зависи- мости от высоты для помещений высотой более 4 м;
//text — расчетная температура наружного воздуха для холодного периода года при расчете потерь теплоты через наружные ограждающие конструкции или температура воздуха более холодного помещения — при расчете потерь теплоты через внутренние ограж- дающие конструкции, °C;
//β — добавочные потери теплоты в долях от основных потерь, определяемые в соответ- ствии с Ж.2;
//n — коэффициент, принимаемый по СНБ 2.04.01 в зависимости от положения наружной поверхности ограждающих конструкций по отношению к наружному воздуху.

import Foundation

class HeatLossResult {
    
    var constructionArray : [Construction] = []
    var indoorTemperature : Double
    var outdoorTemperature : Double
    var wallResistance : Double
    var windowResistance : Double
    var ceilingResistance : Double
    var flourResistance : Double
    
    
    private func additionalHeatLoss(orientation: String) -> Double {

        switch orientation {
            case "с", "в", "св", "сз": return 1.1
            case "юв", "з": return 1.05
            default: return 1
        }
    }
    
    private func constructionResistance(name: String) -> Double {

        switch name {
            case "Стена": return self.wallResistance
            case "Окно": return self.windowResistance
            case "Дверь": return self.windowResistance
            case "Пол": return self.flourResistance
            case "Покрытие": return self.ceilingResistance
            default:
                return 0
        }
    }
    
    func calculateConstructionWith(name: String, square: Double, orientation: String) -> Construction {
        
        let additionalHeaLoss = self.additionalHeatLoss(orientation: orientation)
        let constructionResistance = self.constructionResistance(name: name)
        
        let heatLoss = square * additionalHeaLoss * (self.indoorTemperature - self.outdoorTemperature) / constructionResistance
        
        //Q = A(tp − text)(1 + ∑β)n/Rт,
        
        let construction = Construction(name: name, square: square, orientation: orientation, heatLoss: heatLoss)
        
        return construction
    }
    
    
    init(indoorTemperature : Double, outdoorTemperature : Double, wallResistance : Double, windowResistance : Double, ceilingResistance : Double, flourResistance : Double) {
        
        self.indoorTemperature = indoorTemperature
        self.outdoorTemperature = outdoorTemperature
        self.wallResistance = wallResistance
        self.windowResistance = windowResistance
        self.ceilingResistance = ceilingResistance
        self.flourResistance = flourResistance
    }
}
