

import MobileBuySDK
struct PageableArray<T: ViewModel> {
    
    private(set) var items: [T]
    
    var hasNextPage: Bool {
        return pageInfo.hasNextPage
    }
    
    var hasPreviousPage: Bool {
        return pageInfo.hasPreviousPage
    }
    
    private var pageInfo: Storefront.PageInfo
    
    //  MARK: - Init -

    init(with items: [T], pageInfo: Storefront.PageInfo) {
        self.items    = items
        self.pageInfo = pageInfo
    }
    
    init<M>(with items: [M], pageInfo: Storefront.PageInfo) where M: ViewModeling, M.ViewModelType == T {
        self.items    = items.viewModels
        self.pageInfo = pageInfo
    }
    
    //  MARK: - Adding -
    
    mutating func appendPage(from pageableArray: PageableArray<T>) {
        
        print(items)
        self.items.append(contentsOf: pageableArray.items)
        self.pageInfo = pageableArray.pageInfo
    }
    mutating func appendPage1(from pageableArray: PageableArray<T>) {
        
        print(items)
        self.items.append(pageableArray.items[0])
        self.pageInfo = pageableArray.pageInfo
    }
}
