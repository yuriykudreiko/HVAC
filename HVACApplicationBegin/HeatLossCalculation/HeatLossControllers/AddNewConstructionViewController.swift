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
    func addNewConstructionWith(name: String, orientation: String, square: Double, overwrite: Bool)
}

class AddNewConstructionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties
    
    var delegate : AddNewConstructionViewControllerDelegate?
    var currentConstruction : Construction?
    var overwrite : Bool = false
    
    private var orientationAndNameArray = [["св", "с", "сз", "з", "юз", "ю", "юв", "в"], ["Стена", "Окно", "Дверь", "Пол", "Покрытие"]]
    
    // MARK: - Items
    
    private let orientationAndNamePickerView : UIPickerView = {
        let typePickerView = UIPickerView()
        typePickerView.backgroundColor = .white
        typePickerView.translatesAutoresizingMaskIntoConstraints = false
        return typePickerView
    }()
    
    private let nameLabel : UILabel = {
        let label = createLabelWith(text: "Наименование")
        return label
    }()
    
    private let orientationLabel : UILabel = {
        let label = createLabelWith(text: "Ориентация")
        return label
    }()
    
    private let squareTextField : UITextField = {
        let sampleTextField = createTextFieldWith(text: "", placeholder: "", keyboardType: .default, returnKey: .done)
        return sampleTextField
    }()
    
    private let squareLabel : UILabel = {
        let label = createLabelWith(text: "Площадь, м²")
        return label
    }()
    
    private let saveButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Save", for: .normal)
        buttom.backgroundColor = .red
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttom.setTitleColor(.gray, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return buttom
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let square = currentConstruction?.square {
            squareTextField.text = String(square)
        }

        orientationAndNamePickerView.dataSource = self
        orientationAndNamePickerView.delegate = self
        layoutSetup()
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let orientation = currentConstruction?.orientation {
            if let index = orientationAndNameArray[0].index(of: orientation) {
                orientationAndNamePickerView.selectRow(index, inComponent: 0, animated: true)
                orientationAndNamePickerView.reloadAllComponents()
            }
        }
        
        if let constructionName = currentConstruction?.name {
            if let index = orientationAndNameArray[1].index(of: constructionName) {
                orientationAndNamePickerView.selectRow(index, inComponent: 1, animated: true)
                orientationAndNamePickerView.reloadAllComponents()
            }
        }
    }

    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        return line
    }
    
    private func createStackLine() -> [UIStackView] {
        
        let firstLine = createStackViewWith(subviews: [squareLabel, squareTextField])
        let secondLine = createStackViewWith(subviews: [orientationLabel, nameLabel])
        return [firstLine, secondLine]
    }
    
    private func layoutSetup() {
        
        let myStackView = UIStackView(arrangedSubviews: createStackLine())
        view.addSubview(myStackView)
        myStackView.axis = .vertical
        myStackView.spacing = 10
        myStackView.distribution = .fillEqually
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            myStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            myStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            myStackView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(orientationAndNamePickerView)
        NSLayoutConstraint.activate([
            orientationAndNamePickerView.topAnchor.constraint(equalTo: myStackView.bottomAnchor, constant: 10),
            orientationAndNamePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            orientationAndNamePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            orientationAndNamePickerView.heightAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    // MARK: - Alert
    
    private func createSaveAlert() {
        
        let alertVC = UIAlertController(title: "Введите корректное значение(число) в поле <<Площадь>>", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        let row1 = self.orientationAndNamePickerView.selectedRow(inComponent: 0)
        let row2 = self.orientationAndNamePickerView.selectedRow(inComponent: 1)
        
        let orientation = self.orientationAndNameArray[0][row1]
        let constructionName = self.orientationAndNameArray[1][row2]

        if let square = Double(squareTextField.text!) {
            self.delegate?.addNewConstructionWith(name: constructionName, orientation: orientation, square: square, overwrite: overwrite)
            dismiss(animated: true)
        } else {
            createSaveAlert()
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
}
