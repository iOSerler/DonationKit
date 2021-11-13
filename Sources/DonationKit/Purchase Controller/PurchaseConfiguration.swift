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
    let purchaseButtonFont: UIFont
    let purchaseButtonTitleColor: UIColor
    let purchaseButtonBackgroundColor: UIColor
    
    let isSecondaryButtonHidden: Bool
    let secondaryButtonTitle: String
    let secondaryButtonFont: UIFont
    let secondaryButtonTitleColor: UIColor
    let secondaryButtonBackgroundColor: UIColor

    let successLabelText: String
    let successButtonTitle: String
    
    let purchaseFailedText: String
    let tryAgainButtonTitle: String
    
    let successAction: (() -> Void)?
    let secondaryAction: (() -> Void)?
    
    /// an optional custom ID to log the successful purchase
    let purchaseIdForHistory: String?
    
    public init(
        id: String,
        purchaseProductIdentifiers: [ProductIdentifier],
        headerTitle: String = "Donation",
        
        salesLabelText: String =  "Please support us by donating!",
        salesLabelFont: UIFont = UIFont.systemFont(ofSize: 21),
        salesLabelColor: UIColor = UIColor.darkText,
        
        purchaseButtonTitle: String =  "Donate",
        purchaseButtonFont: UIFont = UIFont.systemFont(ofSize: 19, weight: .semibold),
        purchaseButtonTitleColor: UIColor  = .white,
        purchaseButtonBackgroundColor: UIColor = .systemBlue,
        
        isSecondaryButtonHidden: Bool = true,
        secondaryButtonTitle: String = "Skip",
        secondaryButtonFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .light),
        secondaryButtonTitleColor: UIColor = UIColor.darkText,
        secondaryButtonBackgroundColor: UIColor = .clear,
        
        successLabelText: String =  "Thank you for donating!",
        successButtonTitle: String =  "Continue",
        
        purchaseFailedText: String =  "Purchase failed, please try again",
        tryAgainButtonTitle: String =  "Try again",
        
        successAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        purchaseIdForHistory: String? = nil
    ) {
        self.id = id
        self.purchaseProductIdentifiers = purchaseProductIdentifiers
        
        self.headerTitle = headerTitle
        
        self.salesLabelText = salesLabelText
        self.salesLabelFont = salesLabelFont
        self.salesLabelColor = salesLabelColor
                
        self.purchaseButtonTitle = purchaseButtonTitle
        self.purchaseButtonFont = purchaseButtonFont
        self.purchaseButtonTitleColor = purchaseButtonTitleColor
        self.purchaseButtonBackgroundColor = purchaseButtonBackgroundColor
        
        self.isSecondaryButtonHidden = isSecondaryButtonHidden
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonFont = secondaryButtonFont
        self.secondaryButtonTitleColor = secondaryButtonTitleColor
        self.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
        
        self.successLabelText = successLabelText
        self.successButtonTitle = successButtonTitle
        
        self.purchaseFailedText = purchaseFailedText
        self.tryAgainButtonTitle = tryAgainButtonTitle
        
        self.successAction = successAction
        self.secondaryAction = secondaryAction
        self.purchaseIdForHistory = purchaseIdForHistory
    }
    
}
