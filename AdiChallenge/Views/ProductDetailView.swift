//
//  ProductDetailView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAddRatingView = false
    
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(alignment:.leading) {
                    
                    ProductImageView(
                        url: URL(string: self.productViewModel.imageUrl)!,
                        placeholder: { ProgressView() },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        
                        HStack(alignment: .center) {
                            
                            Text(self.productViewModel.name)
                                .textStyle(PrimaryTextStyle())
                            
                            Spacer()
                            
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                        
                        HStack {
                            
                            Text(self.productViewModel.formattedPrice)
                                .textStyle(SecondaryTextStyle())
                            
                            Spacer()
                            
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                        
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        
                        HStack {
                            
                            Text(self.productViewModel.desc)
                                .textStyle(SecondaryTextStyle())
                            
                            Spacer()
                            
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    }
                    
                    Divider()
                    
                    LazyVStack(alignment: .leading) {
                        
                        ForEach(self.productViewModel.reviews) { review in
                            
                            VStack(alignment:.leading) {
                                
                                Text(review.text)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                                
                                HStack {
                                    
                                    Spacer()
                                    
                                    ProductRatingView(rating: .constant(review.rating),
                                                      spacing: .constant(0.0),
                                                      label: .constant(""),
                                                      isEditable: .constant(false))
                                        .padding(.trailing, 10)
                                    
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Back") {
                        
                        LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Back tapped: \(self.productViewModel.id, privacy: .public)")
                        
                        withAnimation {
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    
                    Button("Add review") {
                        
                        LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Add review tapped: \(self.productViewModel.id, privacy: .public)")
                        
                        showAddRatingView.toggle()
                        
                    }.sheet(isPresented: $showAddRatingView) {
                        
                        return AddProductReview(productViewModel:self.productViewModel)
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(self.productViewModel.name, displayMode: .inline)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let reviews = [
            Review(id: "ABC", locale: "nl_NL", rating: 4, text: "This is first review on product"),
            Review(id: "PQR", locale: "nl_NL", rating: 4, text: "This product very nice and easy to use.")
        ]
        ProductDetailView(productViewModel: ProductViewModel(Product(id: "HI334",
                                                                       name: "Product Name",
                                                                       imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                       desc: "description",
                                                                       price: 25.0,
                                                                       currency: "nl_NL",
                                                                       reviews: reviews)))
            .environment(\.sizeCategory, .extraSmall)
    }
}
