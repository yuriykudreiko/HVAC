//
//  HeatLossCalculationViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 15.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol HeatLossCalculationViewControllerDelegate {
    
}

class HeatLossCalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewConstructionViewControllerDelegate {

    // MARK: - Properties
    
    var delegate : HeatLossCalculationViewControllerDelegate?
    private var calculationName : String?
    private var calculationArray : [Construction] = []
    var calculationResult : HeatLossResult?
    
    // MARK: - Items

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
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HeatLossCell")
        return myTableView
    }()
    
    private let outdoorTemperatureTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "-24"
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .next
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    private let outdoorTemperatureLablel : UILabel = {
        
        let label = UILabel()
        label.text = "Наружная температура,°C"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let indoorTemperatureTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "18"
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .next
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    private let indoorTemperatureLablel : UILabel = {
        
        let label = UILabel()
        label.text = "Внутренняя температура, °C"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let wallResistanceTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "3.2"
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .next
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    private let wallResistanceLablel : UILabel = {
        
        let label = UILabel()
        label.text = "R стены, м²·°C/Вт"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let windowResistanceTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "1"
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .next
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    private let windowResistanceLablel : UILabel = {
        
        let label = UILabel()
        label.text = "R окна, м²·°C/Вт"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    private let ceilingResistanceTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "6"
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = .systemFont(ofSize: 14)
        sampleTextField.borderStyle = .roundedRect
        sampleTextField.autocorrectionType = .no
        sampleTextField.keyboardType = .numbersAndPunctuation
        sampleTextField.returnKeyType = .next
        sampleTextField.clearButtonMode = .whileEditing
        sampleTextField.contentVerticalAlignment = .center
        sampleTextField.contentHorizontalAlignment = .center
        return sampleTextField
    }()
    
    private let ceilingResistanceLablel : UILabel = {
        
        let label = UILabel()
        label.text = "R покрытия, м²·°C/Вт"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let flourResistanceTextField : UITextField = {
        
        let sampleTextField = UITextField()
        sampleTextField.text = "2.5"
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
    
    private let flourResistanceLablel : UILabel = {
        
        let label = UILabel()
        label.text = "R пола, м²·°C/Вт"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if calculationResult == nil {
            
            let outTemp = Double(outdoorTemperatureTextField.text!)!
            let indTemp = Double(indoorTemperatureTextField.text!)!
            let wallRes = Double(wallResistanceTextField.text!)!
            let windowRes = Double(windowResistanceTextField.text!)!
            let ceilingRes = Double(ceilingResistanceTextField.text!)!
            let flourRes = Double(flourResistanceTextField.text!)!

            calculationResult = HeatLossResult(indoorTemperature: indTemp, outdoorTemperature: outTemp, wallResistance: wallRes, windowResistance: windowRes, ceilingResistance: ceilingRes, flourResistance: flourRes)
        }
        
        
        self.view.backgroundColor = .white
        self.createAlert()
        
        self.navigationItem.title = "Теплоизоляция"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addConstructionAction(sander:)))
        
        outdoorTemperatureTextField.frame   = CGRect(x: view.bounds.width - 130 - 20, y: 100, width: 130, height: 40)
        indoorTemperatureTextField.frame    = CGRect(x: view.bounds.width - 130 - 20, y: 150, width: 130, height: 40)
        wallResistanceTextField.frame       = CGRect(x: view.bounds.width - 130 - 20, y: 200, width: 130, height: 40)
        windowResistanceTextField.frame     = CGRect(x: view.bounds.width - 130 - 20, y: 250, width: 130, height: 40)
        ceilingResistanceTextField.frame    = CGRect(x: view.bounds.width - 130 - 20, y: 300, width: 130, height: 40)
        flourResistanceTextField.frame      = CGRect(x: view.bounds.width - 130 - 20, y: 350, width: 130, height: 40)
        
        self.view.addSubview(outdoorTemperatureTextField)
        self.view.addSubview(indoorTemperatureTextField)
        self.view.addSubview(wallResistanceTextField)
        self.view.addSubview(windowResistanceTextField)
        self.view.addSubview(ceilingResistanceTextField)
        self.view.addSubview(flourResistanceTextField)


        outdoorTemperatureLablel.frame  = CGRect(x: 10, y: 100, width: 210, height: 40)
        indoorTemperatureLablel.frame   = CGRect(x: 10, y: 150, width: 210, height: 40)
        wallResistanceLablel.frame      = CGRect(x: 10, y: 200, width: 210, height: 40)
        windowResistanceLablel.frame    = CGRect(x: 10, y: 250, width: 210, height: 40)
        ceilingResistanceLablel.frame   = CGRect(x: 10, y: 300, width: 210, height: 40)
        flourResistanceLablel.frame     = CGRect(x: 10, y: 350, width: 210, height: 40)
        
        self.view.addSubview(outdoorTemperatureLablel)
        self.view.addSubview(indoorTemperatureLablel)
        self.view.addSubview(wallResistanceLablel)
        self.view.addSubview(windowResistanceLablel)
        self.view.addSubview(ceilingResistanceLablel)
        self.view.addSubview(flourResistanceLablel)

        tableView.frame = CGRect(x: 0, y: 400, width: self.view.bounds.width, height: self.view.bounds.height - 400)
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

    }
    
    @objc private func saveAction(sender: UIButton) {
        
        //self.delegate?.addCalculation(result: self.calculationResult!)
        
        dismiss(animated: true) {
            print(self.calculationResult!)
        }
    }
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true) {
            print("EnginiringCalculationTableViewController dismiss")
        }
    }
    
    @objc private func addConstructionAction(sander: UIBarButtonItem) {
        let vc = AddNewConstructionViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true) {
            print("AddNewConstructionViewController create")
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
            self.calculationName = textField.text!
            self.navigationItem.title = self.calculationName
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
        let vc = EngeniringViewController()
        //vc.material = calculationArray[indexPath.row]
        present(vc, animated: true) {
            print("EngeniringViewController opened")
        }
    }
    
    // MARK: - AddNewConstructionViewControllerDelegate
    
    func addNewConstructionWith(name: String, orientation: String, square: Double) {
        
        let newConstruction = calculationResult?.calculateConstructionWith(name: name, square: square, orientation: orientation)
        calculationResult?.constructionArray.append(newConstruction!)
    }
}
