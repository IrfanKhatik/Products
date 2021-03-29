//
//  ProductListView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import SwiftUI

struct ProductListView: View, OrientationListnerProtocol {
    
    // To match equatable for OrientationListnerProtocol
    var identifier : String = UUID().uuidString
    
    // SateObject property for ProductListViewModel which requires to fetch products, search products
    @StateObject private var viewModel = ProductListViewModel()
    
    // State property to update orientation change.
    @State private var orientation = UIDevice.current.orientation
    
    // Computed property for search textfield width based on orientation
    private var searchWidth: CGFloat {
        
        if orientation == .portrait  {
            return UIScreen.main.bounds.width * 0.9
        }
        
        return UIScreen.main.bounds.width * 0.8
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                // Add Search textfield on view as top
                TextField("Search your adidas products", text: $viewModel.searchText)
                    .padding(.horizontal, 40)
                    .frame(width: searchWidth, height: 45,
                           alignment: .center)
                    .background(Color(#colorLiteral(red: 0.9294475317, green: 0.9239223003, blue: 0.9336946607, alpha: 1)))
                    .clipped()
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            
                        }
                    )
                    .accessibility(identifier: "enterSearchTextField")
                
            }
            .padding(.top, 10)
            
            ScrollView {
                
                // Added lazy VStack inside scroll view
                LazyVStack(alignment: .leading) {
                    
                    // Add products viewmodels view
                    // If search field has text, then it will show filtered products viewmodels view
                    // Else fetched products viewmodels view
                    ForEach(viewModel.searchText.count > 0 ?
                                viewModel.filterProductViewModels :
                                viewModel.productViewModels, id:\.id) { productViewModel in
                        
                        // Prepare and show product view as cell
                        ProductListViewCell(productViewModel: productViewModel)
                        
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        }
        .padding(.bottom, 10)
        .onAppear {
            
            // Confirm to orientation change listner
            OrientationListner.shared.listners.insert(self, at: 0)
            
            LogManager.shared.defaultLogger.log(level: .info, "[Adidas] Fetch Products.")
            
            // Fetch products network REST api call
            viewModel.fetchProducts()
        }
        .alert(isPresented: $viewModel.isErrorPresented) {
            
            LogManager.shared.uiLogger.log(level: .info, "[Adidas] Product error alert shown")
            
            // Show alert on fetch products network REST api call error
            return Alert(title: Text("Network Error"),
                         message: Text(viewModel.errorResponse),
                         dismissButton: .default(Text("Ok")))
        }
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

extension ProductListView : Equatable {
    static func == (lhs: ProductListView, rhs: ProductListView) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
