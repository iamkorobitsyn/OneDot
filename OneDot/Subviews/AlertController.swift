//
//  AlertController.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.09.2023.
//

import UIKit

class CustomAlert: UIAlertController {
    
    convenience init(title: String, message: String, style: UIAlertController.Style, url: String) {
        self.init(title: title, message: message, preferredStyle: style)
        
        let settingsButton = UIAlertAction(title: "Settings", style: .destructive) { action in
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        self.addAction(settingsButton)
        self.addAction(cancelAction)
    }
    
    convenience init(title: String, message: String, style: UIAlertController.Style, function: @escaping() -> Void) {
        self.init(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            function()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        self.addAction(okAction)
        self.addAction(cancelAction)
    }
}

class CustomAlertViewController: UIViewController {
    
    var message: String
    var titleText: String
    var onOkTapped: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    init(title: String, message: String) {
        self.titleText = title
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupAlertView()
    }
    
    private func setupAlertView() {
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 10
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        
        // Центрируем alert в экране
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Настройка заголовка
        titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        // Настройка сообщения
        messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(messageLabel)
        
        // Настройка кнопок
        okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(okButton)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(cancelButton)
        
        // Расположение элементов внутри alert
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            okButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            okButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.4),
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.4),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func okTapped() {
        onOkTapped?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelTapped() {
        onCancelTapped?()
        dismiss(animated: true, completion: nil)
    }
    
    func show(in parentViewController: UIViewController) {
        parentViewController.present(self, animated: true, completion: nil)
    }
}
