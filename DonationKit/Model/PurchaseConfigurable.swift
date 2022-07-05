//
//  PurchaseConfigurable.swift
//  
//
//  Created by Daniya on 10/02/2022.
//

import Foundation

public struct PurchaseConfigurable {
    
    let configID: String
    let type: String
    let title: String
    let backgroundHexColor: Int
    
    /// Statement
    let imageName: String
    
    let titleLabelText: String
    let titleLabelFontName: String
    let titleLabelFontSize: CGFloat
    let titleLabelHexColor: Int
    
    let bodyLabelText: String
    let bodyLabelFontName: String
    let bodyLabelFontSize: CGFloat
    let bodyLabelHexColor: Int
    
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
    let successTitleLabelText: String
    let successBodyLabelText: String
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
        type: String = "OneTime",
        title: String = "Donation",
        backgroundHexColor: Int = 0xFFFFFF,
        
        imageName: String = "",
        
        titleLabelText: String =  "Become a supporter.",
        titleLabelFontName: String =  "",
        titleLabelFontSize: CGFloat = 21,
        titleLabelHexColor: Int = 0x000000,
        
        bodyLabelText: String = "Make a recurring monthly donation to help us improve the technology for you!",
        bodyLabelFontName: String =  "",
        bodyLabelFontSize: CGFloat = 17,
        bodyLabelHexColor: Int = 0x000000,
        
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
        successTitleLabelText: String =  "Thank you for your generosity!",
        successBodyLabelText: String =  "Thank you for your generosity!",
        successButtonTitle: String =  "You're welcome",
        
        purchaseFailedText: String =  "Purchase failed, please try again",
        tryAgainButtonTitle: String =  "Try again",
        
        successAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        purchaseIdForHistory: String? = nil
    ) {
        self.configID = configID
        self.type = type
        self.title = title
        self.backgroundHexColor = backgroundHexColor
        
        self.imageName = imageName
        
        self.titleLabelText = titleLabelText
        self.titleLabelFontName = titleLabelFontName
        self.titleLabelFontSize = titleLabelFontSize
        self.titleLabelHexColor = titleLabelHexColor
        
        self.bodyLabelText = bodyLabelText
        self.bodyLabelFontName = bodyLabelFontName
        self.bodyLabelFontSize = bodyLabelFontSize
        self.bodyLabelHexColor = bodyLabelHexColor
                
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
        self.successTitleLabelText = successTitleLabelText
        self.successBodyLabelText = successBodyLabelText
        self.successButtonTitle = successButtonTitle
        
        self.purchaseFailedText = purchaseFailedText
        self.tryAgainButtonTitle = tryAgainButtonTitle
        
        self.successAction = successAction
        self.secondaryAction = secondaryAction
        self.purchaseIdForHistory = purchaseIdForHistory
    }
}
