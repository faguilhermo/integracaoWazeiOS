//
//  MainViewController.swift
//  integracaoWazeiOS
//
//  Created by Fabrício Guilhermo on 26/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var addressTextField: UITextField = {
        let addressTextField = UITextField(frame: .zero)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.placeholder = "Destination address"
        addressTextField.textContentType = .telephoneNumber
        addressTextField.clearButtonMode = .always
        addressTextField.delegate = self

        return addressTextField
    }()

    private lazy var searchAddressOnWazeButton: UIButton = {
        let searchAddressOnWazeButton = UIButton(type: .roundedRect)
        searchAddressOnWazeButton.translatesAutoresizingMaskIntoConstraints = false
        searchAddressOnWazeButton.setTitle("Traçar rota no Waze", for: .normal)
        searchAddressOnWazeButton.layer.cornerRadius = 35
        searchAddressOnWazeButton.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        searchAddressOnWazeButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        searchAddressOnWazeButton.addTarget(self, action: #selector(searchAddressInWazeButton(_ :)), for: .touchUpInside)
        

        return searchAddressOnWazeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(addressTextField)
        view.addSubview(searchAddressOnWazeButton)

        autoLayout()
    }

    @objc private func searchAddressInWazeButton(_ sender: UIButton) {
        guard let url = URL(string: "waze://") else { return }
        // Verifing if waze exists on this device.
        if UIApplication.shared.canOpenURL(url) {
            guard let address = addressTextField.text else { return }
            Localization().convertAddressToCoordinates(address) { (foundLocalization) in
                let latitude = String(describing: foundLocalization.location!.coordinate.latitude)
                let longitude = String(describing: foundLocalization.location!.coordinate.longitude)
                let url: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                guard let wazeUrlToAddress = URL(string: url) else { return }
                UIApplication.shared.open(wazeUrlToAddress, options: [:], completionHandler: nil)
            }
        } else {
            // treat error showing an alert, for exemple.
            print("Waze does not exists on this device")
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension MainViewController {
    private func autoLayout() {
        addressTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addressTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
        addressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        searchAddressOnWazeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchAddressOnWazeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        searchAddressOnWazeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        searchAddressOnWazeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
}
