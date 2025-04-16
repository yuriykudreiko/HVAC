//
//  MaterialsViewModel.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import SwiftUI
import Combine

final class MaterialsViewModel: ObservableObject {
    
    var onMaterialSelect: ((_ material: MaterialModel, _ width: Double) -> Void)?

    // MARK: - Properties

    @Published var sections: [MaterialSectionModel] = []
    @Published var initialSections: [MaterialSectionModel] = []

    @Published var selectedMaterial: MaterialModel?

    @Published var searchText: String = ""
    @Published var materialWidth: String = ""
    
    @Published var isScreenShown = true
    @Published var shouldShowNoWidthError = false
    @Published var shouldShowNoMaterialError = false

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
            self.initialSections = sections
        } catch {
            print(error)
        }
        
        let userDefaults = UserDefaults.standard
        //        let defaultValue: [String: String] = [:]
        _recentMaterials = AppStorage(wrappedValue: "value", "recentMaterials", store: userDefaults)
        
        bind()
    }

    // MARK: - Actions
    
    func select(material: MaterialModel) {
        // FIXME: - add recent materials logic
        if selectedMaterial == material {
            selectedMaterial = nil
        } else {
            selectedMaterial = material
        }
        
        shouldShowNoWidthError = false
    }
    
    func addButtonWasTapped() {
        guard let selectedMaterial = selectedMaterial else {
            shouldShowNoMaterialError = true
            return
        }
        
        guard let width = Double(materialWidth) else {
            shouldShowNoWidthError = true
            return
        }
        
        onMaterialSelect?(selectedMaterial, width)
        isScreenShown = false
    }
    
    func close() {
        isScreenShown = false
    }
    
    // MARK: - Bindings
    
    func bind() {
        $materialWidth
            .sink { [weak self] _ in
                guard let self else { return }
                
                shouldShowNoWidthError = false
            }
            .store(in: &cancellableSet)
        
        $searchText
            .sink { [weak self] text in
                self?.updateSearchResults(for: text)
            }
            .store(in: &cancellableSet)
    }
    
    // MARK: - Private
    
    func updateSearchResults(for searchText: String) {
        guard !searchText.isEmpty else {
            sections = initialSections
            return
        }
        
        sections = initialSections
            .compactMap { section in
                let filteredMaterials = section.materials
                    .filter {
                        SmartSearch.checkMatch(for: $0.name, with: searchText)
                    }
                
                if filteredMaterials.isEmpty {
                    return nil
                } else {
                    return MaterialSectionModel(id: section.id, name: section.name, materials: filteredMaterials)
                }
            }
    }

}
