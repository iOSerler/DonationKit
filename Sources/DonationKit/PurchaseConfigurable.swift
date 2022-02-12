//
//  PurchaseConfigurable.swift
//  
//
//  Created by Daniya on 10/02/2022.
//

import UIKit

public struct PurchaseConfigurable {
    
    let configID: String
    let title: String
    let backgroundColor: UIColor
    
    /// Statement
    let statementImage: UIImage?
    let statementLabelText: String
    let highlightedLabelText: String?
    let statementLabelFont: UIFont
    let highlightedLabelFont: UIFont
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

    /// Successful Purchase
    let successImage: UIImage?
    let isSuccessImagePulsating: Bool
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
    
    public init(
        configID: String = "",
        title: String = "Donation",
        backgroundColor: UIColor = .white,
        
        statementImage: UIImage? = nil,
        statementLabelText: String =  "Please support us by donating!",
        highlightedLabelText: String? = nil,
        statementLabelFont: UIFont = UIFont.systemFont(ofSize: 21),
        highlightedLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 23),
        statementLabelColor: UIColor = .black,
        
        purchaseButtonTitle: String =  "Donate",
        purchaseButtonFont: UIFont = UIFont.systemFont(ofSize: 19, weight: .semibold),
        purchaseButtonTitleColor: UIColor  = .white,
        purchaseButtonBackgroundColor: UIColor = .systemBlue,
        
        isSecondaryButtonHidden: Bool = true,
        secondaryButtonTitle: String = "Skip",
        secondaryButtonFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .light),
        secondaryButtonTitleColor: UIColor = .black,
        secondaryButtonBackgroundColor: UIColor = .clear,
        
        successImage: UIImage? = nil,
        isSuccessImagePulsating: Bool = true,
        successLabelText: String =  "Thank you for your generosity!",
        successButtonTitle: String =  "You're welcome",
        
        purchaseFailedText: String =  "Purchase failed, please try again",
        tryAgainButtonTitle: String =  "Try again",
        
        successAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        purchaseIdForHistory: String? = nil
    ) {
        self.configID = configID
        self.title = title
        self.backgroundColor = backgroundColor
        
        self.statementImage = statementImage
        self.statementLabelText = statementLabelText
        self.highlightedLabelText = highlightedLabelText
        self.statementLabelFont = statementLabelFont
        self.highlightedLabelFont = highlightedLabelFont
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
        
        self.successImage = successImage
        self.isSuccessImagePulsating = isSuccessImagePulsating
        self.successLabelText = successLabelText
        self.successButtonTitle = successButtonTitle
        
        self.purchaseFailedText = purchaseFailedText
        self.tryAgainButtonTitle = tryAgainButtonTitle
        
        self.successAction = successAction
        self.secondaryAction = secondaryAction
        self.purchaseIdForHistory = purchaseIdForHistory
    }
}
