//
//  HeatCalculationResultViewController.swift
//  HVACApplicationBegin
//
//  Created by Yra on 03.09.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

class HeatFloorCalculationResultViewController: UIViewController, HeatFloorCalculationViewControllerDelegate {
    
    // MARK: - Static constants and functions
    
    static private let myFont : UIFont = UIFont.systemFont(ofSize: 14)
    
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

    // MARK: - Items
    
    private let pipeLengthLabel : UILabel = {
        let label = createLabelWith(text: "Длинна труб, м")
        return label
    }()

    private let pipeLengthResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let waterFlowLabel : UILabel = {
        let label = createLabelWith(text: "Расход теплоносителя, м3/ч")
        return label
    }()
    
    private let waterFlowResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let heatFlowLabel : UILabel = {
        let label = createLabelWith(text: "Тепловой поток, Вт")
        return label
    }()
    
    private let heatFlowResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let pipeDiameterLabel : UILabel = {
        let label = createLabelWith(text: "Диаметр, мм")
        return label
    }()
    
    private let pipeDiameterResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let pressureDropLabel : UILabel = {
        let label = createLabelWith(text: "Потери давления, кПа")
        return label
    }()
    
    private let pressureDropResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let maxFloorTemperatureLabel : UILabel = {
        let label = createLabelWith(text: "Температура пола, °C")
        return label
    }()
    
    private let maxFloorTemperatureResultLabel : UILabel = {
        let label = createLabelWith(text: "")
        return label
    }()
    
    private let stackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.axis = .vertical
        myStackView.spacing = 10
        myStackView.distribution = .fillEqually
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        return myStackView
    }()
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Рассчет внутрипольного отопления"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backAction))
        print("ViewDidLoad")
        layoutSetup()
    }
    
    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        return line
    }

    private func createStackLine() -> [UIView] {
        
        let firstLine = createStackViewWith(subviews: [pipeLengthLabel, pipeLengthResultLabel])
        let secondLine = createStackViewWith(subviews: [waterFlowLabel, waterFlowResultLabel])
        let thirdLine = createStackViewWith(subviews: [heatFlowLabel, heatFlowResultLabel])
        let fourthLine = createStackViewWith(subviews: [pipeDiameterLabel, pipeDiameterResultLabel])
        let fifthLine = createStackViewWith(subviews: [pressureDropLabel, pressureDropResultLabel])
        let sixthLine = createStackViewWith(subviews: [maxFloorTemperatureLabel, maxFloorTemperatureResultLabel])
        
        return [firstLine, secondLine, thirdLine, fourthLine, fifthLine, sixthLine]
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
            stackView.heightAnchor.constraint(equalToConstant: 500)
            ]
        )
    }

    
    // MARK: - Actions
    
    @objc func backAction() {
        dismiss(animated: true) {
            
        }
    }
    
    // MARK: - HeatFloorCalculationViewControllerDelegate
    
    func addHeatFloorCalculationWith(square: Double,
                                     heatLoss: Double,
                                     pipeManufacturer: String,
                                     floorConstruction: String,
                                     waterTemperature: Double,
                                     distanceBetweenPipes: Double,
                                     indoorTemperature: Double) {
        
        print("square: \(square)\n" +
            "heatLoss: \(heatLoss)\n" +
            "pipeManufacturer: \(pipeManufacturer)\n" +
            "floorConstruction: \(floorConstruction)\n" +
            "waterTemperature: \(waterTemperature)\n" +
            "distanceBetweenPipes: \(distanceBetweenPipes)\n" +
            "indoorTemperature: \(indoorTemperature)")
        
        
        let hfc = HeatFloorCalculation(square: square,
                                       heatLoss: heatLoss,
                                       pipeManufacture: pipeManufacturer,
                                       floorConstruction: floorConstruction,
                                       waterTemperature: waterTemperature,
                                       distanceBetweenPipes: distanceBetweenPipes,
                                       indoorTemperature: indoorTemperature)
        
        let firstLine = createStackViewWith(subviews: [
            
            ]
        )
        
        pipeLengthResultLabel.text = String(format: "%.2f", hfc.pipeLength!)
        waterFlowResultLabel.text = String(format: "%.2f", hfc.waterFlow!)
        heatFlowResultLabel.text = String(format: "%.2f", hfc.heatFlow!)
        pipeDiameterResultLabel.text = hfc.pipeDiameter
        let result = (hfc.pressureDrop! * hfc.pipeLength!) / 1000
        pressureDropResultLabel.text = String(format: "%.2f", result)
        maxFloorTemperatureResultLabel.text =  String(format: "%.2f", hfc.maxFloorTemperature!)
        if hfc.maxFloorTemperature! >= 26 {
            maxFloorTemperatureResultLabel.backgroundColor = .red
        }
        
    }
}
