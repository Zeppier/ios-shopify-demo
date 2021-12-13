

import MobileBuySDK
//import Pay
extension ShippingRateViewModel {
    
    var payShippingRate: PayShippingRate {
        
        return PayShippingRate(
            handle:        self.handle,
            title:         self.title,
            price:         self.price,
            deliveryRange: nil
        )
    }
}

extension Array where Element == ShippingRateViewModel {

    var payShippingRates: [PayShippingRate] {
        return self.map {
            $0.payShippingRate
        }
    }
}
