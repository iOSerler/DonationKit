//
//  File.swift
//
//
//  Created by Daniya on 10/04/2020.
//


import UIKit
import StoreKit

public class PurchaseController: UIViewController {
        
    let purchaseConfig: PurchaseConfiguration
    private let analytics: GenericAnalytics?
    
    public lazy var secondaryButtonAction: () -> Void = {
      self.dismiss(animated: true, completion: nil)
    }
    
    public init(purchaseConfig: PurchaseConfiguration, analytics: GenericAnalytics?) {
        self.purchaseConfig = purchaseConfig
        self.analytics = analytics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                self.pricePickerView.reloadAllComponents()
                self.activityIndicator.stopAnimating()
                self.purchaseButton.isHidden = false
                self.secondaryButton.isHidden = self.purchaseConfig.isSecondaryButtonHidden
                self.salesPitchLabel.isHidden = false
            }
        }
    }
    
    private var productChosen: SKProduct?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x:  UIScreen.main.bounds.width/2 - 25, y: 200, width: 50, height: 50)
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var salesPitchLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 120, width: UIScreen.main.bounds.width - 60, height: 100)
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = UIColor.darkText
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        label.text = purchaseConfig.salesLabelText
        
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 120, width: UIScreen.main.bounds.width - 60, height: 100)
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = UIColor.darkText
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.alpha = 0
        
        label.text = purchaseConfig.successLabelText
        
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    
    private lazy var pricePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tintColor = UIColor.darkText
        picker.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height -  180 - 124)
        return picker
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(purchaseConfig.purchaseButtonText, for: UIControl.State())
        button.backgroundColor = purchaseConfig.purchaseButtonBackgroundColor
        button.setTitleColor(purchaseConfig.purchaseButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(purchaseButtonPressed(_:)), for: .touchUpInside)

        button.layer.cornerRadius = 5
        button.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 75, y: UIScreen.main.bounds.height - 154, width: 150, height: 44)
        button.isHidden = true
        return button
    }()
    
    private lazy var proceedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.darkText.cgColor
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 75, y: UIScreen.main.bounds.height - 104, width: 150, height: 44)
        
        button.setTitle(purchaseConfig.successButtonText, for: UIControl.State())
        
        if let _ = purchaseConfig.successAction {
            button.addTarget(self, action: #selector(proceedToSuccesAction), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
        
        
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
    private lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(purchaseConfig.secondaryButtonText, for: UIControl.State())
        button.backgroundColor = purchaseConfig.secondaryButtonBackgroundColor
        button.setTitleColor(purchaseConfig.secondaryButtonTextColor, for: .normal)
        
        if let _ = purchaseConfig.secondaryButtonAction {
            button.addTarget(self, action: #selector(proceedToSecondaryButtonAction), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }

        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
        button.layer.borderColor = purchaseConfig.secondaryButtonTextColor.cgColor
        
        button.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 75, y: UIScreen.main.bounds.height - 94, width: 150, height: 44)
        button.isHidden = true

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
        self.title = purchaseConfig.headerTitle
        self.view.addSubview(salesPitchLabel)
        self.view.addSubview(successLabel)
        self.view.addSubview(pricePickerView)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(secondaryButton)
        self.view.addSubview(proceedButton)
        self.view.addSubview(activityIndicator)
        
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
    
    override public func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            
            super.viewSafeAreaInsetsDidChange()
            
            let safeArea = self.view.safeAreaInsets
            
            self.purchaseButton.frame.origin.y = UIScreen.main.bounds.height - 124 - safeArea.bottom
            self.pricePickerView.frame.size.height = UIScreen.main.bounds.height -  180 - 144 - safeArea.bottom
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pricePickerView.alpha = 0
            self.purchaseButton.alpha = 0
            self.salesPitchLabel.alpha = 0
        }) { _ in
            
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                self.proceedButton.isHidden = false
                self.proceedButton.alpha = 1
                self.successLabel.isHidden = false
                self.successLabel.alpha = 1
            })
        }
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
            self.salesPitchLabel.alpha = 0
        }) { _ in
            self.salesPitchLabel.text = self.purchaseConfig.purchaseFailedText
            self.purchaseButton.setTitle(self.purchaseConfig.tryAgainButtonText, for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.salesPitchLabel.alpha = 1
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
        purchaseConfig.secondaryButtonAction?()
    }
    
    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    
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


