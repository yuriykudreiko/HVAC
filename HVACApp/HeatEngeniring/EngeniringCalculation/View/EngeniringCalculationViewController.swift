//
//  EngeniringCalculationViewController.swift
//  HVACApp
//
//  Created by User3 on 07.03.2018.
//  Copyright © 2018 Yury Kudreika. All rights reserved.
//

import SwiftUI

protocol EngeniringCalculationViewControllerDelegate {
    func addCalculation(result: EngeniringResult, overwrite: Bool)
}

class EngeniringCalculationViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: EngeniringCalculationViewControllerDelegate?
    private let viewModel: EngeniringCalculationViewModel
    
    private let cellIdentifier = "materialCellIdentifier"

    // MARK: - Items
    
    let calculationButton: UIButton = {
        return createButton(text: "Расчет", color: .turquoise)
    }()
    
    let saveButton: UIButton = {
        return createButton(text: "Сохранить", color: .lightGreen)
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let normalizedWallResistanceTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "3.2",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    let kindOfMaterialTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "",
            placeholder: "",
            keyboardType: .default,
            returnKey: .next
        )
        return sampleTextField
    }()
    
    let widthTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .next
        )
        sampleTextField.isEnabled = false
        return sampleTextField
    }()
    
    let thermalConductivityTextField: UITextField = {
        let sampleTextField = createTextFieldWith(
            text: "",
            placeholder: "",
            keyboardType: .numbersAndPunctuation,
            returnKey: .done
        )
        return sampleTextField
    }()
    
    let normalizedWallResistanceLabel: UILabel = {
        return createLabelWith(text: "Rнорм, м²·°C/Вт")
    }()
    
    let kindOfMaterialLabel: UILabel = {
        return createLabelWith(text: "Материал")
    }()
    
    let widthLabel: UILabel = {
        return createLabelWith(text: "Расчетная толщина, δ м")
    }()
    
    let thermalConductivityLablel: UILabel = {
        return createLabelWith(text: "Теплопроводность, λ")
    }()
    
    // MARK: - Initialization
    
    init(viewModel: EngeniringCalculationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Теплоизоляция"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(sender:))
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addLayerAction(sander:))
        )
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        calculationButton.addTarget(
            self,
            action: #selector(calculationAction(sender:)),
            for: .touchUpInside
        )
        saveButton.addTarget(
            self,
            action: #selector(saveAction(sender:)),
            for: .touchUpInside
        )
        
        layoutSetup()
    }
    
    private func setupBindings() {
        viewModel.delegate = delegate
        
        // Bind text fields
        normalizedWallResistanceTextField.text = viewModel.normalizedWallResistance
        kindOfMaterialTextField.text = viewModel.materialName
        thermalConductivityTextField.text = viewModel.thermalConductivity
        widthTextField.text = viewModel.insulationWidth
        
        // Bind alerts
        viewModel.$shouldShowCalculationAlert
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.createCalculationAlert()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$shouldShowSaveAlert
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.createSaveAlert()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$shouldShowNameAlert
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.createCalculationNameAlert()
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Layout
    
    private func createStackViewWith(subviews: [UIView]) -> UIStackView {
        let line = UIStackView(arrangedSubviews: subviews)
        line.distribution = .fillEqually
        line.spacing = 10
        
        return line
    }
    
    private func createStackLine() -> [UIStackView] {
        let firstLine = createStackViewWith(subviews: [normalizedWallResistanceLabel, normalizedWallResistanceTextField])
        let secondLine = createStackViewWith(subviews: [kindOfMaterialLabel, kindOfMaterialTextField])
        let thirdLine = createStackViewWith(subviews: [thermalConductivityLablel, thermalConductivityTextField])
        let fourth = createStackViewWith(subviews: [widthLabel, widthTextField])
        
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
        viewModel.normalizedWallResistance = normalizedWallResistanceTextField.text ?? ""
        viewModel.materialName = kindOfMaterialTextField.text ?? ""
        viewModel.thermalConductivity = thermalConductivityTextField.text ?? ""
        viewModel.performCalculation()
    }
    
    @objc private func saveAction(sender: UIButton) {
        viewModel.saveCalculation()
    }
    
    @objc private func cancelButtonAction(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func addLayerAction(sander: UIBarButtonItem) {
        let viewModel = MaterialsViewModel()
        
        viewModel.onMaterialSelect = { [weak self] (materialModel, width) in
            let material = Material(name: materialModel.name, width: width, thermalConductivity: materialModel.thermalConductivity.b)
            self?.add(material: material, updateExistingElement: false)
        }
        
        let view = MaterialsView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
    
    // MARK: - Alerts
    
    private func createCalculationNameAlert() {
        let alertVC = UIAlertController(title: "Введите имя рассчета", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите имя"
        }
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self] (alertAction) in
            let textField = alertVC.textFields![0] as UITextField
            self?.viewModel.setName(textField.text ?? "")
        }
        
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
    private func createCalculationAlert() {
        let alertVC = UIAlertController(title: "Заполните все поля в текущем окне", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
    private func createSaveAlert() {
        let alertVC = UIAlertController(title: "Нажмите кнопку <<Рассчет>>", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension EngeniringCalculationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.materialArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Состав ограждающей конструкции:"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.layerCountString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let material = viewModel.materialArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = material.name
        cell.detailTextLabel?.text = "\(material.width) мм"
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.performBatchUpdates {
                viewModel.removeMaterial(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.footerView(forSection: 0)?.textLabel?.text = viewModel.layerCountString
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - UITableViewDelegate

extension EngeniringCalculationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.setSelectedElement(indexPath.row)
        
        let viewController = EngeniringViewController()
        viewController.delegate = self
        viewController.preselectedMaterial = viewModel.materialArray[indexPath.row]
        viewController.updateExistingElement = true
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

// MARK: - EngeniringViewControllerDelegate

extension EngeniringCalculationViewController: EngeniringViewControllerDelegate {
    
    func add(material: Material, updateExistingElement: Bool) {
        tableView.performBatchUpdates {
            viewModel.addMaterial(material, updateExistingElement: updateExistingElement)
            
            if updateExistingElement, let row = viewModel.numberOfElement {
                tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            } else {
                tableView.insertRows(at: [IndexPath(row: viewModel.materialArray.count - 1, section: 0)], with: .automatic)
                tableView.footerView(forSection: 0)?.textLabel?.text = viewModel.layerCountString
            }
        }
    }
}
