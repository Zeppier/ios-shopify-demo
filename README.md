# Sample eCommerce iOS app

A sample app which demonstrates how to configure ecommerce with the combination of `Intempt.framework` and `Shopify`. [Shopify](https://shopify.dev/tools/libraries/storefront-api/ios) provides a suite of API which helps a merchent to deploy an eCommerce app with ease.


## Requirements

- Minimum iOS 12.0+
- Minimum Xcode 10.0+

## Installation

1. Download the `Intempt.framework` from [here](https://github.com/intempt/).

2. Download the code from this repo. 
3. Navigate inside the `IntemptShop Demo` folder and then run `pod install`
5. Drag & drop the `Intempt.framework` into your project, underneath your project's folder and **NOT** in the `Frameworks` folder (if exits).
6. Select Project --> General --> Frameworks, Libraries, and Embedded Content and the newly installed `Intempt.framework` must set to Embed & Sign.
7. Once done open `IntemptShop Demo.xcworkspace`
8. Go to `Constants.swift` and configure `orgId`, `sourceId`, `token` obtained from Intempt [Developers](https://app.intempt.com/home) site.
9. Don't forget to configure `Shopify` credentials if you are going to use `Shopify`.  
 
