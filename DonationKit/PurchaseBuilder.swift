import Foundation

public class PurchaseBuilder {
    public let view: PurchaseViewDelegate
    public let presenter: PurchasePresenter
    
    
    public init(purchaseProductIdentifiers: [ProductIdentifier],
                config: PurchaseConfiguration?,
                storage: PurchaseStorage,
                analyticsDelegate: DonationAnalyticsDelegate?) {

        self.presenter = PurchasePresenter(
            purchaseProductIdentifiers: purchaseProductIdentifiers,
            config: config,
            storage: storage,
            analyticsDelegate: analyticsDelegate
        )
        
        self.view = PurchaseController(presenter: presenter)
    }
}

