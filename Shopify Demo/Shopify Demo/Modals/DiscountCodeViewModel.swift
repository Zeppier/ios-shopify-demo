

import MobileBuySDK

final class DiscountCodeViewModel: DiscountApplication, ViewModel {
    
    typealias ModelType = Storefront.DiscountCodeApplication

    let model: ModelType
    let name:  String
    

    //  MARK: - Init -
    
    required init(from model: ModelType) {
        self.model = model
        self.name  = model.code
    }
}

extension Storefront.DiscountCodeApplication: ViewModeling {
    typealias ViewModelType = DiscountCodeViewModel
}
