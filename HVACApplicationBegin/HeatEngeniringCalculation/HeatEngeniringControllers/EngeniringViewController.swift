//
//  EngeniringViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 06.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit

protocol EngeniringViewControllerDelegate {
    func addLayerInformation(layer: Material, overwrite: Bool)
}

class EngeniringViewController: UIViewController {

    // MARK: - Static constants and functions
    
    static private let myFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    static private func createTextFieldWith(keyboardType: UIKeyboardType, returnKey: UIReturnKeyType) -> UITextField {
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
    
    // MARK: - Properties
    
    var delegate : EngeniringViewControllerDelegate?
    var material : Material?
    var needToOverwrite : Bool?
    
    // MARK: - Items
    
    private let kindOfMaterialTextField : UITextField = {
        let sampleTextField = createTextFieldWith(keyboardType: .default, returnKey: .next)
        return sampleTextField
    }()
    
    private let widthTextField : UITextField = {
        let sampleTextField = createTextFieldWith(keyboardType: .numbersAndPunctuation, returnKey: .next)
        return sampleTextField
    }()
    
    private let thermalConductivityTextField : UITextField = {
        let sampleTextField = createTextFieldWith(keyboardType: .numbersAndPunctuation, returnKey: .done)
        return sampleTextField
    }()
    
    private let kindOfMaterialLabel : UILabel = {
        let label = createLabelWith(text: "Материал")
        return label
    }()
    
    private let widthLabel : UILabel = {
        let label = createLabelWith(text: "Толщина, δ м")
        return label
    }()
    
    private let thermalConductivityLablel : UILabel = {
        let label = createLabelWith(text: "Теплопроводность, λ")
        return label
    }()
    
    private let saveButton : UIButton = {
        let buttom = UIButton(type: .system)
        buttom.setTitle("Save", for: .normal)
        buttom.backgroundColor = .red
        buttom.layer.cornerRadius = 10
        buttom.titleLabel?.font = myFont
        buttom.setTitleColor(.gray, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return buttom
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = material?.name {
            kindOfMaterialTextField.text = name
        } else {
            kindOfMaterialTextField.text = ""
        }
        
        if let width = material?.width {
            widthTextField.text = String(width)
        } else {
            widthTextField.text = ""
        }
        
        if let thermalConductivity = material?.thermalConductivity {
            thermalConductivityTextField.text = String(thermalConductivity)
        } else {
            thermalConductivityTextField.text = ""
        }
        
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        
        layoutSetup()
        buttonLayoutSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            myStackView.heightAnchor.constraint(equalToConstant: 150)
            ])
    }

    private func buttonLayoutSetup() {
        
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
        dismiss(animated: true) {
            print("EngeniringViewController dismiss")
        }
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        let kind = kindOfMaterialTextField.text!
        let width = Double(widthTextField.text!)
        let thermalConductivity = Double(thermalConductivityTextField.text!)
        
        if kind != "" && width != nil && thermalConductivity != nil {
            
            self.material = Material(name: kind, width: width!, thermalConductivity: thermalConductivity!)
            self.delegate?.addLayerInformation(layer: self.material!, overwrite: needToOverwrite!)
            dismiss(animated: true) {
                print(self.material!)
            }
        } else {
            createAlert()
        }
    }
    
    // MARK: - Alert
    
    private func createAlert() {
        
        let alertVC = UIAlertController(title: "Правильно заполните все поля в отекущем окне", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true) {
        }
    }
}
