//
//  AddProductReview.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct AddProductReview: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var productViewModel: ProductViewModel
    
    @State private var locale = Locale.current.identifier
    
    @State private var review = ""
    
    @State private var rating = 0
    
    var body: some View {
        Form {
            Section {
                ProductRatingView(rating: $rating, spacing: .constant(UIScreen.main.bounds.width / 10)).padding(.bottom, 10)
                ZStack(alignment: .leading) {
                    if review.isEmpty {
                        Text(" Please enter your review")
                            .font(.custom(Fonts.Graphik_Title, size:12))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    TextEditor(text: $review)
                        .lineSpacing(8)
                        .lineLimit(UIDevice.current.orientation.isPortrait ? 10 : 5)
                        .padding()
                }
            }
            
            Section {
                Button("Submit") {
                    let newrReview = Review(id: productViewModel.id,
                                            locale: locale,
                                            rating: rating,
                                            text: review)
                    productViewModel.submitReview(newrReview)
                }
                .disabled(review.isEmpty)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear(perform: {
            if productViewModel.isSubmittedReview {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .alert(isPresented: $productViewModel.isErrorPresented) {
            Alert(title: Text("Network Error"),
                  message: Text(productViewModel.errorResponse),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct AddProductReview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddProductReview().environmentObject(ProductViewModel(Product(id: "HI334",
                                                                          name: "Product Name",
                                                                          imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                          description: "description",
                                                                          price: 0,
                                                                          currency: "",
                                                                      reviews: [])))
            AddProductReview().preferredColorScheme(.dark).environmentObject(ProductViewModel(Product(id: "HI334",
                                                                          name: "Product Name",
                                                                          imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                          description: "description",
                                                                          price: 0,
                                                                          currency: "",
                                                                          reviews: [])))
        }
    }
}
