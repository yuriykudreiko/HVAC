//
//  HeatLossCalculationViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 15.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol HeatLossCalculationViewControllerDelegate {
    func addHeatLossCalculationWith(result: HeatLossResult, overwrite: Bool)
}

class HeatLossCalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewConstructionViewControllerDelegate {

    // MARK: - Static constants and functions
    
    //static private let myFont : UIFont = UIFont.systemFont(ofSize: 14)
    
//    static private func createTextFieldWith(text: String, keyboardType: UIKeyboardType, returnKey: UIReturnKeyType) -> UITextField {
//        let sampleTextField = UITextField()
//        sampleTextField.text = text
//        sampleTextField.placeholder = "Enter text here"
//        sampleTextField.font = myFont
//        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
//        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
//        sampleTextField.keyboardType = UIKeyboardType.default
//        sampleTextField.returnKeyType = UIReturnKeyType.next
//        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing
//        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//        sampleTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
//        return sampleTextField
//    }
    
//    static private func createLabelWith(text: String) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.font = myFont
//        label.textAlignment = .center
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 8
//        label.backgroundColor = .lightGray
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        return label
//    }
    
    static private func createButton(text: String, color: UIColor) -> UIButton {
        let buttom = UIButton(type: .system)
        buttom.setTitle(text, for: .normal)
        buttom.backgroundColor = color
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = myFont
        buttom.setTitleColor(.gray, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }
    
    // MARK: - Properties
    
    var delegate : HeatLossCalculationViewControllerDelegate?
    var calculationResult : HeatLossResult?
    private var rememberNumberOfElement : Int?
    var overwriteHeatLossResult : Bool = false
    
    // MARK: - Items

    let calculateButton : UIButton = {
        let button = createButton(text: "Пересчитать", color: .turquoise)
        button.addTarget(self, action: #selector(calculationWhenValueChangegAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let saveButton : UIButton = {
        let buttom = createButton(text: "Сохранить", color: .lightGreen)
        buttom.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        return buttom
    }()
    
    let tableView : UITableView = {
        let myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HeatLossCell")
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        return myTableView
    }()
    
    private let outdoorTemperatureTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "-24", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let indoorTemperatureTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "18", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let wallResistanceTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "3.2", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let windowResistanceTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "1", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let ceilingResistanceTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "6", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let flourResistanceTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "2.5", placeholder: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let outdoorTemperatureLablel : UILabel = {
        let label = createLabelWith(text: "Наружная температура,°C")
        return label
    }()
    
    private let indoorTemperatureLablel : UILabel = {
        let label = createLabelWith(text: "Внутренняя температура, °C")
        return label
    }()
    
    private let wallResistanceLablel : UILabel = {
        let label = createLabelWith(text: "R стены, м²·°C/Вт")
        return label
    }()
    
    private let windowResistanceLablel : UILabel = {
        let label = createLabelWith(text: "R окна, м²·°C/Вт")
        return label
    }()
    
    private let ceilingResistanceLablel : UILabel = {
        let label = createLabelWith(text: "R покрытия, м²·°C/Вт")
        return label
    }()
    
    private let flourResistanceLablel : UILabel = {
        let label = createLabelWith(text: "R пола, м²·°C/Вт")
        return label
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if calculationResult == nil {
            self.createAlert()
            let outTemp = Double(outdoorTemperatureTextField.text!)!
            let indTemp = Double(indoorTemperatureTextField.text!)!
            let wallRes = Double(wallResistanceTextField.text!)!
            let windowRes = Double(windowResistanceTextField.text!)!
            let ceilingRes = Double(ceilingResistanceTextField.text!)!
            let flourRes = Double(flourResistanceTextField.text!)!

            calculationResult = HeatLossResult(indoorTemperature: indTemp, outdoorTemperature: outTemp, wallResistance: wallRes, windowResistance: windowRes, ceilingResistance: ceilingRes, flourResistance: flourRes)
        } else {
            
            if let name = calculationResult?.calculationName {
                self.navigationItem.title = name
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
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addConstructionAction(sander:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        layoutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView], axis: UILayoutConstraintAxis) -> UIStackView {
        
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
            ]
        )
        
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
        
        if let result = self.calculationResult {

            self.delegate?.addHeatLossCalculationWith(result: result, overwrite: overwriteHeatLossResult)
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
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Введите имя"
        })
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            let textField = alertVC.textFields![0] as UITextField
            if let text = textField.text {
                self.calculationResult?.calculationName = text
                self.navigationItem.title = self.calculationResult?.calculationName
            }
        })
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.calculationResult?.constructionArray.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Теплопотери через ограждающие конструкции"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var sum : Double = 0
        
        for item in (self.calculationResult?.constructionArray)! {
            sum += item.heatLoss
        }
        return "Сумма: \(sum) Вт"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HeatLossCell"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        let constr = self.calculationResult?.constructionArray[indexPath.row]
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
