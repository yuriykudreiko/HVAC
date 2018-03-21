//
//  EngeniringCalculationViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 07.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol EngeniringCalculationViewControllerDelegate {
    func addCalculation(result: EngeniringResult)
}


class EngeniringCalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EngeniringViewControllerDelegate {

    // MARK: - Properties
    
    var delegate : EngeniringCalculationViewControllerDelegate?
    private var name : String?
    private var calculationArray : [Material] = []
    private var thermalInsulationMaterial : Material?
    var calculationResult : EngeniringResult?
    
    // MARK: - Items
    
    let calculationButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Рассчет", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(calculationAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let saveButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Save", for: .normal)
        buttom.backgroundColor = .blue
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttom.setTitleColor(.gray, for: .normal)
        //buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        return buttom
    }()
    
    let tableView : UITableView = {
        let myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return myTableView
    }()
    
    let normalizedWallResistanceTextField : UITextField = {
        let sampleTextField = UITextField()
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 14)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        sampleTextField.returnKeyType = UIReturnKeyType.next
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        return sampleTextField
    }()
    
    let kindOfMaterialTextField : UITextField = {
        let sampleTextField = UITextField()
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 14)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.next
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        return sampleTextField
    }()
    
    let widthTextField : UITextField = {
        let sampleTextField =  UITextField()
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 14)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        sampleTextField.returnKeyType = UIReturnKeyType.next
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return sampleTextField
    }()
    
    let thermalConductivityTextField : UITextField = {
        let sampleTextField = UITextField()
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .done
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    let normalizedWallResistanceLabel : UILabel = {
        let label = UILabel()
        label.text = "Норм. сопротивление, R"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let kindOfMaterialLabel : UILabel = {
        let label = UILabel()
        label.text = "Материал"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let widthLabel : UILabel = {
        let label = UILabel()
        label.text = "Рассчетная толщина, δ м"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let thermalConductivityLablel : UILabel = {
        let label = UILabel()
        label.text = "Теплопроводность, λ"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculationArray = calculationResult?.materialArray ?? []
        
        self.view.backgroundColor = .white
        self.createAlert()
        
        self.navigationItem.title = "Теплоизоляция"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLayerAction(sander:)))
        
        normalizedWallResistanceTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 100, width: 150, height: 40)
        if let norm = calculationResult?.normalizedWallResistance {
            normalizedWallResistanceTextField.text = String(norm)
        }
        
        kindOfMaterialTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 150, width: 150, height: 40)
        if let kind = calculationResult?.insulationMaterial.name {
            kindOfMaterialTextField.text = kind
        }
        
        thermalConductivityTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 200, width: 150, height: 40)
        if let thermal = calculationResult?.insulationMaterial.thermalConductivity {
            thermalConductivityTextField.text = String(thermal)
        }
        
        widthTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 250, width: 150, height: 40)
        if let width = calculationResult?.insulationMaterial.width {
            widthTextField.text = String(width)
        }
        
        self.view.addSubview(normalizedWallResistanceTextField)
        self.view.addSubview(kindOfMaterialTextField)
        self.view.addSubview(widthTextField)
        self.view.addSubview(thermalConductivityTextField)
        
        normalizedWallResistanceLabel.frame = CGRect(x: 20, y: 100, width: 200, height: 40)
        kindOfMaterialLabel.frame =         CGRect(x: 20, y: 150, width: 200, height: 40)
        thermalConductivityLablel.frame =   CGRect(x: 20, y: 200, width: 200, height: 40)
        widthLabel.frame =                  CGRect(x: 20, y: 250, width: 200, height: 40)
        
        self.view.addSubview(normalizedWallResistanceLabel)
        self.view.addSubview(kindOfMaterialLabel)
        self.view.addSubview(widthLabel)
        self.view.addSubview(thermalConductivityLablel)
        
        tableView.frame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: self.view.bounds.height - 400)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        saveButton.frame = CGRect(x: self.view.bounds.width/2 - 50, y: self.view.bounds.height - 90, width: 100, height: 50)
        self.view.addSubview(saveButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions
    
    @objc private func calculationAction(sender: UIButton) {
        
        var sum = 1/8.7 + 1/23
        
        for layer in calculationArray {
            sum += (layer.width / layer.thermalConductivity)
        }
        let R = Double(normalizedWallResistanceTextField.text!) ?? 3.2
        let λ = Double(thermalConductivityTextField.text!)!
        
        let insulationWidth = (R - sum) * λ
        
        let x = insulationWidth
        let y = Double(round(1000*x)/1000)
        
        widthTextField.text = "\(y)"
        
        thermalInsulationMaterial = Material(name: self.kindOfMaterialTextField.text!, width: insulationWidth, thermalConductivity: Double(self.thermalConductivityTextField.text!)!)
        self.calculationResult = EngeniringResult(nameOfCalculation: self.name!, normalizedWallResistance: Double(self.normalizedWallResistanceTextField.text!)!, materialArray: self.calculationArray, insulationMaterial: thermalInsulationMaterial!)
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        self.delegate?.addCalculation(result: self.calculationResult!)
        
        dismiss(animated: true) {
            print(self.calculationResult!)
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
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true) {
            print("EngeniringViewController create")
        }
    }
    
    // MARK: - Help methods
    
    private func createAlert() {
        
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationArray.count
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
        footerView.backgroundColor = UIColor(red: 73, green: 154, blue: 245, alpha: 1)
        calculationButton.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50)
        footerView.addSubview(calculationButton)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EngeniringViewController()
        vc.material = calculationArray[indexPath.row]
        present(vc, animated: true) {
            print("EngeniringViewController opened")
        }
    }
    
    // MARK: - EngeniringViewControllerDelegate
    
    func addLayerInformation(layer: Material) {
        self.calculationArray.append(layer)
    }
}
