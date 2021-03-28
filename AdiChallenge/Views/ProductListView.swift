//
//  ProductListView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import SwiftUI

struct ProductListView: View, OrientationListnerProtocol {
    
    @StateObject private var viewModel = ProductListViewModel()
    
    @State private var orientation = UIDevice.current.orientation
    
    var searchWidth: CGFloat {
        
        if orientation == .portrait  {
            return UIScreen.main.bounds.width * 0.9
        }
        
        return UIScreen.main.bounds.width * 0.8
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
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
                
            }
            .padding(.top, 10)
            
            ScrollView {
                
                LazyVStack(alignment: .leading) {
                    
                    ForEach(viewModel.searchText.count > 0 ?
                                viewModel.filterProductViewModels :
                                viewModel.productViewModels, id:\.id) { productViewModel in
                        
                        ProductListViewCell(productViewModel: productViewModel)
                        
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        }
        .padding(.bottom, 10)
        .onAppear {
            
            OrientationListner.shared.listners.append(self)
            
            LoggerManager.shared.defaultLogger.log(level: .info, "[Adidas] Fetch Products.")
            
            viewModel.fetchProducts()
        }
        .alert(isPresented: $viewModel.isErrorPresented) {
            
            LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Product error alert shown")
            
            return Alert(title: Text("Network Error"),
                         message: Text(viewModel.errorResponse),
                         dismissButton: .default(Text("Ok")))
        }
    }
    
    func orientationChanged() {
        
        orientation = UIDevice.current.orientation
        
        LoggerManager.shared.uiLogger.log(level: .debug, "[Adidas] Device orientation changed: \(orientation.rawValue, privacy: .public)")
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
