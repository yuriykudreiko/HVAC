//
//  HeatFloorCalculationViewController.swift
//  HVACApplicationBegin
//
//  Created by Yra on 02.09.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol HeatFloorCalculationViewControllerDelegate {
    func addHeatFloorCalculationWith(square: Double, heatLoss: Double, pipeManufacturer: String, floorConstruction: String, waterTemperature: Double, distanceBetweenPipes: Double, indoorTemperature: Double)
}

class HeatFloorCalculationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Static constants and functions
    
    static private let myFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    static private func createTextFieldWith(keyboardType: UIKeyboardType, returnKey: UIReturnKeyType) -> UITextField {
        let sampleTextField = UITextField()
        sampleTextField.placeholder = "Введите площадь, м²"
        sampleTextField.font = myFont
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.next
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        return sampleTextField
    }
    
    static private func createPickerView() -> UIPickerView {
        let typePickerView = UIPickerView()
        typePickerView.backgroundColor = .lightGray
        typePickerView.layer.cornerRadius = 8
        
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        return typePickerView
    }
    
    static private func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = myFont
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    // MARK: - Properties
    
    var delegate : HeatFloorCalculationViewControllerDelegate?
    private let pipeManufacturerArray = ["Kan", "Herz", "Rehau"]
    private let floorConstructionArray = ["Плитка", "Мрамор", "Ковер", "Паркет", "Ламинат"]
    private let waterTemperatureArray = ["55", "50", "45", "40"]
    private let distanceBetweenPipesArray = ["0.10", "0.15", "0.20", "0.25", "0.30", "0.35"]
    private let indoorTemperatureArray = ["15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"]

    // MARK: - Items
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pipeManufacturerPickerView : UIPickerView = {
        return createPickerView()
    }()
    
    private let floorConstructionPickerView : UIPickerView = {
        return createPickerView()
    }()
    
    private let temperaturePickerView : UIPickerView = {
        return createPickerView()
    }()
    
    private let distanceBetweenPipesPickerView : UIPickerView = {
        return createPickerView()
    }()
    
    private let indoorTemperaturePickerView : UIPickerView = {
        return createPickerView()
    }()
    
    private let squareTextField : UITextField = {
        let sampleTextField = createTextFieldWith(keyboardType: .default, returnKey: .done)
        return sampleTextField
    }()
    
    private let heatLossTextField : UITextField = {
        let sampleTextField = createTextFieldWith(keyboardType: .default, returnKey: .done)
        return sampleTextField
    }()
    
    private let squareLabel : UILabel = {
        let label = createLabelWith(text: "Площадь, м²")
        return label
    }()
    
    private let heatLossLabel : UILabel = {
        let label = createLabelWith(text: "Теплопотери, Вт")
        return label
    }()
    
    private let pipeManufacturerLabel : UILabel = {
        let label = createLabelWith(text: "Производитель труб")
        return label
    }()
    
    private let floorConstructionLabel : UILabel = {
        let label = createLabelWith(text: "Материал")
        return label
    }()
    
    private let temperatureLabel : UILabel = {
        let label = createLabelWith(text: "Температура в подающем трубопроводе,°C")
        return label
    }()
    
    private let distanceBetweenPipesLabel : UILabel = {
        let label = createLabelWith(text: "Расстояние между трубами, м")
        return label
    }()
    
    private let indoorTemperatureLabel : UILabel = {
        let label = createLabelWith(text: "Температура в помещении,°C")
        return label
    }()
    
    private let calculateButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Расчет>", for: .normal)
        buttom.backgroundColor = .blue
        buttom.layer.cornerRadius = 8
        buttom.titleLabel?.font = myFont
        buttom.setTitleColor(.gray, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(calculateAction), for: .touchUpInside)
        return buttom
    }()
    
    private let stackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.axis = .vertical
        myStackView.spacing = 10
        myStackView.distribution = .fillEqually
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        return myStackView
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        pipeManufacturerPickerView.delegate = self
        pipeManufacturerPickerView.dataSource = self
        temperaturePickerView.delegate = self
        temperaturePickerView.dataSource = self
        floorConstructionPickerView.delegate = self
        floorConstructionPickerView.dataSource = self
        distanceBetweenPipesPickerView.delegate = self
        distanceBetweenPipesPickerView.dataSource = self
        indoorTemperaturePickerView.delegate = self
        indoorTemperaturePickerView.dataSource = self
        layoutSetup()
        loadDefaults()
    }
    
    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        return line
    }
    
    private func createStackLine() -> [UIView] {
        
        let firstLine = createStackViewWith(subviews: [squareLabel, squareTextField])
        let secondLine = createStackViewWith(subviews: [heatLossLabel, heatLossTextField])
        let thirdLine = createStackViewWith(subviews: [pipeManufacturerLabel, pipeManufacturerPickerView])
        let fourthLine = createStackViewWith(subviews: [floorConstructionLabel, floorConstructionPickerView])
        let fifthLine = createStackViewWith(subviews: [temperatureLabel, temperaturePickerView])
        let sixthLine = createStackViewWith(subviews: [distanceBetweenPipesLabel, distanceBetweenPipesPickerView])
        let seventhLine = createStackViewWith(subviews: [indoorTemperatureLabel, indoorTemperaturePickerView])

        return [firstLine, secondLine, thirdLine, fourthLine, fifthLine, sixthLine, seventhLine, calculateButton]
    }
    
    private func layoutSetup() {
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ]
        )
        for subView in createStackLine() {
            stackView.addArrangedSubview(subView)
        }
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 600)
            ]
        )
    }

    // MARK: - Alert
    
    private func createCalculationAlert() {
        
        let alertVC = UIAlertController(title: "Заполните правильно все поля в текущем окне", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
            present(alertVC, animated: true) {
        }
    }
    
    // MARK: - Actions

    @objc private func calculateAction(sender: UIButton) {
        let pipeManufacturer = pipeManufacturerArray[self.pipeManufacturerPickerView.selectedRow(inComponent: 0)]
        let floorConstruction = floorConstructionArray[self.floorConstructionPickerView.selectedRow(inComponent: 0)]
        let waterTemperature = Double(waterTemperatureArray[self.temperaturePickerView.selectedRow(inComponent: 0)])!
        
        let distanceBetweenPipes = Double(distanceBetweenPipesArray[self.distanceBetweenPipesPickerView.selectedRow(inComponent: 0)])!
        let indoorTemperature = Double(indoorTemperatureArray[self.indoorTemperaturePickerView.selectedRow(inComponent: 0)])!
        
        if let square = Double(squareTextField.text!), let heatLoss = Double(heatLossTextField.text!) {
            saveDefaults()

            let vc = HeatFloorCalculationResultViewController()
            self.delegate = vc
            let navVC = UINavigationController(rootViewController: vc)
            self.delegate?.addHeatFloorCalculationWith(square: square,
                                                       heatLoss: heatLoss,
                                                       pipeManufacturer: pipeManufacturer,
                                                       floorConstruction: floorConstruction,
                                                       waterTemperature: waterTemperature,
                                                       distanceBetweenPipes: distanceBetweenPipes,
                                                       indoorTemperature: indoorTemperature)
            present(navVC, animated: true)
            
        } else {
            createCalculationAlert()
        }
    }
    
    // MARK: - UserDefaults

    func saveDefaults() {
        let defaults = UserDefaults.standard
        if let square = squareTextField.text {
            defaults.set(square, forKey: "floorSquare")
        }
        if let heatLoss = heatLossTextField.text {
            defaults.set(heatLoss, forKey: "heatLoss")
        }
        defaults.set(self.pipeManufacturerPickerView.selectedRow(inComponent: 0), forKey: "pipeManufactureIndex")
        defaults.set(self.floorConstructionPickerView.selectedRow(inComponent: 0), forKey: "floorConstructionIndex")
        defaults.set(self.temperaturePickerView.selectedRow(inComponent: 0), forKey: "waterTemperatureIndex")
        defaults.set(self.distanceBetweenPipesPickerView.selectedRow(inComponent: 0), forKey: "distanceBetweenPipesIndex")
        defaults.set(self.indoorTemperaturePickerView.selectedRow(inComponent: 0), forKey: "indoorTemperatureIndex")
    }
    
    func loadDefaults() {
        let defaults = UserDefaults.standard
        squareTextField.text = defaults.string(forKey: "floorSquare")
        heatLossTextField.text = defaults.string(forKey: "heatLoss")
        pipeManufacturerPickerView.selectRow(defaults.integer(forKey: "pipeManufactureIndex"), inComponent: 0, animated: true)
        floorConstructionPickerView.selectRow(defaults.integer(forKey: "floorConstructionIndex"), inComponent: 0, animated: true)
        temperaturePickerView.selectRow(defaults.integer(forKey: "waterTemperatureIndex"), inComponent: 0, animated: true)
        distanceBetweenPipesPickerView.selectRow(defaults.integer(forKey: "distanceBetweenPipesIndex"), inComponent: 0, animated: true)
        indoorTemperaturePickerView.selectRow(defaults.integer(forKey: "indoorTemperatureIndex"), inComponent: 0, animated: true)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pipeManufacturerPickerView {
            return pipeManufacturerArray.count
        } else if pickerView == floorConstructionPickerView {
            return floorConstructionArray.count
        } else if pickerView == temperaturePickerView {
            return waterTemperatureArray.count
        } else if pickerView == distanceBetweenPipesPickerView {
            return distanceBetweenPipesArray.count
        } else {
            return indoorTemperatureArray.count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pipeManufacturerPickerView {
            return pipeManufacturerArray[row]
        } else if pickerView == floorConstructionPickerView {
            return floorConstructionArray[row]
        } else if pickerView == temperaturePickerView {
            return waterTemperatureArray[row]
        } else if pickerView == distanceBetweenPipesPickerView {
            return distanceBetweenPipesArray[row]
        } else {
            return indoorTemperatureArray[row]
        }
    }
}




