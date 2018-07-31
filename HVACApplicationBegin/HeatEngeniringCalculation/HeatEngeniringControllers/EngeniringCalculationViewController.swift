//
//  EngeniringCalculationViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 07.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

extension UIColor {
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
    static var turquoise = UIColor(red: 48/255, green: 214/255, blue: 200/255, alpha: 1)//(48,214,200)
    static var aquamarine = UIColor(red: 121/255, green: 248/255, blue: 248/255, alpha: 1)//(121,248,248)
    static var lightGreen = UIColor(red: 80/255, green: 255/255, blue: 0/255, alpha: 1)//(80,255,0)
}

protocol EngeniringCalculationViewControllerDelegate {
    func addCalculation(result: EngeniringResult, overwrite: Bool)
}

class EngeniringCalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EngeniringViewControllerDelegate {

    // MARK: - Static constants and functions
    
    static private let myFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    static private func createTextFieldWith(text: String, keyboardType: UIKeyboardType, returnKey: UIReturnKeyType) -> UITextField {
        let sampleTextField = UITextField()
        sampleTextField.placeholder = "Enter text here"
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
    
    static private func createLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = myFont
        return label
    }
    
    static private func createButton(text: String, color: UIColor) -> UIButton {
        let buttom = UIButton(type: .system)
        buttom.setTitle(text, for: .normal)
        buttom.backgroundColor = color
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = myFont
        buttom.setTitleColor(.gray, for: .normal)
        return buttom
    }
    
    // MARK: - Properties
    
    var delegate : EngeniringCalculationViewControllerDelegate?
    private var name : String?
    private var calculationArray : [Material] = []
    private var thermalInsulationMaterial : Material?
    var calculationResult : EngeniringResult?
    var numberOfElement : Int?
    var overwriteMainResult : Bool?
    
    
    // MARK: - Items
    
    let calculationButton : UIButton = {
        let button = createButton(text: "Рассчет", color: .turquoise)
        button.addTarget(self, action: #selector(calculationAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let saveButton : UIButton = {
        let buttom = createButton(text: "Сохранить", color: .lightGreen)
        buttom.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        return buttom
    }()
    
    let tableView : UITableView = {
        let myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        return myTableView
    }()
    
    let normalizedWallResistanceTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "3.2", keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    let kindOfMaterialTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "", keyboardType: .default, returnKey: .next)
        return sampleTextField
    }()
    
    let widthTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "", keyboardType: .numbersAndPunctuation, returnKey: .next)
        sampleTextField.isEnabled = false
        return sampleTextField
    }()
    
    let thermalConductivityTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "", keyboardType: .numbersAndPunctuation, returnKey: .done)
        return sampleTextField
    }()
    
    let normalizedWallResistanceLabel : UILabel = {
        let label = createLabelWith(text: "Rнорм, м²·°C/Вт")
        return label
    }()
    
    let kindOfMaterialLabel : UILabel = {
        let label = createLabelWith(text: "Материал")
        return label
    }()
    
    let widthLabel : UILabel = {
        let label = createLabelWith(text: "Рассчетная толщина, δ м")
        return label
    }()
    
    let thermalConductivityLablel : UILabel = {
        let label = createLabelWith(text: "Теплопроводность, λ")
        return label
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculationArray = calculationResult?.materialArray ?? []
        
        self.view.backgroundColor = .white
        if overwriteMainResult == false {
            self.createCalculationNameAlert()
        }
        
        self.navigationItem.title = "Теплоизоляция"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLayerAction(sander:)))
        
        if let calculation = calculationResult?.nameOfCalculation {
            self.name = calculation
        }
        
        if let norm = calculationResult?.normalizedWallResistance {
            normalizedWallResistanceTextField.text = String(norm)
        } else {
            normalizedWallResistanceTextField.text = "3.2"
        }
        
        if let kind = calculationResult?.insulationMaterial.name {
            kindOfMaterialTextField.text = kind
        } else {
            kindOfMaterialTextField.text = ""
        }
        
        if let thermal = calculationResult?.insulationMaterial.thermalConductivity {
            thermalConductivityTextField.text = String(thermal)
        } else {
            thermalConductivityTextField.text = ""
        }
        
        if let width = calculationResult?.insulationMaterial.width {
            let insulationWidth = Double(round(1000 * width)/1000)
            widthTextField.text = String(insulationWidth)
        }
    
        tableView.delegate = self
        tableView.dataSource = self
        
        layoutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        return line
    }
    
    private func createStackLine() -> [UIStackView] {
        
        let firstLine   = createStackViewWith(subviews: [normalizedWallResistanceLabel, normalizedWallResistanceTextField])
        let secondLine  = createStackViewWith(subviews: [kindOfMaterialLabel, kindOfMaterialTextField])
        let thirdLine   = createStackViewWith(subviews: [thermalConductivityLablel, thermalConductivityTextField])
        let fourth      = createStackViewWith(subviews: [widthLabel, widthTextField])
        
        return [firstLine, secondLine, thirdLine, fourth]
    }
    
    private func layoutSetup() {
        
        let textFieldAndLabelStackView = UIStackView(arrangedSubviews: createStackLine())
        view.addSubview(textFieldAndLabelStackView)
        textFieldAndLabelStackView.axis = .vertical
        textFieldAndLabelStackView.spacing = 10
        textFieldAndLabelStackView.distribution = .fillEqually
        textFieldAndLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldAndLabelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textFieldAndLabelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textFieldAndLabelStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textFieldAndLabelStackView.heightAnchor.constraint(equalToConstant: 200)
            ])
        
        let buttonStackView = createStackViewWith(subviews: [saveButton, calculationButton])
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textFieldAndLabelStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -10)
            ])
    }
    
    // MARK: - Actions
    
    @objc private func calculationAction(sender: UIButton) {
        
        let calculationName = self.name!
        let materialName = self.kindOfMaterialTextField.text!
        let thermalConductivity = Double(self.thermalConductivityTextField.text!)
        let normalizedWallResistance = Double(self.normalizedWallResistanceTextField.text!)
        
        if materialName != "" && thermalConductivity != nil && normalizedWallResistance != nil {
            self.calculationResult = EngeniringResult(calculationName: calculationName, thermalInsulationName: materialName, normalizedWallResistance: normalizedWallResistance!, materialArray: self.calculationArray, thermalInsulationConductivity: thermalConductivity!)
            
            let insulationWidth = Double(round(1000 * (self.calculationResult?.insulationMaterial.width)!)/1000)
            
            widthTextField.text = "\(insulationWidth)"
        } else {
            createCalculationAlert()
        }
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        if let result = self.calculationResult {
            self.delegate?.addCalculation(result: result, overwrite: overwriteMainResult!)
            dismiss(animated: true) {
                print(self.calculationResult!)
            }
        } else {
            createSaveAlert()
        }
    }
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true) {
            print("EnginiringCalculationTableViewController dismiss")
        }
    }
    
    @objc private func addLayerAction(sander: UIBarButtonItem) {
        let vc = EngeniringViewController()
        vc.delegate = self
        vc.needToOverwrite = false
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true) {
            print("EngeniringViewController create")
        }
    }
    
    // MARK: - Alerts
    
    private func createCalculationNameAlert() {
        
        let alertVC = UIAlertController(title: "Введите имя рассчета", message: nil, preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Введите имя"
        })
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            let textField = alertVC.textFields![0] as UITextField
            self.name = textField.text!
        })
        alertVC.addAction(submitAction)
        present(alertVC, animated: true) {
        }
    }
    
    private func createCalculationAlert() {
        
        let alertVC = UIAlertController(title: "Заполните все поля в текущем окне", message: nil, preferredStyle: .alert)

        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true) {
        }
    }
    
    private func createSaveAlert() {
        
        let alertVC = UIAlertController(title: "Нажмите кнопку <<Рассчет>>", message: nil, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true) {
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Состав ограждающей конструкции:"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Слоев: \(calculationArray.count)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "materialIdentifier"
        let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        let mat = calculationArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = mat.name
        cell.detailTextLabel?.text = "\(mat.width)"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.numberOfElement = indexPath.row
        let vc = EngeniringViewController()
        vc.delegate = self
        vc.material = calculationArray[indexPath.row]
        vc.needToOverwrite = true
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true) {
            print("EngeniringViewController opened")
        }
    }
    
    // MARK: - EngeniringViewControllerDelegate
    
    func addLayerInformation(layer: Material, overwrite: Bool) {
        if overwrite == true {
            self.calculationArray[numberOfElement!] = layer
        } else {
            self.calculationArray.append(layer)
        }
    }
}
