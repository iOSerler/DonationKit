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
    
    weak private var purchaseViewDelegate: PurchaseController?
    weak private var successViewDelegate: SuccessController?
    
    private var purchaseStore: PurchaseService?
    private let analytics: AbstractAnalytics?
    
    public var config = PurchaseConfigurables()
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
                config: PurchaseConfigurables? = nil) {
        self.analytics = analytics
        self.purchaseStore = PurchaseService(productIds: Set(purchaseProductIdentifiers))
        
        if let config = config {
            self.config = config
        }
        
        loadPurchases()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: NSNotification.Name(rawValue: PurchaseService.IAPHelperPurchaseNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailueNotification(_:)), name: NSNotification.Name(rawValue: PurchaseService.IAPHelperFailureNotification), object: nil)
    }
    
    func setPurchaseViewDelegate(purchaseViewDelegate: PurchaseController?){
        self.purchaseViewDelegate = purchaseViewDelegate
    }
    
    func setSuccessViewDelegate(successViewDelegate: SuccessController?){
        self.successViewDelegate = successViewDelegate
    }
    
    private func loadPurchases() {
        
        purchaseViewDelegate?.startLoadingAnimation()
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
                    self.purchaseViewDelegate?.stopLoadingAnimation()
                    self.isProcessingRequest = false
                    self.purchaseViewDelegate?.showPurchaseViews()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.purchaseViewDelegate?.stopLoadingAnimation()
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
        
        self.purchaseViewDelegate?.startLoadingAnimation()

        guard let product = productChosen else {
            self.purchaseViewDelegate?.stopLoadingAnimation()
            self.purchaseViewDelegate?.pop()
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
            successViewDelegate?.pop()
        }
    }
    
    func doSecondaryAction() {
        
        analytics?.logEvent("Secondary Action Performed", properties: [
            "configID" : config.configID])
        
        if let _ = config.secondaryAction {
            config.secondaryAction?()
        } else {
            purchaseViewDelegate?.pop()
        }
    }
    
    @objc private func handlePurchaseNotification(_ notification: Notification) {
        
        self.purchaseViewDelegate?.stopLoadingAnimation()
        self.isProcessingRequest = false
        self.analytics?.logEvent("Purchase Made", properties: [
            "price": productChosen!.price,
            "configuration": config.configID
        ])
        
        PurchaseStorage.savePurchase(config.purchaseIdForHistory)
        purchaseViewDelegate?.showSuccessController()
    }
    
    @objc private func handleFailueNotification(_ notification: Notification) {
           
        guard let _ = productChosen else {
            /// false shots
            return
        }
        
        self.purchaseViewDelegate?.stopLoadingAnimation()
        self.isProcessingRequest = false
        
        if let identified = notification.object as? String, identified == "none" {
            /// purchase got canceled by user
            return
        }
        
        purchaseViewDelegate?.showFailureViews()
    }
    
    
}
