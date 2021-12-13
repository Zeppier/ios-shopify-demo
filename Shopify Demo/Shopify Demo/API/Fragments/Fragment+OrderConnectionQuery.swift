

import MobileBuySDK
extension Storefront.OrderConnectionQuery {
    
    @discardableResult
    func fragmentForStandardOrder() -> Storefront.OrderConnectionQuery { return self
        .pageInfo { $0
            .hasNextPage()
        }
        .edges { $0
            .cursor()
            .node { $0
                .id()
                .orderNumber()
                .email()
                .totalPriceV2 { $0
                    .amount()
                    .currencyCode()
                }
            }
        }
    }
}
