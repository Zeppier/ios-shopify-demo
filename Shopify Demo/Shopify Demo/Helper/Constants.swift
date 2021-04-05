//
//  Constants.swift
//  Shopify Demo
//
//  Created by Intempt on 25/08/20.
//  Copyright © 2020 Intempt. All rights reserved.
//

import Foundation
import UIKit

let AppTitle = Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String
let stroryboard = UIStoryboard(name: "Main", bundle: nil)
let appDel = UIApplication.shared.delegate as! AppDelegate
let flagKey = "retail-ecommerce-demo-1-category-affinity-dresses-ios"

enum Environment: String {
    case staging = "https://api.staging.intempt.com/v1/"
    case production = "https://api.intempt.com/v1/"
}
let environment: Environment = .production


struct API {
    static let baseURL = environment.rawValue
    
    //Endpoints
    static let segment = IntemptOptions.orgId + "/segmentations/latest"
}

struct IntemptOptions {
    //Please go to https://app.intempt.com/home and obtain Intempt credentials
    
    static let orgId = "playground" // Example: intempt-hotel-demo
    static let sourceId = "137340365627670528" //Example: 1111111111111111
    static let token = "ST-JuK8lbjIMD_NDdj0ibYVtLM0tGKyo.cyptoYSlnwCm-LXNiTcAdT_gt5z82fE59EZ8antlMm1L835BvMPiAwwS8hYtch1U" //Example: jAxLS9GWwxGHbJWQAMIDG3tWvDP53e4
}

// This is optional. If you use beacon fetaures then only you should use this
struct BeaconConfig {
//Please go to https://app.intempt.com/home create an beacon app and obtain Intempt credentials

    static let orgId = "playground"
    static let sourceId = "137253757784113152"
    static let token = "Ik2awm7NSaQrtp1PEm77V7bpxUnvwVzK.1YUZHo5e4jnGtZPO3wI0zUJySAG9rdgwNjX-U1uOT62G5lAeq_05li1DPhfOkDpu"
    static let uuid = "f2789bb4-39e3-46bd-98f0-4c1212d13c87" //Example: f2789bb4-39e3-46bd-98f0-4c1212d13c87
}


struct Shopify {
    //Please go to https://shopify.dev/tools/libraries/storefront-api/ios and obtain credentials
    
    static let shopDomain = "intempt1.myshopify.com" //Example: company.myshopify.com
    static let apiKey = "aae05a2034d5eef85db5cd073d6acbd4" //Example: aae05a5437d5eef88db5cd877d6acbd9
    static let merchantID = "merchant.com.your.id" //Example: merchant.com.your.id
    static let locale = Locale(identifier: "en-US")
}




// MARK: - Alert
func showAlert(title: String, message: String, vc: UIViewController) -> Void {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alert.addAction(cancelAction)
    vc.present(alert, animated: true, completion: nil)
}

//MARK: - Helper Methods

func productDetailsViewControllerWith(_ product: ProductViewModel) -> ProductDetailsViewController {
    let controller: ProductDetailsViewController = stroryboard.instantiateViewController()
    controller.product = product
    return controller
}


