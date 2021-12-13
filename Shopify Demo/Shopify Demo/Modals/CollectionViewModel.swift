

import Foundation
import MobileBuySDK
final class CollectionViewModel: ViewModel {
    
    typealias ModelType = Storefront.CollectionEdge
    
    let model:       ModelType
    let cursor:      String
    
    let id:          String
    let title:       String
    let description: String
    let imageURL:    URL?
    var products:    PageableArray<ProductViewModel>
    

    //  MARK: - Init -

    required init(from model: ModelType) {
        self.model       = model
        self.cursor      = model.cursor
    
        self.id          = model.node.id.rawValue
        self.title       = model.node.title
        self.imageURL    = model.node.image?.transformedSrc
        self.description = model.node.descriptionHtml
        
        self.products    = PageableArray(
            with:     model.node.products.edges,
            pageInfo: model.node.products.pageInfo
        )
    }
}

extension Storefront.CollectionEdge: ViewModeling {
    typealias ViewModelType = CollectionViewModel
}
