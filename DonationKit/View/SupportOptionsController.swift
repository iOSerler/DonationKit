//
//  SupportOptionsController.swift
//  DonationKit
//
//  Created by Daniya on 03/07/2022.
//

import UIKit


public class DonateOptionController: UIViewController {
    
    let config: PurchaseConfigurable
    
    public init(config: PurchaseConfigurable) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var visualImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: config.statementImageName)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = config.title
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = config.title
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(config.purchaseButtonTitle, for: UIControl.State())
        
        if config.purchaseButtonFontName.isEmpty {
            button.titleLabel?.font = UIFont.systemFont(ofSize: config.purchaseButtonFontSize, weight: .semibold)
        } else {
            button.titleLabel?.font = UIFont(name: config.purchaseButtonFontName, size: config.purchaseButtonFontSize)
        }
        
        button.setTitleColor(UIColor(rgb: config.purchaseButtonTitleHexColor), for: .normal)
        button.backgroundColor = UIColor(rgb: config.purchaseButtonBackgroundHexColor)
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(subscribeButtonPressed(_:)), for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    private lazy var donateOnceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(config.purchaseButtonTitle, for: UIControl.State())
        
        if config.purchaseButtonFontName.isEmpty {
            button.titleLabel?.font = UIFont.systemFont(ofSize: config.purchaseButtonFontSize, weight: .semibold)
        } else {
            button.titleLabel?.font = UIFont(name: config.purchaseButtonFontName, size: config.purchaseButtonFontSize)
        }
        
        button.setTitleColor(UIColor(rgb: config.purchaseButtonTitleHexColor), for: .normal)
        button.backgroundColor = UIColor(rgb: config.purchaseButtonBackgroundHexColor)
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(donateOnceButtonPressed), for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor(red: 0xF4, green: 0xF4, blue: 0xF4, alpha: 1)
        self.title = config.title
        self.view.backgroundColor = UIColor(rgb: config.backgroundHexColor)
        self.view.addSubview(visualImageView)
        self.view.addSubview(bodyLabel)
        self.view.addSubview(subscribeButton)
        self.view.addSubview(donateOnceButton)

        
        if #available(iOS 11.0, *) {
            self.visualImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.donateOnceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        } else {
            self.visualImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            self.donateOnceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        }
        
        self.bodyLabel.topAnchor.constraint(equalTo: visualImageView.bottomAnchor, constant: 16).isActive = true
        self.bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        self.subscribeButton.bottomAnchor.constraint(equalTo: donateOnceButton.topAnchor, constant: -16).isActive = true
        self.subscribeButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.subscribeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.visualImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.visualImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.visualImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        self.donateOnceButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.donateOnceButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.donateOnceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc private func subscribeButtonPressed(_ sender: AnyObject) {
        
    }
    
    @objc private func donateOnceButtonPressed() {

    }
    
}
