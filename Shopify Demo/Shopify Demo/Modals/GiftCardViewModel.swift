

import Foundation
import MobileBuySDK
final class GiftCardViewModel: ViewModel {
    
    typealias ModelType = Storefront.AppliedGiftCard
    
    let model:  ModelType
    
    let id:             String
    let balance:        Decimal
    let amountUsed:     Decimal
    let lastCharacters: String
    

    //  MARK: - Init -

    required init(from model: ModelType) {
        self.model            = model
        
        self.id             = model.id.rawValue
        self.balance        = model.balanceV2.amount
        self.amountUsed     = model.amountUsedV2.amount
        self.lastCharacters = model.lastCharacters
    }
}

extension Storefront.AppliedGiftCard: ViewModeling {
    typealias ViewModelType = GiftCardViewModel
}
