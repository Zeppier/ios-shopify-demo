
//

import UIKit
import Buy
import UserNotifications
import Intempt

protocol productDelegate: class {
    func changeEvent(status : Bool)
}
class ProductsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: StorefrontCollectionView!
    
    var graph: Graph!
    var collection: CollectionViewModel!
    var delegate: productDelegate?
    var isCartUpdated:Bool = false
    fileprivate let columns: Int = 2
    fileprivate var products: PageableArray<ProductViewModel>!
    
    //  MARK: - View Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //status, result, error
        /*IntemptTracker.beacon(withOrgId: BeaconConfig.orgId, andSourceId: BeaconConfig.sourceId, andToken: BeaconConfig.token, andDeviceUUID: BeaconConfig.uuid) { (status, result, error) in
            if(status) {
                NSLog("Beacon Initalization successful.")
                if let dictResult = result as? [String: Any] {
                    print(dictResult)
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }*/
        
        IntemptTracker.beacon(withOrgId: BeaconConfig.orgId, andSourceId: BeaconConfig.sourceId, andToken: BeaconConfig.token, andDeviceUUID: BeaconConfig.uuid) { (status, result, error) in
            if(status) {
                NSLog("beacon initialization successful")
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        IntemptClient.shared()?.delegate = self

        self.configureCollectionView()
        
        Client.shared.fetchProducts(in: self.collection) { products in
            if let products = products {
                self.products = products
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true);

    }
    
    //  MARK: - Actions -
    
    @IBAction private func back(_ sender: UIBarButtonItem) {
        delegate?.changeEvent(status: isCartUpdated)
        self.navigationController?.popViewController(animated: true)
    }

    private func configureCollectionView() {
        self.collectionView.paginationDelegate = self
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.collectionView)
        }
    }
    
    @IBAction func cartAction(_ sender: Any) {
        let cartController: CartNavigationController = self.storyboard!.instantiateViewController()
        self.navigationController!.present(cartController, animated: true, completion: nil)
    }
    
    // MARK: Notifcations Methods
    
    func postNotification(body:String) {
        let content = UNMutableNotificationContent()
        content.title = "Greetings!"
        content.body = body
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "EntryNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


//  MARK: - UIViewControllerPreviewingDelegate -

extension ProductsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let collectionView = previewingContext.sourceView as! UICollectionView
        if let indexPath = collectionView.indexPathForItem(at: location),
            let frame = collectionView.rectForItem(at: indexPath) {
            
            previewingContext.sourceRect = frame
            
            let cell = collectionView.cellForItem(at: indexPath) as! ProductCell
            return productDetailsViewControllerWith(cell.viewModel!)
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController!.show(viewControllerToCommit, sender: self)
    }
}

//  MARK: - PaginationDelegate -

extension ProductsViewController: StorefrontCollectionViewDelegate {
    
    func collectionViewShouldBeginPaging(_ collectionView: StorefrontCollectionView) -> Bool {
        return self.products?.hasNextPage ?? false
    }
    
    func collectionViewWillBeginPaging(_ collectionView: StorefrontCollectionView) {
        if let products = self.products,
            let lastProduct = products.items.last {
            
            Client.shared.fetchProducts(in: self.collection, after: lastProduct.cursor) { products in
                if let products = products {
                    self.products.appendPage(from: products)
                    
                    self.collectionView.reloadData()
                    self.collectionView.completePaging()
                }
            }
        }
    }
    
    func collectionViewDidCompletePaging(_ collectionView: StorefrontCollectionView) {
        
    }
}


//  MARK: - UICollectionViewDataSource -

extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.className, for: indexPath) as! ProductCell
        let product = self.products.items[indexPath.item]
        
        cell.configureFrom(product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius  = 4.0
        cell.layer.masksToBounds = true
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout -

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSpacing = layout.minimumInteritemSpacing * CGFloat(self.columns - 1)
        let sectionSpacing = layout.sectionInset.left + layout.sectionInset.right
        let length = (collectionView.bounds.width - itemSpacing - sectionSpacing) / CGFloat(self.columns)
        
        return CGSize(
            width:  length,
            height: length + 80.0
        )
    }
}



//  MARK: - UICollectionViewDelegate -

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.products.items[indexPath.item]
        let controller = productDetailsViewControllerWith(product)
        controller.delegate = self
        self.navigationController!.show(controller, sender: self)

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ProductsViewController: ProductDetailsDelegate {
    func changeEvent(status: Bool) {
        isCartUpdated = status
    }
}

extension ProductsViewController:intemptDelegate {
    // MARK: iBeacon Delegate Methods
    
    func didEnterRegion(_ beaconData: CLBeacon!) {
        self.postNotification(body: "You entered in the store")
    }
    
    func didExitRegion(_ beaconData: CLBeacon!) {
        self.postNotification(body: "You exited from the store!")
    }

}
