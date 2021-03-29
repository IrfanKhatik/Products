//
//  AddProductReview.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct AddProductReview: View, OrientationListnerProtocol {
    
    // An indication whether a view is currently presented by another view.
    // Dismiss View using its presentation mode environment key.
    @Environment(\.presentationMode) var presentationMode
    
    // Product viewmodel to provide product id for submit product review.
    @ObservedObject var productViewModel: ProductViewModel
    
    // To match equatable for OrientationListnerProtocol
    var identifier : String = UUID().uuidString
    
    // State property to show alert after submit review response
    @State private var showReviewAlert: Bool = false
    
    // State property to dismiss self after submit review success.
    @State private var dismissAddProductReview: Bool = false
    
    // State property to update orientation change.
    @State private var orientation = UIDevice.current.orientation
    
    // State property to set review text.
    @State private var review = ""
    
    // State property to set review ratings.
    // (maximum will be kMaximumNumberOfRreviewRating value).
    @State private var rating = 0
    
    var body: some View {
        
        Form {
            
            Section {
                // Add product review text and rating star view
                // isEditable as we are adding review text and ratings
                ProductRatingView(rating: $rating,
                                  spacing: .constant(20),
                                  label: .constant("Please tap to rate:"),
                                  isEditable: .constant(true))
                    .padding(.bottom, 10)
                
                ZStack(alignment: .leading) {
                    
                    if review.isEmpty {
                        // Add Text placeholder text when review text missing
                        Text(" Please enter your review")
                            .font(.custom(Fonts.kDefaultFontName, size:12))
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            .padding()
                        
                    }
                    
                    // Add TextEditor so user can add review text
                    TextEditor(text: $review)
                        .lineSpacing(8)
                        .lineLimit(UIDevice.current.orientation.isPortrait ? 10 : 5)
                        .padding()
                }
            }
            
            Section {
                
                Button("Submit") {
                    
                    LogManager.shared.uiLogger.log(level: .info, "[Adidas] Submit review tapped: \(self.productViewModel.id, privacy: .private)")
                    
                    // Prepare new review for product.
                    let newReview = Review(id: productViewModel.id,
                                           locale: Locale.current.identifier,
                                           rating: rating,
                                           text: review)
                    
                    LogManager.shared.defaultLogger.log(level: .info, "[Adidas] Review submitting: \(newReview, privacy: .private(mask: .hash))")
                    
                    // Submit review using REST api
                    productViewModel.submitReview(newReview)
                    
                }
                .disabled(review.isEmpty)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section {
                
                Button("Cancel") {
                    
                    LogManager.shared.uiLogger.log(level: .info, "[Adidas] Add review cancelled: \(self.productViewModel.id, privacy: .private)")
                    
                    // Dismiss AddProductReview view
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            
            // Confirm to orientation change listner
            OrientationListner.shared.listners.append(self)
            
        }
        .onReceive(productViewModel.$reviewResult) { submitted in
            if submitted {
                // Show review success / failure alert after submit review.
                showReviewAlert = true
            }
        }
        .alert(isPresented: $showReviewAlert) {
            
            if productViewModel.errorResponse.isEmpty {
                
                // Show success alert
                return Alert(title: Text("Review"),
                             message: Text("Your review submitted successfully."),
                             dismissButton: .default(Text("Ok"), action: {
                                // Dismiss AddProductReview view
                                dismissAddProductReview = true
                             }))
            } else {
                
                // Show failure alert
                return Alert(title: Text("Add Review Error"),
                             message: Text(productViewModel.errorResponse),
                             dismissButton: .cancel())
            }
            
        }
        .onChange(of: dismissAddProductReview, perform: { value in
            
            LogManager.shared.uiLogger.log(level: .info, "[Adidas] Add review dismiss: \(self.productViewModel.id, privacy: .private)")
            
            // Dismiss AddProductReview view after submit review success.
            presentationMode.wrappedValue.dismiss()
        })
        .onDisappear {
            // Remove orientation listening as its disappearing.
            if let index = OrientationListner.shared.find(value: self) {
                if index < OrientationListner.shared.listners.count {
                    OrientationListner.shared.listners.remove(at: index)
                }
            }
        }
    }
    
    // OrientationListnerProtocol method
    func orientationChanged() {
        // Its called when orintation changes
        
        // Update orientation state property
        orientation = UIDevice.current.orientation
        
        LogManager.shared.uiLogger.log(level: .debug, "[Adidas] Device orientation changed: \(orientation.rawValue, privacy: .public)")
    }
}

extension AddProductReview : Equatable {
    static func == (lhs: AddProductReview, rhs: AddProductReview) -> Bool {
        return lhs.identifier == rhs.identifier
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
