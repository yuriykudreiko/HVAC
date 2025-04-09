//
//  MaterialsViewModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import SwiftUI

class MaterialsViewModel: ObservableObject {
    
    @Published var sections: [MaterialSectionModel] = []
    @Published var expandedSections: Set<String> = []
    @Published var searchText: String = ""

    init() {
        do {
            let url = Bundle.main.url(forResource: "Materials", withExtension: "json")!
            let materialsData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let sections = try decoder.decode([MaterialSectionModel].self, from: materialsData)

            self.expandedSections = Set(sections.map { $0.id })
            self.sections = sections
        } catch {
            print(error)
        }
    }
    
    func bindExpandedSections(sectionModel: MaterialSectionModel) -> Binding<Bool> {
        return Binding<Bool> (
            get: {
                return self.expandedSections.contains(sectionModel.id)
            },
            set: { isExpanding in
                if isExpanding {
                    self.expandedSections.insert(sectionModel.id)
                } else {
                    self.expandedSections.remove(sectionModel.id)
                }
            }
        )
    }
    
}
