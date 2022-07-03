//
//  PurchaseConfigurable.swift
//  
//
//  Created by Daniya on 10/02/2022.
//

import Foundation

public struct PurchaseConfigurable {
    
    let configID: String
    let title: String
    let backgroundHexColor: Int
    
    /// Statement
    let statementImageName: String
    let statementLabelText: String
    let statementLabelFontName: String
    let statementLabelFontSize: CGFloat
    let statementLabelHexColor: Int
    
    /// Purchase Button
    let purchaseButtonTitle: String
    let purchaseButtonFontName: String
    let purchaseButtonFontSize: CGFloat
    let purchaseButtonTitleHexColor: Int
    let purchaseButtonBackgroundHexColor: Int
    
    /// Secondary Action Title
    let isSecondaryButtonHidden: Bool
    let secondaryButtonTitle: String
    let secondaryButtonFontName: String
    let secondaryButtonFontSize: CGFloat
    let secondaryButtonTitleHexColor: Int
    let secondaryButtonBackgroundHexColor: Int

    /// Successful Purchase
    let successImageName: String
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
        backgroundHexColor: Int = 0xFFFFFF,
        
        statementImageName: String = "",
        statementLabelText: String =  "Please support us by donating!",
        statementLabelFontName: String =  "",
        statementLabelFontSize: CGFloat = 21,
        statementLabelHexColor: Int = 0x000000,
        
        purchaseButtonTitle: String =  "Donate",
        purchaseButtonFontName: String =  "",
        purchaseButtonFontSize: CGFloat = 19,
        purchaseButtonTitleHexColor: Int = 0xFFFFFF,
        purchaseButtonBackgroundHexColor: Int = 0x007FFF,
        
        isSecondaryButtonHidden: Bool = true,
        secondaryButtonTitle: String = "Skip",
        secondaryButtonFontName: String =  "",
        secondaryButtonFontSize: CGFloat = 17,
        secondaryButtonTitleHexColor: Int = 0x000000,
        secondaryButtonBackgroundHexColor: Int = 0x0000FFFF,
        
        successImageName: String = "",
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
        self.backgroundHexColor = backgroundHexColor
        
        self.statementImageName = statementImageName
        self.statementLabelText = statementLabelText
        self.statementLabelFontName = statementLabelFontName
        self.statementLabelFontSize = statementLabelFontSize
        self.statementLabelHexColor = statementLabelHexColor
                
        self.purchaseButtonTitle = purchaseButtonTitle
        self.purchaseButtonFontName = purchaseButtonFontName
        self.purchaseButtonFontSize = purchaseButtonFontSize
        self.purchaseButtonTitleHexColor = purchaseButtonTitleHexColor
        self.purchaseButtonBackgroundHexColor = purchaseButtonBackgroundHexColor
        
        self.isSecondaryButtonHidden = isSecondaryButtonHidden
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonFontName = secondaryButtonFontName
        self.secondaryButtonFontSize = secondaryButtonFontSize
        self.secondaryButtonTitleHexColor = secondaryButtonTitleHexColor
        self.secondaryButtonBackgroundHexColor = secondaryButtonBackgroundHexColor
        
        self.successImageName = successImageName
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
