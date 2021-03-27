//
//  ProductDetailView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductDetailView: View {
    let productViewModel: ProductViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSheet = false
    
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
                            Text(productViewModel.name)
                                .textStyle(PrimaryTextStyle())
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                        
                        HStack {
                            Text(productViewModel.formattedPrice)
                                .textStyle(SecondaryTextStyle())
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    }.padding(.bottom, 5)
                    
                    HStack {
                        HStack {
                            Text(productViewModel.desc)
                                .textStyle(SecondaryTextStyle())
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    }
                    
                    Divider()
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(productViewModel.reviews) { review in
                            VStack {
                                Text(review.text)
                                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 10))
                                HStack {
                                    Spacer()
                                    ProductRatingView(rating: .constant(review.rating),
                                                      spacing: .constant(5.0))
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Add review") {
                        showingSheet.toggle()
                    }.sheet(isPresented: $showingSheet) {
                        AddProductReview().environmentObject(productViewModel)
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarTitle(productViewModel.name, displayMode: .inline)
            .accentColor(Color(#colorLiteral(red: 0.9294475317, green: 0.9239223003, blue: 0.9336946607, alpha: 1)))
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
                                                                     description: "description",
                                                                     price: 0,
                                                                     currency: "nl_NL",
                                                                     reviews: reviews))).environment(\.sizeCategory, .extraSmall)
        
    }
}