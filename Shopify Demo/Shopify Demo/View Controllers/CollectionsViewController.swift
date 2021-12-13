

import UIKit
import MobileBuySDK
import Intempt

class CollectionsViewController: UIViewController, LoginControllerDelegate {
    func loginControllerDidCancel(_ loginController: LoginViewController) {
        
    }
    func loginController(_ loginController: LoginViewController, didLoginWith email: String, passowrd: String) {
        if UserSession.getUser() != nil{
            self.navigationItem.leftBarButtonItem?.title = "Logout"
        }
    }
    
  
    @IBOutlet weak var tableView: StorefrontTableView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    var flagProspect = false

    fileprivate var collections: PageableArray<CollectionViewModel>!
    fileprivate var collections1: PageableArray<CollectionViewModel>!

    //  MARK: - View Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(IntemptOptions.orgId == "Your Organization Id" || IntemptOptions.sourceId == "Your Source Id" || IntemptOptions.orgId == "Your Token") {
            //assertionFailure("Please configure your Intempt profile to proceed.")
            print("Please configure your Intempt profile to proceed.")
            //return
        }

        //self.fetchCollections()
        self.fetchSegmentWith(sourceId: IntemptOptions.sourceId, visitorId: (IntemptClient.shared()?.getVisitorId())!)

        self.lbl1.text = "Accessories"
        self.lbl2.text = "Pants"
        self.lbl3.text = "Sale"
        self.lbl4.text = "Jackets"
        self.lbl5.text = "Shoes"
        self.lbl6.text = "Dresses"
        
        self.tableView.isHidden = true
        self.scrolView.contentSize = CGSize (width: self.scrolView.frame.size.width, height: self.footerView.frame.origin.y + self.footerView.frame.size.height+130)
        self.configureTableView()
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        APP_DELEGATE.delay(15){
            LocationsManager.sharedInstance.startGtettingLocation()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetails), name: NSNotification.Name(rawValue: "updateUserDetails"), object: nil)
    }
    
    private func configureTableView() {
        self.tableView.paginationDelegate = self
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true);

        self.updateUserDetails()
    }
    
    @objc func updateUserDetails(){
        if UserSession.getUser() != nil{
            self.navigationItem.leftBarButtonItem?.title = "Logout"
        }
    }
    
    @IBAction func loginPressed() {
    
        if UserSession.getUser() != nil{
            let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                UserSession.logoutUser()
                self.navigationItem.leftBarButtonItem?.title = "Login"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let coordinator: LoginViewController = self.storyboard!.instantiateViewController()
            coordinator.delegate = self
            self.present(coordinator, animated: true, completion: nil)
        }
    }
    //  MARK: - Fetching products -
    
    fileprivate func fetchCollections(after cursor: String? = nil) {
        
        Client.shared.fetchCollections(after: cursor) { collections in
            if let collections = collections {
                if collections.items.count > 0 {
                    self.blurView.isHidden = true
                }
                else{
                    self.blurView.isHidden = false
                }
                //print("data---\(collections.items)")

                self.collections = collections
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchSegmentWith(sourceId:String, visitorId:String) {
        
        let strUrl = API.baseURL + API.segment + "?sourceId=\(sourceId)&profile={\"visitorId\":\"\(visitorId)\"}"
        //let strUrl = API.baseURL + "playground/segmentations/latest?profileId=120946287348477954"
        
        guard let urlQuery = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlQuery) else {
            showAlert(title: AppTitle, message: "URL is not valid.", vc: self)
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 180)
        request.httpMethod = "GET"
        
        print("Request URL: \(urlQuery)")

        let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    showAlert(title: AppTitle, message: error?.localizedDescription ?? "No specific error found.", vc: self)
                }
                else {
                    print("API Segmentation Response:\(String(decoding: data!, as: UTF8.self))")
                    
                    do {
                        let dictJson = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                        
                        if let dictOriginal = dictJson as? [String:Any], let dictEmbedded = dictOriginal["_embedded"] as? [String:Any], let arrSegmentations = dictEmbedded["segmentations"] as? [[String:Any]]  {
                            
                            for dictSegment in arrSegmentations {
                                if let saasProspectStatus = dictSegment[flagKey] as? Bool {
                                    self.flagProspect = saasProspectStatus
                                }
                            }
                        }
                    }
                    catch let err {
                        //showAlert(title: AppTitle, message: err.localizedDescription, vc: self)
                        print("fetchSegmentWith=", err.localizedDescription)
                    }
                    self.clickAction(self)
                    self.fetchCollections()
                }
            }
        }
        dataTask.resume()
    }
    
    //  MARK: - Navigate to Product -

    func productsViewControllerWith(_ collection: CollectionViewModel) -> ProductsViewController {
        let controller: ProductsViewController = self.storyboard!.instantiateViewController()
        controller.delegate = self
        controller.collection = collection
        return controller
    }
}

//  MARK: - Actions -

extension CollectionsViewController {
    
    @IBAction private func accountAction(_ sender: UIBarButtonItem) {
       
            let coordinator: CustomerCoordinator = self.storyboard!.instantiateViewController()
            self.present(coordinator, animated: true, completion: nil)
        
    }
    
    @IBAction private func cartAction(_ sender: Any) {
        let cartController: CartNavigationController = self.storyboard!.instantiateViewController()
        self.navigationController!.present(cartController, animated: true, completion: nil)
    }
    
    @IBAction private func clickCollectionAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if self.flagProspect == false {
                let collection = self.collections.items[1]
                self.productsList(collection: collection)
                
            }
            else{
                let collection = self.collections.items[8]
                self.productsList(collection: collection)
            }
        }
        else  if sender.tag == 1 {
            if self.flagProspect == false {
                let collection = self.collections.items[2]
                self.productsList(collection: collection)
                    
            }
            else {
                let collection = self.collections.items[8]
                self.productsList(collection: collection)
                    
            }
        }
        else  if sender.tag == 2 {
            if self.flagProspect == false {
                let collection = self.collections.items[3]
                self.productsList(collection: collection)
                
            }
            else{
                let collection = self.collections.items[7]
                self.productsList(collection: collection)
            }
        }
        else if sender.tag == 3 {
            if self.flagProspect == false {
                let collection = self.collections.items[10]
                self.productsList(collection: collection)
            }
            else {
                let collection = self.collections.items[6]
                self.productsList(collection: collection)
            }
        }
        else  if sender.tag == 4 {
            if self.flagProspect == false {
                let collection = self.collections.items[11]
                self.productsList(collection: collection)

            }
            else {
                let collection = self.collections.items[5]
                self.productsList(collection: collection)
            }
        }
        else if sender.tag == 5 {
            if self.flagProspect == false {
                let collection = self.collections.items[8]
                let productsController = self.productsViewControllerWith(collection)
                productsController.delegate = self
                self.navigationController?.pushViewController(productsController, animated: true)
            }
            else {
                let collection = self.collections.items[4]
                self.productsList(collection: collection)
           }
        }
    }

    func productsList(collection: CollectionViewModel) {
        let productsController = self.productsViewControllerWith(collection)
        productsController.delegate = self
        self.navigationController?.pushViewController(productsController, animated: true)
    }
      
    @IBAction private func clickAction(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            
            if self.flagProspect == true {
                self.bannerImage.image = UIImage.init(named: "2.png")
                self.img1.image = UIImage.init(named: "A1.png")
                self.img2.image = UIImage.init(named: "A2.png")
                self.img3.image = UIImage.init(named: "A3.png")
                self.img4.image = UIImage.init(named: "A4.png")
                self.img5.image = UIImage.init(named: "A5.png")
                self.img6.image = UIImage.init(named: "dress1.png")
                self.img7.image = UIImage.init(named: "i13.png")
                self.img8.image = UIImage.init(named: "i16.png")
          
                self.lbl1.text = "A-line dresses"
                self.lbl2.text = "Mini dresses"
                self.lbl3.text = "Shift dresses"
                self.lbl4.text = "Bodycon dresses"
                self.lbl5.text = "Midi dresses"
                self.lbl6.text = "Off-the-shoulder dresses"

                //self.flagProspect = true
            }
            else {
                self.bannerImage.image = UIImage.init(named: "1.png")

                self.img1.image = UIImage.init(named: "bag.png")
                self.img2.image = UIImage.init(named: "pants.png")
                self.img3.image = UIImage.init(named: "sale.png")
                self.img4.image = UIImage.init(named: "jackets.png")
                self.img5.image = UIImage.init(named: "shoes.png")
                self.img6.image = UIImage.init(named: "dress.png")

                self.img7.image = UIImage.init(named: "i12.png")
                self.img8.image = UIImage.init(named: "i15.png")

                self.lbl1.text = "Accessories"
                self.lbl2.text = "Pants"
                self.lbl3.text = "Sale"
                self.lbl4.text = "Jackets"
                self.lbl5.text = "Shoes"
                self.lbl6.text = "Dresses"
                
                //self.flagProspect = false
            }
        }
    }
}

//  MARK: - UIViewControllerPreviewingDelegate -

extension CollectionsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let tableView = previewingContext.sourceView as! UITableView
        if let indexPath = tableView.indexPathForRow(at: location) {
            
            let cell  = tableView.cellForRow(at: indexPath) as! CollectionCell
            let touch = cell.convert(location, from: tableView)
            
            if let productResult = cell.productFor(touch) {
                previewingContext.sourceRect = tableView.convert(productResult.sourceRect, from: cell)
                return productDetailsViewControllerWith(productResult.model)
                
            } else if let collectionResult = cell.collectionFor(touch) {
                previewingContext.sourceRect = tableView.convert(collectionResult.sourceRect, from: cell)
                return self.productsViewControllerWith(collectionResult.model)
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController!.show(viewControllerToCommit, sender: self)
    }
}


//  MARK: - StorefrontTableViewDelegate -

extension CollectionsViewController: StorefrontTableViewDelegate {
    
    func tableViewShouldBeginPaging(_ table: StorefrontTableView) -> Bool {
        return self.collections?.hasNextPage ?? false
    }
    
    func tableViewWillBeginPaging(_ table: StorefrontTableView) {
        if let collections = self.collections,
            let lastCollection = collections.items.last {
            
            Client.shared.fetchCollections(after: lastCollection.cursor) { collections in
                if let collections = collections {
                    
                    self.collections.appendPage(from: collections)
                    
                    
                    self.tableView.reloadData()
                    self.tableView.completePaging()
                }
            }
        }
    }
    
    func tableViewDidCompletePaging(_ table: StorefrontTableView) {
        
    }
}


//  MARK: - CollectionCellDelegate -

extension CollectionsViewController: CollectionCellDelegate {
    
    func cell(_ collectionCell: CollectionCell, didRequestProductsIn collection: CollectionViewModel, after product: ProductViewModel) {
        
        Client.shared.fetchProducts(in: collection, limit: 20, after: product.cursor) { products in
            if let products = products, collectionCell.viewModel === collection {
                collectionCell.appendProductsPage(from: products)
            }
        }
    }
    
    func cell(_ collectionCell: CollectionCell, didSelectProduct product: ProductViewModel) {
        let detailsController: ProductDetailsViewController = self.storyboard!.instantiateViewController()
        detailsController.product = product
        self.navigationController!.show(detailsController, sender: self)
    }
}


//  MARK: - UICollectionViewDataSource -

extension CollectionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.collections?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.className, for: indexPath) as! CollectionCell
        let collection = self.collections.items[indexPath.section]
        
        cell.delegate = self
        cell.configureFrom(collection)
        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.collections.items[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.collections.items[section].description
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let width = tableView.bounds.width
        let height = width * 0.75 // 3:4 ratio
        
        return height + 150.0 // 150 is the height of the product collection
    }
}


//  MARK: - UICollectionViewDelegate -

extension CollectionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = self.collections.items[indexPath.section]
        let productsController = self.productsViewControllerWith(collection)
        productsController.delegate = self
        self.navigationController!.show(productsController, sender: self)
    }
}


//  MARK: - ProductsDelegate

extension CollectionsViewController: productDelegate {
    func changeEvent(status:Bool) {
        
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.blurView.isHidden = false
                self.fetchSegmentWith(sourceId: IntemptOptions.sourceId, visitorId: (IntemptClient.shared()?.getVisitorId())!)
            }
        }
        
        
        
          /*UIView.animate(withDuration: 1.0) {
                  
            if self.flagProspect == false {
                self.bannerImage.image = UIImage.init(named: "2.png")
                self.img1.image = UIImage.init(named: "A1.png")
                self.img2.image = UIImage.init(named: "A2.png")
                self.img3.image = UIImage.init(named: "A3.png")
                self.img4.image = UIImage.init(named: "A4.png")
                self.img5.image = UIImage.init(named: "A5.png")
                self.img6.image = UIImage.init(named: "dress1.png")
                self.img7.image = UIImage.init(named: "i13.png")
                self.img8.image = UIImage.init(named: "i16.png")
        
                self.lbl1.text = "A-line dresses"
                self.lbl2.text = "Mini dresses"
                self.lbl3.text = "Shift dresses"
                self.lbl4.text = "Bodycon dresses"
                self.lbl5.text = "Midi dresses"
                self.lbl6.text = "Off-the-shoulder dresses"

                self.flagProspect = true
            }
            else {
                self.bannerImage.image = UIImage.init(named: "2.png")
                self.img1.image = UIImage.init(named: "bag.png")
                self.img2.image = UIImage.init(named: "pants.png")
                self.img3.image = UIImage.init(named: "sale.png")
                self.img4.image = UIImage.init(named: "jackets.png")
                self.img5.image = UIImage.init(named: "shoes.png")
                self.img6.image = UIImage.init(named: "dress.png")
                self.img7.image = UIImage.init(named: "i13.png")
                self.img8.image = UIImage.init(named: "i16.png")

                self.lbl1.text = "Accessories"
                self.lbl2.text = "Pants"
                self.lbl3.text = "Sale"
                self.lbl4.text = "Jackets"
                self.lbl5.text = "Shoes"
                self.lbl6.text = "Dresses"

                self.flagProspect = false
            }
        }*/
    }
    
}



