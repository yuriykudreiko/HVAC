//
//  MaterialModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import Foundation

struct MaterialModel: Decodable, Identifiable {
    let id: String
    let name: String
    let density: Int
    let thermalConductivity: ThermalConductivityModel
}
