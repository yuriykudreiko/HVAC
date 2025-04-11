//
//  MaterialsViewModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import SwiftUI
import Combine

class MaterialsViewModel: ObservableObject {
    
    var onMaterialSelect: ((_ material: MaterialModel, _ width: Double) -> Void)?

    // MARK: - Properties

    @Published var sections: [MaterialSectionModel] = []
    @Published var selectedMaterial: MaterialModel?

    @Published var searchText: String = ""
    @Published var materialWidth: String = ""
    
    @Published var isScreenShown = true
    @Published var shouldShowError = false
    @Published var shouldScrollToSelectedMaterial = false

    @AppStorage("recentMaterials") private var recentMaterials: String = ""

    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init() {
        do {
            let url = Bundle.main.url(forResource: "Materials", withExtension: "json")!
            let materialsData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let sections = try decoder.decode([MaterialSectionModel].self, from: materialsData)

            self.sections = sections
        } catch {
            print(error)
        }
        
        let userDefaults = UserDefaults.standard
        //        let defaultValue: [String: String] = [:]
        _recentMaterials = AppStorage(wrappedValue: "value", "recentMaterials", store: userDefaults)
        
        bind()
    }
    
    // MARK: - Bindings
    
    func bind() {
        $materialWidth
            .sink { [weak self] _ in
                self?.shouldShowError = false
            }
            .store(in: &cancellableSet)
    }

    // MARK: - Actions
    
    func select(material: MaterialModel) {
        // FIXME: - add recent materials logic
        if selectedMaterial == material {
            selectedMaterial = nil
        } else {
            selectedMaterial = material
        }
        
        shouldShowError = false
    }
    
    func addButtonWasTapped() {
        guard
            let selectedMaterial = selectedMaterial,
            let width = Double(materialWidth)
        else {
            shouldShowError = true
            return
        }
        
        onMaterialSelect?(selectedMaterial, width)
        isScreenShown = false
    }
    
    func close() {
        isScreenShown = false
    }
    
}
