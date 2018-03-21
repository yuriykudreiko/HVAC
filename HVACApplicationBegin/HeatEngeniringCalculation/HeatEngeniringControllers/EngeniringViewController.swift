//
//  EngeniringViewController.swift
//  HVACApplicationBegin
//
//  Created by User3 on 06.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import UIKit


protocol EngeniringViewControllerDelegate {
    func addLayerInformation(layer: Material)
}

class EngeniringViewController: UIViewController {

    var delegate : EngeniringViewControllerDelegate?
    
    var kind : String = "Введите название материала"
    var width : Double?
    var thermal : Double?
    var material : Material?
    
    // MARK: - Items
    
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
    
    let kindOfMaterialLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Материал"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let widthLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Толщина, δ м"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let thermalConductivityLablel : UILabel = {
        
        let label = UILabel()
        label.text = "Теплопроводность, λ"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let saveButton : UIButton = {
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
        
        saveButton.frame = CGRect(x: view.bounds.width/2 - 50, y: view.bounds.height - 100, width: 100, height: 50)
        self.view.addSubview(saveButton)
        
        kindOfMaterialTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 100, width: 150, height: 40)
        if let name = material?.name {
            kindOfMaterialTextField.text = name
        }
        
        widthTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 150, width: 150, height: 40)
        if let w = material?.width {
            widthTextField.text = String(w)
        }
        
        thermalConductivityTextField.frame = CGRect(x: view.bounds.width - 150 - 20, y: 200, width: 150, height: 40)
        
        if let thermal = material?.thermalConductivity {
            thermalConductivityTextField.text = String(thermal)
        }
        
        self.view.addSubview(kindOfMaterialTextField)
        self.view.addSubview(widthTextField)
        self.view.addSubview(thermalConductivityTextField)
        
        kindOfMaterialLabel.frame =         CGRect(x: 20, y: 100, width: 200, height: 40)
        widthLabel.frame =                  CGRect(x: 20, y: 150, width: 200, height: 40)
        thermalConductivityLablel.frame =   CGRect(x: 20, y: 200, width: 200, height: 40)
        
        self.view.addSubview(kindOfMaterialLabel)
        self.view.addSubview(widthLabel)
        self.view.addSubview(thermalConductivityLablel)
        
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(sender:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            print("EngeniringViewController dismiss")
        }
    }
    
    @objc private func saveAction(sender: UIButton) {
        
        self.kind = kindOfMaterialTextField.text!
        if let k = kindOfMaterialTextField.text {
            if k == "" {
                kind = "Введите название материала"
            }
        }
        
        self.width = Double(widthTextField.text!)
        self.thermal = Double(thermalConductivityTextField.text!)
        
        self.material = Material(name: self.kind, width: self.width ?? 0, thermalConductivity: self.thermal ?? 0)
        self.delegate?.addLayerInformation(layer: self.material!)
        
        dismiss(animated: true) {
            print(self.material!)
        }
    }
}
