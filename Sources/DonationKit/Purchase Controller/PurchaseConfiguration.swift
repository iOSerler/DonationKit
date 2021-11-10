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

    let succesLabelText: String
    let successButtonText: String
    
    let successAction: (() -> Void)?
    let secondaryButtonAction: (() -> Void)?
    let isSecondaryButtonHidden: Bool
    
    /// FIXME: do we need it?
    let associatedPurchaseItemId: String?
    
    public init(
        id: String,
        purchaseProductIdentifiers: [ProductIdentifier],
        headerTitle: String = "Support",
        salesLabelText: String =  "SalesPitch",
        purchaseFailedText: String =  "PurchaseFailed",
        salesLabelFont: UIFont = UIFont.systemFont(ofSize: 17),
        tryAgainButtonText: String =  "TryAgain",
        salesLabelColor: UIColor = UIColor.darkText,
        purchaseButtonText: String =  "Donate",
        secondaryButtonText: String = "Continue for free",
        succesLabelText: String =  "Thanks",
        successButtonText: String =  "Continue",
        successAction: (() -> Void)? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        isSecondaryButtonHidden: Bool = true,
        associatedPurchaseItemId: String? = nil
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
        self.succesLabelText = succesLabelText
        self.successButtonText = successButtonText
        self.successAction = successAction
        self.secondaryButtonAction = secondaryButtonAction
        self.isSecondaryButtonHidden = isSecondaryButtonHidden
        self.associatedPurchaseItemId = associatedPurchaseItemId
    }
    
        
    
}


public class PurchaseHistory {
    
    
    static func markPurchase(_ purchaseId: String?) {
        
        
        
        if let purchaseId = purchaseId {
        
            /// mark purchase id for the assoicated bonus item
        
            UserDefaults.standard.setValue(true, forKey: purchaseId)
        } else {
            /// mark the general fact of support
            UserDefaults.standard.setValue(true, forKey: "didSupportApp")
        }
        
        UserDefaults.standard.synchronize()

    }
    
    public static func checkPurchase(_ purchaseId: String? = nil) -> Bool {
        
        guard let purchaseId = purchaseId else {
            return UserDefaults.standard.bool(forKey: "didSupportApp")
        }
        
        return UserDefaults.standard.bool(forKey:purchaseId)
    }
    
    
    
}




enum SalesText: String {
    case standard = "SalesPitch"
    case bonus = "SalesPitchBonus"
    case returning = "SalesPitchReturningCustomer"
}

enum SuccessText: String {
    case standard = "Thanks"
    case bonus = "ThanksBonus"
    case returning = "ThanksReturningCustomer"
}

enum SuccessButtonText: String {
    case standard = "Continue"
    case bonus = "Bonus"
    case amen = "Amen"
}
