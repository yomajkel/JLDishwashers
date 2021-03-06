import Quick
import Nimble
@testable import JLDishwashers

class ProductsGridDataSourceSpec: QuickSpec {
    override func spec() {
        describe("products grid data source") {
            var dataSource: ProductsGridDataSource!
            var serviceStub: ProductsServiceStub!
            beforeEach {
                serviceStub = ProductsServiceStub()
                dataSource = ProductsGridDataSource(service: serviceStub)
            }
            
            it("should have 1 section") {
                expect(dataSource.numberOfSectionsInCollectionView(ProductsGridHelper.collectionView())) == 1
            }
            
            context("after loading empty data") {
                beforeEach {
                    dataSource.products = [ProductsHelper.searchProduct()]
                    dataSource.loadData({ _ in })
                }
                
                it("should have empty products list") {
                    expect(dataSource.products).to(beNil())
                }
                
            }
            
            context("after loading products") {
                beforeEach {
                    serviceStub.completionArgument = .Right([ProductsHelper.searchProduct()])
                    dataSource.loadData({ _ in })
                }
                
                it("should have products") {
                    expect(dataSource.products?.count) == 1
                }
                
                it("should give corresponding number of items in section") {
                    expect(dataSource.collectionView(ProductsGridHelper.collectionView(), numberOfItemsInSection: 0)) == 1
                }
                
                it("should setup cell accordingly") {
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    let cell = dataSource.collectionView(ProductsGridHelper.collectionView(), cellForItemAtIndexPath: indexPath) as! ProductCollectionViewCell
                    expect(cell.titleLabel.text) == "A product"
                    expect(cell.priceLabel.text) == "£123.00"
                }
                
                it("should return correct product for index path") {
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    let product = dataSource.productForIndexPath(indexPath)
                    expect(product?.productId) == "234"
                }
            }
        }
    }
    
    
}

private class ProductsServiceStub: ProductsService {
    var completionArgument: SearchResult = .Right(nil)
    
    override func fetchList(completion: SearchResult -> Void) {
        completion(completionArgument)
    }
}
