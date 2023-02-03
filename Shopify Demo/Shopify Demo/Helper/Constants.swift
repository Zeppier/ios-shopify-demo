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
let APP_DELEGATE: AppDelegate = UIApplication.shared.delegate as! AppDelegate

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
    ///Please go to https://app.staging.intempt.com/sources/ and obtain Intempt credentials
    ///Source = Intempt eCommerce Store,
    ///whb.niazi619@gmail.com
    ///Wahab_123
    static let orgId = "demo-project"
    static let projectId = "demo-project"
    static let sourceId = "451472423155269632"
    static let token = "67fc2a5ec4ec49bd958111dee290c814.7247e4736bbf4a218022bfdf548ae220"
    //static let token = "aa91c7709d684d75820ac4456ff0d7a1.34c41b7a90fc4790aeaaabdd65f390c7"
}

/// This is optional. If you use beacon fetaures then only you should use this
struct BeaconConfig {
///Please go to https://app.intempt.com/home create an beacon app and obtain Intempt credentials

    ///Source = Shopify Demp app
    static let orgId = "test-organization-x1"
    static let sourceId = "302664524644634624"
    static let token = "LpJSBrZTGUd125TsHKCbQ_LdNNqcQamg.Qy2xNGiw_4i9wgzNTl7s2kqlaJbgbIh-aPeFJeqPopVKEEz-F-18fNh3wKI4D8Ig"
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


