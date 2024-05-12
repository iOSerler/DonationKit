//
//  BonusSystem.swift
//  namaz
//
//  Created by Daniya on 07/09/2021.
//  Copyright © 2021 Nursultan Askarbekuly. All rights reserved.
//

import Foundation
import StoreKit

public protocol DonationAnalyticsDelegate: AnyObject {
    func purchaseSuccess(lessonID: String?)
    func secondaryButtonPressed(lessonID: String?)
    func purchaseFail()
    func buyPurchasePressed(price: Int)
    func closePurchasePressed()
    func priceListShown()
}

public class PurchasePresenter {
    
    weak private var viewDelegate: PurchaseViewDelegate?
    
    private var purchaseStore: PurchaseService?
    private let storage: PurchaseStorage
    
    public var config = PurchaseConfiguration()
    var prices: [String] = []
    var titles: [String] = []
    var subscriptionPeriods: [String] = []

    private var products = [SKProduct]()
    private var productChosen: SKProduct?
    private var isProcessingRequest = true
    private weak var analytics: DonationAnalyticsDelegate?

    var chosenProductIndex: Int {
        guard let productChosen = productChosen,
            let index = products.firstIndex(of: productChosen) else {
            return 0
        }
        
        return index
    }
    
    public init(purchaseProductIdentifiers: [ProductIdentifier],
                config: PurchaseConfiguration? = nil,
                storage: PurchaseStorage,
                analyticsDelegate: DonationAnalyticsDelegate?) {
        self.analytics = analyticsDelegate
        self.purchaseStore = PurchaseService(productIds: Set(purchaseProductIdentifiers), storage: storage)
        self.storage = storage
        
        if let config = config {
            self.config = config
        }
        
        loadPurchases()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: NSNotification.Name(rawValue: PurchaseService.IAPHelperPurchaseNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailueNotification(_:)), name: NSNotification.Name(rawValue: PurchaseService.IAPHelperFailureNotification), object: nil)
    }
    
    func setViewDelegate(viewDelegate: PurchaseViewDelegate){
        self.viewDelegate = viewDelegate
    }
    
    private func loadPurchases() {
        
        viewDelegate?.startLoadingAnimation()
        purchaseStore?.requestProducts{ [self] success, productArray in
                        
            if success {
                
                self.products = productArray!.sorted { Int(truncating: $0.price) < Int(truncating: $1.price) }
                
                let priceFormatter = NumberFormatter()
                priceFormatter.formatterBehavior = .behavior10_4
                priceFormatter.numberStyle = .currency
                
                var prices: [String] = []
                var titles: [String] = []
                var subscriptionPeriods: [String] = []
                
                for product in self.products {
                    if PurchaseService.canMakePayments() {
                        priceFormatter.locale = product.priceLocale
                        prices.append("\(priceFormatter.string(from: product.price)!)")
                        titles.append(product.localizedTitle)
                        
                        /// fetch period name for subscriptions
                        if #available(iOS 11.2, *),
                           let period = product.subscriptionPeriod,
                           config.subscriptionPeriods.count > period.unit.rawValue {
                            let periodIndex = Int(period.unit.rawValue)
                            subscriptionPeriods.append(config.subscriptionPeriods[periodIndex])
                        }
                    } else {
                        //not available for purchse
                    }
                }
                
                self.prices = prices
                self.titles = titles
                self.subscriptionPeriods = subscriptionPeriods
                let chosenIndex = 0
                
                if self.products.count > chosenIndex {
                    self.productChosen = self.products[chosenIndex]
                } else if let first = self.products.first {
                    self.productChosen = first
                }
                
                DispatchQueue.main.async {
                    self.viewDelegate?.stopLoadingAnimation()
                    self.isProcessingRequest = false
                    self.viewDelegate?.showPurchaseViews()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.viewDelegate?.stopLoadingAnimation()
                    self.isProcessingRequest = false
                }
            }
        }
    }
    
    func choosePrice(at index: Int) {
        if products.count > index {
            productChosen = products[index]
        } else {
            productChosen = nil
        }
    }
    
    func makePurchase() {
        if isProcessingRequest {
            return
        }
        
        self.viewDelegate?.startLoadingAnimation()

        guard let product = productChosen else {
            self.viewDelegate?.stopLoadingAnimation()
            self.viewDelegate?.pop()
            return
        }

        analytics?.buyPurchasePressed(price: product.price.intValue)

        self.isProcessingRequest = true
        purchaseStore?.buyProduct(product)
    }
    
    func doSuccessAction() {

        analytics?.purchaseSuccess(lessonID: config.lessonId)

        if let _ = config.successAction {
            config.successAction?()
        } else {
            /// FIXME: has to be success controller
            viewDelegate?.pop()
        }
    }

    func doFailureAction() {
        analytics?.purchaseFail()
    }

    func didReloadPriceList() {
        analytics?.priceListShown()
    }

    func didTapBack() {
        analytics?.closePurchasePressed()
    }

    func doSecondaryAction() {

        analytics?.secondaryButtonPressed(lessonID: config.lessonId)

        if let _ = config.secondaryAction {
            config.secondaryAction?()
        } else {
            viewDelegate?.pop()
        }
    }
    
    @objc private func handlePurchaseNotification(_ notification: Notification) {
        
        self.viewDelegate?.stopLoadingAnimation()
        self.isProcessingRequest = false
        
        storage.store(true, forKey: config.purchaseIdForHistory ?? "didSupportApp")
        viewDelegate?.showSuccessController()
    }
    
    @objc private func handleFailueNotification(_ notification: Notification) {
           
        guard let _ = productChosen else {
            /// false shots
            return
        }
        
        self.viewDelegate?.stopLoadingAnimation()
        self.isProcessingRequest = false
        
        if let identified = notification.object as? String, identified == "none" {
            /// purchase got canceled by user
            return
        }
        
        viewDelegate?.showFailureViews()
    }
    
    
}
