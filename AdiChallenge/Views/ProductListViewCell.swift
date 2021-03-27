//
//  ProductListViewCell.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductListViewCell: View {
    
    @State private var isPresented = false
    
    @ObservedObject var productViewModel : ProductViewModel
    
    init(productViewModel: ProductViewModel) {
        
        self.productViewModel = productViewModel
        
    }
    
    private var imageSize: CGFloat {
        var lesserSize =  UIScreen.main.bounds.width
        if lesserSize > UIScreen.main.bounds.height {
            lesserSize = UIScreen.main.bounds.height
        }
        
        return lesserSize * 0.5
    }
    
    var body: some View {
        
        HStack {
            
            ProductImageView(
                url: URL(string: self.productViewModel.imageUrl)!,
                
                placeholder: {
                    
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center) },
                
                image: {
                    
                    Image(uiImage: $0)
                        .resizable()
                    
                }
            )
            .frame(width: imageSize, height: imageSize)
            .aspectRatio(contentMode: .fit)
            
            VStack(alignment:.leading) {
                
                Text(productViewModel.name)
                    .textStyle(PrimaryTextStyle())
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5))
                
                Text(productViewModel.desc)
                    .textStyle(SecondaryTextStyle())
                    .lineLimit(3)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                
                Text(productViewModel.formattedPrice)
                    .textStyle(SecondaryTextStyle())
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
            }
        }
        .onTapGesture {
            
            LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Product selected: \(self.productViewModel.id, privacy: .private(mask: .hash))")
            
            isPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPresented) {
            
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
