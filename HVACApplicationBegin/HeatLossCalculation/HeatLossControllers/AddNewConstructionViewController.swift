//
//  AddNewConstructionViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 15.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

//Q = A(tp − text)(1 + ∑β)n/Rт, (Ж.1)
//где
//А — расчетная площадь ограждающей конструкции, м2;
//Rт — сопротивление теплопередаче ограждающей конструкции, м2 · °С/Вт определяемое по СНБ 2.04.01 (кроме полов на грунте); для полов на грунте — в соответствии с Ж.3, принимая Rт = Rс — для неутепленных полов и Rт = Rh — для утепленных;
//tp — расчетная температура воздуха в помещении, °С, с учетом повышения ее в зависи- мости от высоты для помещений высотой более 4 м;
//text — расчетная температура наружного воздуха для холодного периода года при расчете потерь теплоты через наружные ограждающие конструкции или температура воздуха более холодного помещения — при расчете потерь теплоты через внутренние ограж- дающие конструкции, °C;
//β — добавочные потери теплоты в долях от основных потерь, определяемые в соответ- ствии с Ж.2;
//n — коэффициент, принимаемый по СНБ 2.04.01 в зависимости от положения наружной поверхности ограждающих конструкций по отношению к наружному воздуху.

//var square : Double +
//var heatResistance : Double
//var outdoorTemperature : Double
//var indoorTemperature : Double
//var additionalHeaLoss : Double
//var coefficientN : Double
//var heatLoss : Double

protocol AddNewConstructionViewControllerDelegate {
    func addNewConstructionWith(name: String, orientation: String, square: Double)
}

class AddNewConstructionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    var delegate : AddNewConstructionViewControllerDelegate?
    var currentConstruction : Construction?
    private var orientationAndNameArray = [["св", "с", "сз", "з", "юз", "ю", "юв", "в"], ["Стена", "Окно", "Дверь", "Пол", "Покрытие"]]
    private var orientation : String?
    private var constructionName : String?
    private var square : Double?
    
    // MARK: - Items
    
    private let orientationAndNamePickerView : UIPickerView = {
        let typePickerView = UIPickerView()
        typePickerView.backgroundColor = .white
        return typePickerView
    }()
    
    private let nameLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Наименование"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let orientationLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Ориентация"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let squareTextField : UITextField = {
        
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
    
    private let squareLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Площадь, м²"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let heatResistanceTextField : UITextField = {
        
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
    
    private let heatResistanceLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Термическое сопротивление, Rт"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    

    
    private let saveButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Save", for: .normal)
        buttom.backgroundColor = .red
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttom.setTitleColor(.gray, for: .normal)
        //buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return buttom
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        squareTextField.frame = CGRect(x: view.bounds.width - 130 - 20, y: 230, width: 130, height: 40)
//        if let square = currentConstruction?.square {
//            squareTextField.text = String(square)
//        }
//
//        heatResistanceTextField.frame = CGRect(x: view.bounds.width - 130 - 20, y: 150, width: 130, height: 40)
//        if let heatRes = currentConstruction?.heatResistance {
//            heatResistanceTextField.text = String(heatRes)
//        }
        orientationAndNamePickerView.frame = CGRect(x: 10, y: 140, width: self.view.bounds.width - 20, height: 80)
        orientationAndNamePickerView.dataSource = self
        orientationAndNamePickerView.delegate = self

//        self.view.addSubview(heatResistanceTextField)
        self.view.addSubview(orientationAndNamePickerView)
        self.view.addSubview(squareTextField)

        orientationLabel.frame    = CGRect(x: 10, y: 100, width: self.view.bounds.width/2 - 20, height: 40)
        nameLabel.frame = CGRect(x: view.bounds.width/2 + 10, y: 100, width: self.view.bounds.width/2 - 20, height: 40)
        squareLabel.frame         = CGRect(x: 10, y: 230, width: self.view.bounds.width/2 - 20, height: 40)
//        heatResistanceLabel.frame = CGRect(x: 10, y: 150, width: 210, height: 40)

        self.view.addSubview(squareLabel)
//        self.view.addSubview(heatResistanceLabel)
        self.view.addSubview(orientationLabel)
        self.view.addSubview(nameLabel)
        
        saveButton.frame = CGRect(x: view.bounds.width/2 - 50, y: view.bounds.height - 100, width: 100, height: 50)
        self.view.addSubview(saveButton)
        
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            print("AddNewConstructionViewController dismiss")
            let row1 = self.orientationAndNamePickerView.selectedRow(inComponent: 0)
            let row2 = self.orientationAndNamePickerView.selectedRow(inComponent: 1)
            self.orientation = self.orientationAndNameArray[0][row1]
            self.constructionName = self.orientationAndNameArray[1][row2]
            
            print(self.orientation!)
            print(self.constructionName!)

        }
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        let row1 = self.orientationAndNamePickerView.selectedRow(inComponent: 0)
        let row2 = self.orientationAndNamePickerView.selectedRow(inComponent: 1)
        self.orientation = self.orientationAndNameArray[0][row1]
        self.constructionName = self.orientationAndNameArray[1][row2]
        self.square = Double(squareTextField.text!)!
        print("\(self.square!)")
        print("\(self.orientation!)")
        print("\(self.constructionName!)")
        
        self.delegate?.addNewConstructionWith(name: self.constructionName!, orientation: self.orientation!, square: self.square!)
        
        dismiss(animated: true) {
            print("AddNewConstructionViewController save and dismiss")
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return orientationAndNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orientationAndNameArray[component].count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orientationAndNameArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.orientation = orientationAndNameArray[component][row]
        } else {
            self.constructionName = orientationAndNameArray[component][row]
        }
        
    }

}
