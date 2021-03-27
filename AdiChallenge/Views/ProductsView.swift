//
//  ProductsView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductListViewModel()
    // refresh the view?
    @State var refresh: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("", text: $viewModel.searchText)
                    .padding(.horizontal, 40)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 45, alignment: .center)
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
            }.padding(.top, 10)
            
            ScrollView {
                LazyVStack {
                    if refresh {
                        // To refresh UI when orientation changes
                        ForEach(viewModel.searchText.count > 0 ?
                                    viewModel.filterProductViewModels :
                                    viewModel.productViewModels) { productViewModel in
                            ProductViewCell(productViewModel: productViewModel)
                        }
                    } else {
                        ForEach(viewModel.searchText.count > 0 ?
                                    viewModel.filterProductViewModels :
                                    viewModel.productViewModels) { productViewModel in
                            ProductViewCell(productViewModel: productViewModel)
                        }
                    }
                }
            }
            .onReceive(viewModel.orientationChanged) { _ in
                self.refresh.toggle()
            }
            .onAppear(perform: {
                viewModel.fetchProducts()
            })
            .alert(isPresented: $viewModel.isErrorPresented) {
                Alert(title: Text("Network Error"),
                      message: Text(viewModel.errorResponse),
                      dismissButton: .default(Text("Ok")))
            }
        }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
