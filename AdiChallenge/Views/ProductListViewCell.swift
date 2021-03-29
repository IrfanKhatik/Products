//
//  ProductListViewCell.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductListViewCell: View {
    
    // Observable property for ProductViewModel to provide product values.
    @ObservedObject var productViewModel : ProductViewModel
    
    // State Property for showing ProductDetailView view or not
    @State private var isProductDetailPresented = false
    
    init(productViewModel: ProductViewModel) {
        // Dependancy injection
        self.productViewModel = productViewModel
        
    }
    
    // Calculate product image size
    private var imageSize: CGFloat {
        var lesserSize =  UIScreen.main.bounds.width
        if lesserSize > UIScreen.main.bounds.height {
            lesserSize = UIScreen.main.bounds.height
        }
        
        return lesserSize * 0.5
    }
    
    var body: some View {
        
        HStack {
            
            // Add product image
            ProductImageView(
                url: URL(string: self.productViewModel.imageUrl)!,
                
                placeholder: {
                    // Show progressview until image downloaded as placeholder
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center) },
                
                image: {
                    // Show image once image downloaded and cached
                    Image(uiImage: $0)
                        .resizable()
                    
                }
            )
            .frame(width: imageSize, height: imageSize)
            .aspectRatio(contentMode: .fit)
            
            VStack(alignment:.leading) {
                
                // Add product name
                Text(productViewModel.name)
                    .textStyle(ProductTitleTextStyle())
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5))
                
                // Add product desc
                Text(productViewModel.desc)
                    .textStyle(ProductDesciptionTextStyle())
                    .lineLimit(3)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                
                // Add product formatted price based on currency
                Text(productViewModel.formattedPrice)
                    .textStyle(ProductDesciptionTextStyle())
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
            }
        }
        .onTapGesture {
            
            LogManager.shared.uiLogger.log(level: .info, "[Adidas] Product selected: \(self.productViewModel.id, privacy: .private(mask: .hash))")
            
            // Show product detail view on tap
            isProductDetailPresented.toggle()
        }
        .fullScreenCover(isPresented: $isProductDetailPresented) {
            
            // Present full screen product detail view.
            ProductDetailView(productViewModel: productViewModel)
            
        }
    }
}

struct ProductViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let reviews = [
            Review(id: "ABC", locale: "nl_NL", rating: 4, text: "This is first review on product"),
            Review(id: "PQR", locale: "nl_NL", rating: 4, text: "This product very nice and easy to use.")
        ]
        
        NavigationView {
            
            ProductListViewCell(productViewModel: ProductViewModel(Product(id: "HI334",
                                                                           name: "Y-3",
                                                                           imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                           desc: "Y-3 GR.1P HIGH GTX",
                                                                           price: 12,
                                                                           currency: "en_US",
                                                                           reviews: reviews)))
        }
    }
}
