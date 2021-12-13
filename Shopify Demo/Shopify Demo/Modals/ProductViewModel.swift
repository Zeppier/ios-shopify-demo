

import Foundation
import MobileBuySDK
final class ProductViewModel: ViewModel {
    
    typealias ModelType = Storefront.ProductEdge
    
    let model:    ModelType
    let cursor:   String
    
    let id:       String
    let title:    String
    var summary:  String
    let price:    String
    let images:   PageableArray<ImageViewModel>
    let variants: PageableArray<VariantViewModel>
    

    //  MARK: - Init -
    
    required init(from model: ModelType) {
        self.model    = model
        self.cursor   = model.cursor
        
        let variants = model.node.variants.edges.viewModels.sorted {
            $0.price < $1.price
        }
        
        let lowestPrice = variants.first?.price
        
        self.id       = model.node.id.rawValue
        self.title    = model.node.title
        self.summary  = model.node.descriptionHtml
        self.price    = lowestPrice == nil ? "No price" : Currency.stringFrom(lowestPrice!)
        
        self.images   = PageableArray(
            with:     model.node.images.edges,
            pageInfo: model.node.images.pageInfo
        )
        
        self.variants = PageableArray(
            with:     model.node.variants.edges,
            pageInfo: model.node.variants.pageInfo
        )
    }
}

extension Storefront.ProductEdge: ViewModeling {
    typealias ViewModelType = ProductViewModel
}
