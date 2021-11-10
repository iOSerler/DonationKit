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
        
    let purchaseButtonTitle: String
    let purchaseButtonBackgroundColor: UIColor = .systemBlue
    let purchaseButtonTitleColor: UIColor = .white
    
    let secondaryButtonTitle: String
    let secondaryButtonBackgroundColor: UIColor = .clear
    let secondaryButtonTitleColor: UIColor = UIColor.darkText

    let purchaseFailedText: String
    let tryAgainButtonTitle: String

    let successLabelText: String
    let successButtonTitle: String
    
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
        tryAgainButtonTitle: String =  "Try again",
        salesLabelColor: UIColor = UIColor.darkText,
        purchaseButtonTitle: String =  "Donate",
        secondaryButtonTitle: String = "Continue for free",
        successLabelText: String =  "Thank you for donating!",
        successButtonTitle: String =  "Continue",
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
        self.tryAgainButtonTitle = tryAgainButtonTitle
        self.salesLabelColor = salesLabelColor
        self.purchaseButtonTitle = purchaseButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.successLabelText = successLabelText
        self.successButtonTitle = successButtonTitle
        self.successAction = successAction
        self.secondaryButtonAction = secondaryButtonAction
        self.isSecondaryButtonHidden = isSecondaryButtonHidden
        self.purchaseIdForHistory = purchaseIdForHistory
    }
    
}
