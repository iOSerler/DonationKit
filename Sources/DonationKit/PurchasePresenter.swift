//
//  BonusSystem.swift
//  namaz
//
//  Created by Daniya on 07/09/2021.
//  Copyright © 2021 Nursultan Askarbekuly. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

public class PurchasePresenter {
    
    weak private var viewDelegate: PurchaseViewDelegate?
    
    private var purchaseStore: PurchaseService?
    private let analytics: AbstractAnalytics?
    
    public var config = PurchaseConfigurable()
    var prices: [String] = []

    private var products = [SKProduct]()
    private var productChosen: SKProduct?
    private var isProcessingRequest = true
    
    var chosenProductIndex: Int {
        guard let productChosen = productChosen,
            let index = products.firstIndex(of: productChosen) else {
            return 0
        }
        
        return index
    }
    
    public init(analytics: AbstractAnalytics? = nil,
                purchaseProductIdentifiers: [ProductIdentifier],
                config: PurchaseConfigurable? = nil) {
        self.analytics = analytics
        self.purchaseStore = PurchaseService(productIds: Set(purchaseProductIdentifiers))
        
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
                
                for product in self.products {
                    if PurchaseService.canMakePayments() {
                        priceFormatter.locale = product.priceLocale
                        prices.append("\(priceFormatter.string(from: product.price)!)")
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
        
        self.analytics?.logEvent("Purchase Attempt", properties: [
            "price": product.price,
            "configuration": config.configID
        ])
        
        self.isProcessingRequest = true
        purchaseStore?.buyProduct(product)
    }
    
    func doSuccessAction() {
        
        analytics?.logEvent("Success Action Performed", properties: [
            "configID" : config.configID])
        
        if let _ = config.successAction {
            config.successAction?()
        } else {
            /// FIXME: has to be success controller
            viewDelegate?.pop()
        }
    }
    
    func doSecondaryAction() {
        
        analytics?.logEvent("Secondary Action Performed", properties: [
            "configID" : config.configID])
        
        if let _ = config.secondaryAction {
            config.secondaryAction?()
        } else {
            viewDelegate?.pop()
        }
    }
    
    @objc private func handlePurchaseNotification(_ notification: Notification) {
        
        self.viewDelegate?.stopLoadingAnimation()
        self.isProcessingRequest = false
        self.analytics?.logEvent("Purchase Made", properties: [
            "price": productChosen!.price,
            "configuration": config.configID
        ])
        
        PurchaseStorage.savePurchase(config.purchaseIdForHistory)
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
