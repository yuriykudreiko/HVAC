import SwiftUI
import Combine

final class EngeniringCalculationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var calculationResult: EngeniringResult?
    @Published var materialArray: [Material] = []
    @Published var name: String?
    @Published var normalizedWallResistance: String = "3.2"
    @Published var materialName: String = ""
    @Published var thermalConductivity: String = ""
    @Published var insulationWidth: String = ""
    
    @Published var shouldShowCalculationAlert = false
    @Published var shouldShowSaveAlert = false
    @Published var shouldShowNameAlert = false
    
    // MARK: - Properties
    
    var delegate: EngeniringCalculationViewControllerDelegate?
    var overwriteMainResult: Bool?
    
    var numberOfElement: Int?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var layerCountString: String {
        "Слоев: \(materialArray.count)"
    }
    
    // MARK: - Initialization
    
    init(calculationResult: EngeniringResult? = nil, overwriteMainResult: Bool? = nil) {
        self.calculationResult = calculationResult
        self.overwriteMainResult = overwriteMainResult
        
        setupInitialState()
        bind()
    }
    
    // MARK: - Setup
    
    private func setupInitialState() {
        materialArray = calculationResult?.materialArray ?? []
        
        if let calculation = calculationResult?.nameOfCalculation {
            name = calculation
        }
        
        if let norm = calculationResult?.normalizedWallResistance {
            normalizedWallResistance = String(norm)
        }
        
        if let kind = calculationResult?.insulationMaterial.name {
            materialName = kind
        }
        
        if let thermal = calculationResult?.insulationMaterial.thermalConductivity {
            thermalConductivity = String(thermal)
        }
        
        if let width = calculationResult?.insulationMaterial.width {
            let insulationWidth = Double(round(1000 * width) / 1000)
            self.insulationWidth = String(insulationWidth)
        }
        
        if overwriteMainResult == false {
            shouldShowNameAlert = true
        }
    }
    
    private func bind() {
        // Add any necessary bindings here
    }
    
    // MARK: - Actions
    
    func performCalculation() {
        guard
            let calculationName = name,
            let thermalConductivityValue = Double(thermalConductivity),
            let normalizedWallResistanceValue = Double(normalizedWallResistance)
        else {
            shouldShowCalculationAlert = true
            return
        }
        
        let result = EngeniringResult(
            calculationName: calculationName,
            thermalInsulationName: materialName,
            normalizedWallResistance: normalizedWallResistanceValue,
            materialArray: materialArray,
            thermalInsulationConductivity: thermalConductivityValue
        )
        
        let width = Double(round(1000 * result.insulationMaterial.width) / 1000)
        insulationWidth = String(width)
        
        calculationResult = result
    }
    
    func saveCalculation() {
        if let result = calculationResult {
            delegate?.addCalculation(result: result, overwrite: overwriteMainResult!)
        } else {
            shouldShowSaveAlert = true
        }
    }
    
    func setName(_ newName: String) {
        name = newName
    }
    
    func addMaterial(_ material: Material, updateExistingElement: Bool) {
        if updateExistingElement, let row = numberOfElement {
            materialArray[row] = material
        } else {
            materialArray.append(material)
        }
    }
    
    func removeMaterial(at index: Int) {
        materialArray.remove(at: index)
    }
    
    func setSelectedElement(_ index: Int) {
        numberOfElement = index
    }
} 
