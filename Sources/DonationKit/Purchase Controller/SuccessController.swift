//
//  SuccessController.swift
//  
//
//  Created by Daniya on 25/12/2021.
//

import UIKit
import StoreKit

public class SuccessController: UIViewController {
        
    private let purchaseConfig: PurchaseConfiguration
    private let analytics: AbstractAnalytics?
    
    private var wasNavigationBarHidden: Bool = false
    
    public init(purchaseConfig: PurchaseConfiguration, analytics: AbstractAnalytics? = nil) {
        self.purchaseConfig = purchaseConfig
        self.analytics = analytics
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = purchaseConfig.successImage
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        label.text = purchaseConfig.successLabelText
        label.font = purchaseConfig.statementLabelFont
        label.textColor = purchaseConfig.statementLabelColor
        
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var proceedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(purchaseConfig.successButtonTitle, for: UIControl.State())
        button.titleLabel?.font = purchaseConfig.purchaseButtonFont
        button.setTitleColor(purchaseConfig.purchaseButtonTitleColor, for: .normal)
        button.backgroundColor = purchaseConfig.purchaseButtonBackgroundColor
        button.layer.cornerRadius = 5
        
        if let _ = purchaseConfig.successAction {
            button.addTarget(self, action: #selector(proceedToSuccesAction), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
        
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wasNavigationBarHidden = self.navigationController?.isNavigationBarHidden ?? false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = self.wasNavigationBarHidden
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor(red: 0xF4, green: 0xF4, blue: 0xF4, alpha: 1)
        self.title = purchaseConfig.title
        self.view.backgroundColor = purchaseConfig.backgroundColor
        self.view.addSubview(successImageView)
        self.view.addSubview(successLabel)
        self.view.addSubview(proceedButton)
        
        if #available(iOS 11.0, *) {
            self.successImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            self.successImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            self.successImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            self.successImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.30).isActive = true
                    
            self.successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 16).isActive = true
            self.successLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            self.successLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            self.successLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
            
            self.proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110).isActive = true
            self.proceedButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
            self.proceedButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            self.proceedButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        } else {
            self.successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            self.successImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            self.successImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            self.successImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30).isActive = true
                    
            self.successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 16).isActive = true
            self.successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            self.successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            self.successLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
            
            self.proceedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
            self.proceedButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
            self.proceedButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            self.proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        }
        
        
        if purchaseConfig.isSuccessImagePulsating {
            let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 1.0
            scaleAnimation.repeatCount = 3.0
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.15;
            self.successImageView.layer.add(scaleAnimation, forKey: "scale")
        }
    }
    
    @objc private func pop() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func proceedToSuccesAction() {
        purchaseConfig.successAction?()
    }
    
}
