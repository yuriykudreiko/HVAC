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
    @Published var recentSection: MaterialSectionModel? // Store recent materials

    @Published var selectedMaterial: MaterialModel?

    @Published var searchText: String = ""
    @Published var materialWidth: String = ""
    
    @Published var isScreenShown = true
    @Published var isSearchStarted = false
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

            self.initialSections = sections
        } catch {
            print(error)
        }
        
        bind()
        loadRecentMaterials()
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
        
        addToRecentMaterials()
        onMaterialSelect?(selectedMaterial, width)
        isScreenShown = false
    }
    
    func close() {
        addToRecentMaterials()
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
        
        $isSearchStarted
            .sink { [weak self] isStarted in
                guard let self else { return }
                
                if isStarted {
                    sections = initialSections
                } else if let recentSection = recentSection {
                    sections = [recentSection] + initialSections
                } else {
                    sections = initialSections
                }
            }
            .store(in: &cancellableSet)
    }
    
    // MARK: - Recent Materials
    
    func addToRecentMaterials() {
        guard let material  = selectedMaterial else { return }
        
        var recentList = getRecentMaterials()

        // Ensure uniqueness and limit to last 5 used
        recentList.removeAll { $0.id == material.id }
        recentList.insert(material, at: 0)
        recentList = Array(recentList.prefix(5)) // Keep only the last 5 materials
        
        // Store recent materials in UserDefaults
        if let encoded = try? JSONEncoder().encode(recentList.map { $0.id }) {
            recentMaterials = String(data: encoded, encoding: .utf8) ?? ""
        }
    }
    
    func getRecentMaterials() -> [MaterialModel] {
        guard let data = recentMaterials.data(using: .utf8),
              let storedIds = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }

        return initialSections
            .flatMap { $0.materials }
            .filter { storedIds.contains($0.id) }
    }
    
    func loadRecentMaterials() {
        let recentList = getRecentMaterials()
        guard !recentList.isEmpty else {
            return
        }
        
        let recentSection = MaterialSectionModel(id: "0", name: "Недавно использованные", materials: recentList)
        sections = [recentSection] + initialSections
        self.recentSection = recentSection
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
