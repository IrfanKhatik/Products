//
//  ProductDetailView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductDetailView: View, OrientationListnerProtocol {
    
    // An indication whether a view is currently presented by another view.
    // Dismiss View using its presentation mode environment key.
    @Environment(\.presentationMode) var presentationMode
    
    // To match equatable for OrientationListnerProtocol
    var identifier : String = UUID().uuidString
    
    // State property for showing add rating view or not.
    @State private var showAddRatingView = false
    
    // State property to update orientation change.
    @State var orientation = UIDevice.current.orientation
    
    // Observable property for ProductViewModel to provide product details.
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                ScrollView {
                    
                    VStack(alignment:.leading) {
                        // Add product image
                        ProductImageView(
                            url: URL(string: self.productViewModel.imageUrl) ?? nil,
                            placeholder: { ProgressView() },
                            image: { Image(uiImage: $0).resizable() }
                        )
                        .aspectRatio(contentMode: .fit)
                        
                        HStack {
                            
                            HStack(alignment: .center) {
                                // Add product name
                                Text(self.productViewModel.name)
                                    .textStyle(ProductTitleTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                            
                            HStack {
                                // Add product price
                                Text(self.productViewModel.formattedPrice)
                                    .textStyle(ProductDesciptionTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                            
                            if self.productViewModel.discount > 0 {
                                HStack {
                                    Spacer()
                                
                                    // Add product discount
                                    Text(self.productViewModel.formattedDiscount)
                                        .textStyle(ProductTitleTextStyle())
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.trailing, 10)
                            }
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            
                            HStack {
                                // Add product description
                                Text(self.productViewModel.desc)
                                    .textStyle(ProductDesciptionTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                        }
                        
                        Divider()
                        
                        // Added lazy VStack
                        LazyVStack(alignment:.leading) {
                            
                            // Add products reviews
                            ForEach(0..<self.productViewModel.reviews.count, id:\.self) { index in
                                
                                VStack(alignment:.leading) {
                                    
                                    let review = self.productViewModel.reviews[index]
                                    
                                    Text(review.text ?? "")
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
                                        // Add product review text and rating star view
                                        ProductRatingView(rating: .constant(review.rating ?? 0),
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
                
                // Add back button on top of above scrollable view.
                Button(action: {
                    
                    LogManager.shared.uiLogger.log(level: .info, "[Adidas] Back tapped: \(self.productViewModel.id, privacy: .public)")
                    
                    withAnimation {
                        // Dismiss view on tap of back button
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }){
                    Image("BackIcon")
                }
                .position(x: 25, y: 25)
            }
            .padding(.bottom, 10)
            .toolbar {
                // Added bottom toolbar button for add review.
                ToolbarItem(placement: .bottomBar) {
                    
                    // We can add SF Symbol instead of text
                    Button("Add review") {
                        
                        LogManager.shared.uiLogger.log(level: .info, "[Adidas] Add review tapped: \(self.productViewModel.id, privacy: .public)")
                        
                        // Show add product rating view on toggle
                        showAddRatingView.toggle()
                        
                    }
                }
            }
            .navigationBarHidden(true) // Hide navigation bar
        }
        .onAppear {
            // Confirm to orientation change listner
            OrientationListner.shared.listners.append(self)
        }
        .onDisappear {
            // Remove orientation listening as its disappearing.
            if let index = OrientationListner.shared.find(value: self) {
                if index < OrientationListner.shared.listners.count {
                    OrientationListner.shared.listners.remove(at: index)
                }
            }
        }
        .sheet(isPresented: $showAddRatingView,
               onDismiss: {
                self.showAddRatingView = false
               })
        {
            // Show AddProductReview view
            AddProductReview(productViewModel:self.productViewModel)
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

extension ProductDetailView : Equatable {
    static func == (lhs: ProductDetailView, rhs: ProductDetailView) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let reviews = [
            Review(id: "ABC", locale: "nl_NL", rating: 2, text: "This is first review on product"),
            Review(id: "PQR", locale: "nl_NL", rating: 4, text: "This product very nice and easy to use.")
        ]
        ProductDetailView(productViewModel: ProductViewModel(Product(id: "HI334",
                                                                     name: "Product Name",
                                                                     imgUrl: "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg",
                                                                     desc: "description",
                                                                     price: 25.0,
                                                                     currency: "nl_NL",
                                                                     reviews: reviews,
                                                                     discount: 10.0)))
            .environment(\.sizeCategory, .extraSmall)
    }
}
