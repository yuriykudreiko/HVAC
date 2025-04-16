//
//  ThermalConductivityModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import Foundation

struct ThermalConductivityModel: Decodable, Equatable, Hashable {
    let a: Double
    let b: Double
}
