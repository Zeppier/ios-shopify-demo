

import MobileBuySDK

final class ManualCodeViewModel: DiscountApplication, ViewModel {
    
    typealias ModelType = Storefront.ManualDiscountApplication
    
    let model: ModelType
    let name:  String
    

    //  MARK: - Init -
    
    required init(from model: ModelType) {
        self.model = model
        self.name  = model.title
    }
}

extension Storefront.ManualDiscountApplication: ViewModeling {
    typealias ViewModelType = ManualCodeViewModel
}
