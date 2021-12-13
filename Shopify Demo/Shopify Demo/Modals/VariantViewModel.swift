

import Foundation
import MobileBuySDK
final class VariantViewModel: ViewModel {
    
    typealias ModelType = Storefront.ProductVariantEdge
    
    let model:  ModelType
    let cursor: String
    
    let id:     String
    let title:  String
    let price:  Decimal
    

    //  MARK: - Init -

    required init(from model: ModelType) {
        self.model  = model
        self.cursor = model.cursor
        
        self.id     = model.node.id.rawValue
        self.title  = model.node.title
        self.price  = model.node.priceV2.amount
    }
}

extension Storefront.ProductVariantEdge: ViewModeling {
    typealias ViewModelType = VariantViewModel
}
