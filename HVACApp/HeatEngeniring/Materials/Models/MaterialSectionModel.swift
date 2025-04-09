//
//  MaterialSectionModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import Foundation

struct MaterialSectionModel: Decodable, Identifiable {
    let id: String
    let name: String
    let materials: [MaterialModel]
}
