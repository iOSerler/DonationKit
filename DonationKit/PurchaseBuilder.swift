import Foundation

public class PurchaseBuilder {
    public let view: PurchaseViewDelegate
    public let presenter: PurchasePresenter
    
    
    public init(analytics: AbstractAnalytics?,
                purchaseProductIdentifiers: [ProductIdentifier],
                config: PurchaseConfiguration?,
                storage: PurchaseStorage) {
        
        self.presenter = PurchasePresenter(
            analytics: analytics,
            purchaseProductIdentifiers: purchaseProductIdentifiers,
            config: config,
            storage: storage
        )
        
        self.view = PurchaseController(presenter: presenter)
    }
}

