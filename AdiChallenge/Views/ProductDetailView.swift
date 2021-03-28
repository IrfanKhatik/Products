//
//  ProductDetailView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductDetailView: View, OrientationListnerProtocol {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAddRatingView = false
    
    @State var orientation = UIDevice.current.orientation
    
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
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
                                    .textStyle(ProductTitleTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                            
                            HStack {
                                
                                Text(self.productViewModel.formattedPrice)
                                    .textStyle(ProductDesciptionTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                            
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            
                            HStack {
                                
                                Text(self.productViewModel.desc)
                                    .textStyle(ProductDesciptionTextStyle())
                                
                                Spacer()
                                
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 10)
                        }
                        
                        Divider()
                        
                        
                        LazyVStack(alignment:.leading) {
                            
                            ForEach(0..<self.productViewModel.reviews.count, id:\.self) { index in
                                
                                VStack(alignment:.leading) {
                                    let review = self.productViewModel.reviews[index]
                                    
                                    Text(review.text ?? "")
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
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
                
                Button(action: {
                    
                    LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Back tapped: \(self.productViewModel.id, privacy: .public)")
                    
                    withAnimation {
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }){
                    Image("BackIcon")
                }
                .position(x: 25, y: 25)
            }
            .padding(.bottom, 10)
            .toolbar {
                
                ToolbarItem(placement: .bottomBar) {
                    
                    Button("Add review") {
                        
                        LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Add review tapped: \(self.productViewModel.id, privacy: .public)")
                        
                        showAddRatingView.toggle()
                        
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            OrientationListner.shared.listners.append(self)
        }
        .onDisappear {
            OrientationListner.shared.listners.removeLast()
        }
        .sheet(isPresented: $showAddRatingView,
               onDismiss: {
                self.showAddRatingView = false
               })
        {
            AddProductReview(productViewModel:self.productViewModel)
        }
    }
    
    func orientationChanged() {
        
        orientation = UIDevice.current.orientation
        
        LoggerManager.shared.uiLogger.log(level: .debug, "[Adidas] Device orientation changed: \(orientation.rawValue, privacy: .public)")
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
                                                                     reviews: reviews)))
            .environment(\.sizeCategory, .extraSmall)
    }
}
