//
//  BonusSystem.swift
//  namaz
//
//  Created by Daniya on 07/09/2021.
//  Copyright © 2021 Nursultan Askarbekuly. All rights reserved.
//

import Foundation
import UIKit

public struct PurchaseConfiguration {
    
    let id: String
    let purchaseProductIdentifiers: [ProductIdentifier]
    
    let headerTitle: String
    
    let salesLabelText: String
    let salesLabelFont: UIFont
    let salesLabelColor: UIColor
        
    let purchaseButtonText: String
    let purchaseButtonBackgroundColor: UIColor = .systemBlue
    let purchaseButtonTextColor: UIColor = .white
    
    let secondaryButtonText: String
    let secondaryButtonBackgroundColor: UIColor = .clear
    let secondaryButtonTextColor: UIColor = UIColor.darkText

    let purchaseFailedText: String
    let tryAgainButtonText: String

    let successLabelText: String
    let successButtonText: String
    
    let successAction: (() -> Void)?
    let secondaryButtonAction: (() -> Void)?
    let isSecondaryButtonHidden: Bool
    
    /// a custom ID to log the successful purchase
    /// if nil, product identifier will be userd
    let purchaseIdForHistory: String?
    
    public init(
        id: String,
        purchaseProductIdentifiers: [ProductIdentifier],
        headerTitle: String = "Donate",
        salesLabelText: String =  "Your support makes apps better!",
        purchaseFailedText: String =  "Purchase failed, please try again",
        salesLabelFont: UIFont = UIFont.systemFont(ofSize: 17),
        tryAgainButtonText: String =  "Try again",
        salesLabelColor: UIColor = UIColor.darkText,
        purchaseButtonText: String =  "Donate",
        secondaryButtonText: String = "Continue for free",
        successLabelText: String =  "Thank you for donating!",
        successButtonText: String =  "Continue",
        successAction: (() -> Void)? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        isSecondaryButtonHidden: Bool = true,
        purchaseIdForHistory: String? = nil
    ) {
        self.id = id
        self.purchaseProductIdentifiers = purchaseProductIdentifiers
        self.headerTitle = headerTitle
        self.salesLabelText = salesLabelText
        self.purchaseFailedText = purchaseFailedText
        self.salesLabelFont = salesLabelFont
        self.tryAgainButtonText = tryAgainButtonText
        self.salesLabelColor = salesLabelColor
        self.purchaseButtonText = purchaseButtonText
        self.secondaryButtonText = secondaryButtonText
        self.successLabelText = successLabelText
        self.successButtonText = successButtonText
        self.successAction = successAction
        self.secondaryButtonAction = secondaryButtonAction
        self.isSecondaryButtonHidden = isSecondaryButtonHidden
        self.purchaseIdForHistory = purchaseIdForHistory
    }
    
}
