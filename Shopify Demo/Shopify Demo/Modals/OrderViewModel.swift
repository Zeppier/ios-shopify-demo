

import Foundation
import MobileBuySDK
final class OrderViewModel: ViewModel {
    
    typealias ModelType = Storefront.OrderEdge
    
    let model:       ModelType
    let cursor:      String
    
    let id:          String
    let number:      Int
    let email:       String?
    let totalPrice:  Decimal
    

    //  MARK: - Init -

    required init(from model: ModelType) {
        self.model       = model
        self.cursor      = model.cursor
        
        self.id          = model.node.id.rawValue
        self.number      = Int(model.node.orderNumber)
        self.email       = model.node.email
        self.totalPrice  = model.node.totalPriceV2.amount
    }
}

extension Storefront.OrderEdge: ViewModeling {
    typealias ViewModelType = OrderViewModel
}
