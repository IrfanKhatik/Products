//
//  AddProductReview.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct AddProductReview: View, OrientationListnerProtocol {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var productViewModel: ProductViewModel
    
    @State var dismissAddProductReview: Bool = false
    
    @State private var orientation = UIDevice.current.orientation
    
    @State private var locale = Locale.current.identifier
    
    @State private var review = ""
    
    @State private var rating = 0
    
    var body: some View {
        
        Form {
            
            Section {
                
                ProductRatingView(rating: $rating,
                                  spacing: .constant(20),
                                  label: .constant("Please tap to rate:"),
                                  isEditable: .constant(true))
                    .padding(.bottom, 10)
                
                ZStack(alignment: .leading) {
                    
                    if review.isEmpty {
                        
                        Text(" Please enter your review")
                            .font(.custom(Fonts.kDefaultFontName, size:12))
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
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
                    
                    LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Submit review tapped: \(self.productViewModel.id, privacy: .private)")
                    
                    let newReview = Review(id: productViewModel.id,
                                            locale: locale,
                                            rating: rating,
                                            text: review)
                    
                    LoggerManager.shared.defaultLogger.log(level: .info, "[Adidas] Review submitting: \(newReview, privacy: .private(mask: .hash))")
                    
                    productViewModel.submitReview(newReview)
                    
                }
                .disabled(review.isEmpty)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section {
                
                Button("Cancel") {
                    
                    LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Add review cancelled: \(self.productViewModel.id, privacy: .private)")
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            
            OrientationListner.shared.listners.append(self)
            
        }
        .onDisappear {
            
            OrientationListner.shared.listners.removeLast()
            
        }
        .alert(isPresented: $productViewModel.isErrorPresented) {
            
            LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Review error alert shown")
            
            return Alert(title: Text("Network Error"),
                         message: Text(productViewModel.errorResponse),
                         dismissButton: .default(Text("Ok")))
        }
        .onReceive(productViewModel.$isSubmittedReview) { submitted in
            
            if submitted {
                
                LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Add review dismiss: \(self.productViewModel.id, privacy: .private)")
                DispatchQueue.main.async {
                    dismissAddProductReview = true
                }
            }
        }
        .onChange(of: dismissAddProductReview, perform: { value in
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    func orientationChanged() {
        
        orientation = UIDevice.current.orientation
        
        LoggerManager.shared.uiLogger.log(level: .debug, "[Adidas] Device orientation changed: \(orientation.rawValue, privacy: .public)")
    }
}

struct AddProductReview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddProductReview(productViewModel: ProductViewModel(Product(id: "HI334",
                                                                        name: "Product Name",
                                                                        imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                        desc: "description",
                                                                        price: 0,
                                                                        currency: "",
                                                                        reviews: [])))
                .preferredColorScheme(.light)
                
            AddProductReview(productViewModel: ProductViewModel(Product(id: "HI334",
                                                                        name: "Product Name",
                                                                        imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                        desc: "description",
                                                                        price: 0,
                                                                        currency: "",
                                                                        reviews: [])))
                .preferredColorScheme(.dark)
        }
    }
}
