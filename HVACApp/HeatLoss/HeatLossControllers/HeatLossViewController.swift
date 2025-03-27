//
//  HeatLossViewController.swift
//  HVACApp
//
//  Created by User3 on 15.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol HeatLossCalculationViewControllerDelegate {
    func addHeatLossCalculationWith(result: HeatLossResult, overwrite: Bool)
}

class HeatLossViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewConstructionViewControllerDelegate {
    
    // MARK: - Properties
    
    var delegate: HeatLossCalculationViewControllerDelegate?
    var calculationResult: HeatLossResult?
    private var rememberNumberOfElement: Int?
    var overwriteHeatLossResult: Bool = false
    
    // MARK: - Items
    
    let calculateButton: UIButton = {
        let button = createButton(text: "Пересчитать", color: .turquoise)
        return button
    }()
    
    let saveButton: UIButton = {
        let buttom = createButton(text: "Сохранить", color: .lightGreen)
        return buttom
    }()
    
    let tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HeatLossCell")
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return myTableView
    }()
    
    private let outdoorTemperatureTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "-24",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let indoorTemperatureTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "18",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let wallResistanceTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "3.2",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let windowResistanceTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "1",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let ceilingResistanceTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "6",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let flourResistanceTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "2.5",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    private let outdoorTemperatureLablel: UILabel = {
        let label = createLabelWith(text: "Наружная температура,°C")
        
        return label
    }()
    
    private let indoorTemperatureLablel: UILabel = {
        let label = createLabelWith(text: "Внутренняя температура, °C")
        
        return label
    }()
    
    private let wallResistanceLablel: UILabel = {
        let label = createLabelWith(text: "R стены, м²·°C/Вт")
        
        return label
    }()
    
    private let windowResistanceLablel: UILabel = {
        let label = createLabelWith(text: "R окна, м²·°C/Вт")
        
        return label
    }()
    
    private let ceilingResistanceLablel: UILabel = {
        let label = createLabelWith(text: "R покрытия, м²·°C/Вт")
        
        return label
    }()
    
    private let flourResistanceLablel: UILabel = {
        let label = createLabelWith(text: "R пола, м²·°C/Вт")
        
        return label
    }()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.addTarget(self, action: #selector(calculationWhenValueChangegAction(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        
        if calculationResult == nil {
            createAlert()
            let outTemp = Double(outdoorTemperatureTextField.text!)!
            let indTemp = Double(indoorTemperatureTextField.text!)!
            let wallRes = Double(wallResistanceTextField.text!)!
            let windowRes = Double(windowResistanceTextField.text!)!
            let ceilingRes = Double(ceilingResistanceTextField.text!)!
            let flourRes = Double(flourResistanceTextField.text!)!
            
            calculationResult = HeatLossResult(
                indoorTemperature: indTemp,
                outdoorTemperature: outTemp,
                wallResistance: wallRes,
                windowResistance: windowRes,
                ceilingResistance: ceilingRes,
                flourResistance: flourRes
            )
        } else {
            if let name = calculationResult?.calculationName {
                navigationItem.title = name
            }
            
            if let outTemp = calculationResult?.outdoorTemperature {
                outdoorTemperatureTextField.text = "\(outTemp)"
            }
            
            if let indTemp = calculationResult?.indoorTemperature {
                indoorTemperatureTextField.text = "\(indTemp)"
            }
            
            if let wallRes = calculationResult?.wallResistance {
                wallResistanceTextField.text = "\(wallRes)"
            }
            
            if let windowRes = calculationResult?.windowResistance {
                windowResistanceTextField.text = "\(windowRes)"
            }
            
            if let ceilingRes = calculationResult?.ceilingResistance {
                ceilingResistanceTextField.text = "\(ceilingRes)"
            }
            
            if let flourRes = calculationResult?.flourResistance {
                flourResistanceTextField.text = "\(flourRes)"
            }
        }
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(sender:))
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addConstructionAction(sander:))
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        layoutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Layout
    private func createStackViewWith(subviews: [UIView], axis: NSLayoutConstraint.Axis) -> UIStackView {
        let line = UIStackView(arrangedSubviews: subviews)
        line.axis = axis
        line.distribution = .fillEqually
        line.spacing = 10
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }
    
    private func layoutSetup() {
        let leftColumnStackView = createStackViewWith(subviews: [outdoorTemperatureLablel, indoorTemperatureLablel, wallResistanceLablel, windowResistanceLablel, ceilingResistanceLablel, flourResistanceLablel], axis: .vertical)
        let rightColumnStackView = createStackViewWith(subviews: [outdoorTemperatureTextField, indoorTemperatureTextField, wallResistanceTextField, windowResistanceTextField, ceilingResistanceTextField, flourResistanceTextField], axis: .vertical)
        let mainStackView = createStackViewWith(subviews: [leftColumnStackView, rightColumnStackView], axis: .horizontal)
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            mainStackView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        let buttonStack = createStackViewWith(subviews: [saveButton, calculateButton], axis: .horizontal)
        view.addSubview(buttonStack)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func calculationWhenValueChangegAction(sender: UITextField) {
        if let outTemp = Double(outdoorTemperatureTextField.text!),
           let indTemp = Double(indoorTemperatureTextField.text!),
           let wallRes = Double(wallResistanceTextField.text!),
           let windowRes = Double(windowResistanceTextField.text!),
           let ceilingRes = Double(ceilingResistanceTextField.text!),
           let flourRes = Double(flourResistanceTextField.text!) {
            
            calculationResult?.outdoorTemperature = outTemp
            calculationResult?.indoorTemperature = indTemp
            calculationResult?.wallResistance = wallRes
            calculationResult?.windowResistance = windowRes
            calculationResult?.ceilingResistance = ceilingRes
            calculationResult?.flourResistance = flourRes
            calculationResult?.calculateAllConstructionAfterChange()
            tableView.reloadData()
        } else {
            createSaveAlert()
        }
    }
    
    @objc private func saveAction(sender: UIButton) {
        if let result = calculationResult {
            delegate?.addHeatLossCalculationWith(result: result, overwrite: overwriteHeatLossResult)
            dismiss(animated: true)
        } else {
            createSaveAlert()
        }
    }
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func addConstructionAction(sander: UIBarButtonItem) {
        let vc = AddNewConstructionViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    // MARK: - Alert
    
    private func createAlert() {
        let alertVC = UIAlertController(title: "Введите имя рассчета", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите имя"
        }
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned self] (alertAction) in
            guard let textField = alertVC.textFields?.first,
                  let text = textField.text else { return }
            
            calculationResult?.calculationName = text
            navigationItem.title = calculationResult?.calculationName
        }
        
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
    private func createSaveAlert() {
        let alertVC = UIAlertController(title: "Заполните правильно все поля в текущем окне", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (calculationResult?.constructionArray.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Теплопотери через ограждающие конструкции"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var sum: Double = 0
        
        for item in (calculationResult?.constructionArray)! {
            sum += item.heatLoss
        }
        
        return "Сумма: \(sum) Вт"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HeatLossCell"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        let constr = calculationResult?.constructionArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = constr?.name
        
        if let loss = constr?.heatLoss {
            cell.detailTextLabel?.text = "\(loss) Вт"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rememberNumberOfElement = indexPath.row
        let vc = AddNewConstructionViewController()
        vc.delegate = self
        vc.currentConstruction = calculationResult?.constructionArray[indexPath.row]
        vc.overwrite = true
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    // MARK: - AddNewConstructionViewControllerDelegate
    
    func addNewConstructionWith(name: String, orientation: String, square: Double, overwrite: Bool) {
        if overwrite {
            if let index = rememberNumberOfElement {
                let newConstruction = calculationResult?.calculateConstructionWith(name: name, square: square, orientation: orientation)
                calculationResult?.constructionArray[index] = newConstruction!
            }
        } else {
            let newConstruction = calculationResult?.calculateConstructionWith(name: name, square: square, orientation: orientation)
            calculationResult?.constructionArray.append(newConstruction!)
        }
    }
}
