//
//  EngeniringViewController.swift
//  HVACApp
//
//  Created by User3 on 06.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol EngeniringViewControllerDelegate {
    func add(material: Material, updateExistingElement: Bool)
}

class EngeniringViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: EngeniringViewControllerDelegate?
    var preselectedMaterial: Material?
    var updateExistingElement = false
    
    // MARK: - Items
    
    private let kindOfMaterialTextField: UITextField = {
        return createTextFieldWith(
            text: "",
            placeholder: "Материал",
            keyboardType: .default,
            returnKey: .next
        )
    }()
    
    private let widthTextField: UITextField = {
        return createTextFieldWith(
            text: "",
            placeholder: "Толщина, мм",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
    }()
    
    private let thermalConductivityTextField: UITextField = {
        return createTextFieldWith(
            text: "",
            placeholder: "Теплопроводность",
            keyboardType: .numbersAndPunctuation,
            returnKey: .done
        )
    }()
    
    private let kindOfMaterialLabel: UILabel = {
        return createLabelWith(text: "Материал")
    }()
    
    private let widthLabel: UILabel = {
        return createLabelWith(text: "Толщина, δ м")
    }()
    
    private let thermalConductivityLablel: UILabel = {
        return createLabelWith(text: "Теплопроводность, λ")
    }()
    
    private let saveButton: UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Сохранить", for: .normal)
        buttom.backgroundColor = .red
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = myFont
        buttom.setTitleColor(.gray, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        
        return buttom
    }()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        if let material = preselectedMaterial {
            kindOfMaterialTextField.text = material.name
            widthTextField.text = String(material.width)
            thermalConductivityTextField.text = String(material.thermalConductivity)
        }
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(sender:))
        )
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        
        return line
    }
    
    private func createStackLine() -> [UIStackView] {
        let firstLine = createStackViewWith(subviews: [kindOfMaterialLabel, kindOfMaterialTextField])
        let secondLine = createStackViewWith(subviews: [widthLabel, widthTextField])
        let thirdLine = createStackViewWith(subviews: [thermalConductivityLablel, thermalConductivityTextField])
        
        return [firstLine, secondLine, thirdLine]
    }
    
    private func setupLayout() {
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
            myStackView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveAction(sender: UIButton) {
        guard
            let kind = kindOfMaterialTextField.text,
            let widthString = widthTextField.text,
            let thermalConductivityString = thermalConductivityTextField.text,
            let width = Double(widthString),
            let thermalConductivity = Double(thermalConductivityString)
        else {
            createAlert()
            return
        }
        
        let material = Material(name: kind, width: width, thermalConductivity: thermalConductivity)
        
        dismiss(animated: true) {
            self.delegate?.add(material: material, updateExistingElement: self.updateExistingElement)
        }
    }
    
    // MARK: - Alert
    
    private func createAlert() {
        let alertVC = UIAlertController(title: "Правильно заполните все поля в отекущем окне", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
}
