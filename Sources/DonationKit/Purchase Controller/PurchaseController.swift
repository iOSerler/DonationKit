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
    private let analytics: AbstractAnalytics?
    
    public init(purchaseConfig: PurchaseConfiguration, analytics: AbstractAnalytics? = nil) {
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
    private var products = [SKProduct]()
    
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
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var statementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        let labelString = NSMutableAttributedString(string: purchaseConfig.statementLabelText, attributes: [
            NSAttributedString.Key.font : purchaseConfig.statementLabelFont,
            NSAttributedString.Key.foregroundColor : purchaseConfig.statementLabelColor,
            
        ])
        
        if let highlightedText = purchaseConfig.highlightedLabelText {
            
            let boldString = NSMutableAttributedString(string: highlightedText, attributes: [
                NSAttributedString.Key.font : purchaseConfig.highlightedLabelFont,
                NSAttributedString.Key.foregroundColor : purchaseConfig.statementLabelColor,
                
            ])
            labelString.append(boldString)
        }
        
        label.attributedText = labelString
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
    
    private lazy var priceCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 90)/3, height: 50)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
                
        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
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
        self.view.addSubview(priceCollectionView)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(secondaryButton)
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        if #available(iOS 11.0, *) {
            self.visualImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        } else {
            self.visualImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        }
        
        self.statementLabel.topAnchor.constraint(equalTo: visualImageView.bottomAnchor, constant: 16).isActive = true
        self.statementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.statementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        self.priceCollectionView.topAnchor.constraint(greaterThanOrEqualTo: statementLabel.bottomAnchor, constant: 24).isActive = true
        self.priceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.priceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.priceCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.priceCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: purchaseButton.topAnchor, constant: -40).isActive = true
        
        self.purchaseButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: -16).isActive = true
        self.purchaseButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.visualImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.visualImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.visualImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        self.secondaryButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.secondaryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    private func loadPurchases() {
        activityIndicator.startAnimating()
        
        IAPProducts.purchaseProductIdentifiers = Set(purchaseConfig.purchaseProductIdentifiers)
        IAPProducts.purchaseStore.requestProducts{success, productArray in
                        
            if success {
                
                self.products = productArray!.sorted { Int(truncating: $0.price) < Int(truncating: $1.price) }
                
                var prices: [String] = []
                
                for product in self.products {
                    if IAPHelper.canMakePayments() {
                        PurchaseController.priceFormatter.locale = product.priceLocale
                        prices.append("\(PurchaseController.priceFormatter.string(from: product.price)!)")
                    } else {
                        //not available for purchse
                    }
                }
                
                self.prices = prices
                
                if self.products.count > 1 {
                    self.productChosen = self.products[1]
                } else if let firts = self.products.first {
                    self.productChosen = firts
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.priceCollectionView.reloadData()
                    self.pricePickerView.reloadAllComponents()
                    self.visualImageView.isHidden = false
                    self.statementLabel.isHidden = false
                    self.purchaseButton.isHidden = false
                    self.secondaryButton.isHidden = self.purchaseConfig.isSecondaryButtonHidden
                }
                
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

// MARK: - UITableViewDelegate & UITableViewDataSource

extension PurchaseController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var chosenProductIndex: Int {
        guard let productChosen = productChosen,
            let index = products.firstIndex(of: productChosen) else {
            return 0
        }
        
        return index
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prices.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PriceCollectionViewCell
        
        cell.textLabel.text = prices[indexPath.item]
        if chosenProductIndex == indexPath.item {
            cell.textLabel.textColor = purchaseConfig.purchaseButtonTitleColor
            cell.textLabel.backgroundColor = purchaseConfig.purchaseButtonBackgroundColor
            cell.textLabel.layer.borderColor = purchaseConfig.purchaseButtonBackgroundColor.cgColor
        } else {
            cell.textLabel.textColor = purchaseConfig.statementLabelColor
            cell.textLabel.backgroundColor = purchaseConfig.backgroundColor
            cell.textLabel.layer.borderColor = purchaseConfig.statementLabelColor.cgColor
        }
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if products.count > indexPath.item {
            productChosen = products[indexPath.item]
            collectionView.reloadData()
        } else {
            productChosen = nil
        }
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
