//
//  Material.swift
//  HVACApplicationBegin
//
//  Created by User3 on 06.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import Foundation

struct Material {
    
    var name : String
    var width : Double
    var thermalConductivity : Double
    
    init(name: String, width: Double, thermalConductivity: Double) {
        self.name = name
        self.width = width
        self.thermalConductivity = thermalConductivity
    }
}
