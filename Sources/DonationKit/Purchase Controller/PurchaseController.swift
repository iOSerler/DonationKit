//
//  File.swift
//
//
//  Created by Daniya on 10/04/2020.
//


import UIKit
import StoreKit

public class PurchaseController: UIViewController {
        
    private let purchaseConfig: PurchaseConfiguration
    private let analytics: GenericAnalytics?
    
    public init(purchaseConfig: PurchaseConfiguration, analytics: GenericAnalytics? = nil) {
        self.purchaseConfig = purchaseConfig
        self.analytics = analytics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    private lazy var prices: [String] = []
    private var products = [SKProduct]() {
        didSet {
            prices = []
            
            products.sort { Int(truncating: $0.price) < Int(truncating: $1.price) }
            for product in products {
                if IAPHelper.canMakePayments() {
                    PurchaseController.priceFormatter.locale = product.priceLocale
                    prices.append("\(PurchaseController.priceFormatter.string(from: product.price)!)")
                } else {
                    //not available for purchse
                }
            }
            
            productChosen = products.first
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.pricePickerView.reloadAllComponents()
                self.statementLabel.isHidden = false
                self.purchaseButton.isHidden = false
                self.secondaryButton.isHidden = self.purchaseConfig.isSecondaryButtonHidden
            }
        }
    }
    
    private var productChosen: SKProduct?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var visualImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = purchaseConfig.statementImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var statementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        label.text = purchaseConfig.statementLabelText
        label.font = purchaseConfig.statementLabelFont
        label.textColor = purchaseConfig.statementLabelColor
        
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var pricePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(purchaseConfig.purchaseButtonTitle, for: UIControl.State())
        button.titleLabel?.font = purchaseConfig.purchaseButtonFont
        button.setTitleColor(purchaseConfig.purchaseButtonTitleColor, for: .normal)
        button.backgroundColor = purchaseConfig.purchaseButtonBackgroundColor
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(purchaseButtonPressed(_:)), for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    private lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = purchaseConfig.isSecondaryButtonHidden
        button.setTitle(purchaseConfig.secondaryButtonTitle, for: UIControl.State())
        button.backgroundColor = purchaseConfig.secondaryButtonBackgroundColor
        button.setTitleColor(purchaseConfig.secondaryButtonTitleColor, for: .normal)
        button.titleLabel?.font = purchaseConfig.secondaryButtonFont
        
        if let _ = purchaseConfig.secondaryAction {
            button.addTarget(self, action: #selector(proceedToSecondaryButtonAction), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
        
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        loadPurchases()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseController.handleFailueNotification(_:)),
        name: NSNotification.Name(rawValue: IAPHelper.IAPHelperFailureNotification),
        object: nil)
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor(red: 0xF4, green: 0xF4, blue: 0xF4, alpha: 1)
        self.title = purchaseConfig.title
        self.view.backgroundColor = purchaseConfig.backgroundColor
        self.view.addSubview(visualImageView)
        self.view.addSubview(statementLabel)
        self.view.addSubview(pricePickerView)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(secondaryButton)
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
        self.visualImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.visualImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.visualImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.visualImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
                
        self.statementLabel.topAnchor.constraint(equalTo: visualImageView.bottomAnchor, constant: 16).isActive = true
        self.statementLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.statementLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.statementLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true

        self.pricePickerView.topAnchor.constraint(equalTo: statementLabel.bottomAnchor, constant: 8).isActive = true
        self.pricePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.pricePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.pricePickerView.bottomAnchor.constraint(greaterThanOrEqualTo: purchaseButton.topAnchor, constant: -16).isActive = true
        
        self.purchaseButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: -16).isActive = true
        self.purchaseButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.purchaseButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
        self.secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        self.secondaryButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.secondaryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.secondaryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
    }
    
    private func loadPurchases() {
        activityIndicator.startAnimating()
        
        IAPProducts.purchaseProductIdentifiers = Set(purchaseConfig.purchaseProductIdentifiers)
        IAPProducts.purchaseStore.requestProducts{success, productArray in
                        
            if success {
                self.products = productArray!
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    @objc private func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func handlePurchaseNotification(_ notification: Notification) {
        
        self.activityIndicator.stopAnimating()
        self.analytics?.logEvent("Purchase Made", properties: [
            "price": productChosen!.price,
            "configuration": purchaseConfig.id
        ])
        
        PurchaseHistory.markPurchase(purchaseConfig.purchaseIdForHistory)
        
        self.navigationController?.pushViewController(SuccessController(purchaseConfig: purchaseConfig, analytics: analytics), animated: true)
    }
    
    @objc private func handleFailueNotification(_ notification: Notification) {
           
        guard let _ = productChosen else {
            /// false shots
            return
        }
        
        self.activityIndicator.stopAnimating()
        
        if let identified = notification.object as? String, identified == "none" {
            /// purchase got canceled by user
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.purchaseButton.alpha = 0
            self.statementLabel.alpha = 0
        }) { _ in
            self.statementLabel.text = self.purchaseConfig.purchaseFailedText
            self.purchaseButton.setTitle(self.purchaseConfig.tryAgainButtonTitle, for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.statementLabel.alpha = 1
                self.purchaseButton.alpha = 1
            })
        }
    }
    
    @objc private func purchaseButtonPressed(_ sender: AnyObject) {
        
        if activityIndicator.isAnimating {
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let product = productChosen else {
            activityIndicator.stopAnimating()
            pop()
            return
        }
        
        self.analytics?.logEvent("Purchase Attempt", properties: [
            "price": product.price,
            "configuration": purchaseConfig.id
        ])
        IAPProducts.purchaseStore.buyProduct(product)
    }
    
    @objc private func proceedToSuccesAction() {
        purchaseConfig.successAction?()
    }
    
    @objc private func proceedToSecondaryButtonAction() {
        purchaseConfig.secondaryAction?()
    }
    
    
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension PurchaseController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prices.count
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = prices[row]
        
        return pickerLabel!;
    }
    
    

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if products.count > row {
            productChosen = products[row]
        } else {
            productChosen = nil
        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    
}


