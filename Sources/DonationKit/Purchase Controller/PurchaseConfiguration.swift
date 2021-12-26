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
    
    let title: String
    let backgroundColor: UIColor
    
    /// Images
    let statementImage: UIImage?
    let successImage: UIImage?
    
    /// Statement Label
    let statementLabelText: String
    let statementLabelFont: UIFont
    let statementLabelColor: UIColor
    
    /// Purchase Button
    let purchaseButtonTitle: String
    let purchaseButtonFont: UIFont
    let purchaseButtonTitleColor: UIColor
    let purchaseButtonBackgroundColor: UIColor
    
    /// Secondary Action Title
    let isSecondaryButtonHidden: Bool
    let secondaryButtonTitle: String
    let secondaryButtonFont: UIFont
    let secondaryButtonTitleColor: UIColor
    let secondaryButtonBackgroundColor: UIColor

    /// Success Label
    let successLabelText: String
    let successButtonTitle: String
    
    /// Purchase Failed Label
    let purchaseFailedText: String
    let tryAgainButtonTitle: String
    
    /// Callbacks for functional behaviour
    let successAction: (() -> Void)?
    let secondaryAction: (() -> Void)?
    
    /// Custom ID to log a successful purchase
    let purchaseIdForHistory: String?
    
    @available(iOS 13.0, *)
    public init(
        id: String = "",
        purchaseProductIdentifiers: [ProductIdentifier],
        title: String = "Donation",
        backgroundColor: UIColor = .systemBackground,
        
        statementLabelText: String =  "Please support us by donating!",
        statementLabelFont: UIFont = UIFont.systemFont(ofSize: 21),
        statementLabelColor: UIColor = UIColor.label,
        
        purchaseButtonTitle: String =  "Donate",
        purchaseButtonFont: UIFont = UIFont.systemFont(ofSize: 19, weight: .semibold),
        purchaseButtonTitleColor: UIColor  = .systemBackground,
        purchaseButtonBackgroundColor: UIColor = .systemBlue,
        
        isSecondaryButtonHidden: Bool = true,
        secondaryButtonTitle: String = "Skip",
        secondaryButtonFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .light),
        secondaryButtonTitleColor: UIColor = UIColor.label,
        secondaryButtonBackgroundColor: UIColor = .clear,
        
        successLabelText: String =  "Thank you for your generosity!",
        successButtonTitle: String =  "You're welcome",
        
        purchaseFailedText: String =  "Purchase failed, please try again",
        tryAgainButtonTitle: String =  "Try again",
        
        successAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        purchaseIdForHistory: String? = nil
    ) {
        self.id = id
        self.purchaseProductIdentifiers = purchaseProductIdentifiers
        
        self.title = title
        self.backgroundColor = backgroundColor
        
        self.statementImage = UIImage(systemName: "gift.circle.fill")
        self.successImage = UIImage(systemName: "heart.circle.fill")
        
        self.statementLabelText = statementLabelText
        self.statementLabelFont = statementLabelFont
        self.statementLabelColor = statementLabelColor
                
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
