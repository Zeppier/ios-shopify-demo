

import MobileBuySDK

final class ScriptCodeViewModel: DiscountApplication, ViewModel {
    
    typealias ModelType = Storefront.ScriptDiscountApplication
    
    let model: ModelType
    let name:  String
    

    //  MARK: - Init -

    required init(from model: ModelType) {
        self.model = model
        self.name  = model.title
    }
}

extension Storefront.ScriptDiscountApplication: ViewModeling {
    typealias ViewModelType = ScriptCodeViewModel
}
