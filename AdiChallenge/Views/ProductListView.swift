//
//  ProductListView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import SwiftUI

struct ProductListView: View {
    
    @StateObject private var viewModel = ProductListViewModel()
    
    // refresh the view on orientation change
    @State var refresh: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                TextField("", text: $viewModel.searchText)
                    .padding(.horizontal, 40)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45, alignment: .center)
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
                
            }
            .padding(.top, 10)
            
            ScrollView {
                
                LazyVStack(alignment:.leading) {
                    
                    if refresh {
                        
                        // To refresh UI when orientation changes
                        ForEach(viewModel.searchText.count > 0 ?
                                    viewModel.filterProductViewModels :
                                    viewModel.productViewModels, id:\.id) { productViewModel in
                            ProductListViewCell(productViewModel: productViewModel)
                                .id(UUID())
                        }
                        
                    } else {
                        
                        ForEach(viewModel.searchText.count > 0 ?
                                    viewModel.filterProductViewModels :
                                    viewModel.productViewModels, id:\.id) { productViewModel in
                            ProductListViewCell(productViewModel: productViewModel)
                                .id(UUID())
                        }
                    }
                }
            }
//            .onReceive(viewModel.orientationChanged) { _ in
//                
//                LoggerManager.shared.uiLogger.log(level: .debug, "[Adidas] Device orientation changed: \(UIDevice.current.orientation.rawValue, privacy: .public)")
//                
//                self.refresh.toggle()
//            }
            .onAppear(perform: {
                
                LoggerManager.shared.defaultLogger.log(level: .info, "[Adidas] Fetch Products.")
                
                viewModel.fetchProducts()
            })
            .alert(isPresented: $viewModel.isErrorPresented) {
                
                LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Product error alert shown")
                
                return Alert(title: Text("Network Error"),
                             message: Text(viewModel.errorResponse),
                             dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
