//
//  ProductRatingView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductRatingView: View {
    
    @Binding var rating: Int
    
    @Binding var spacing: CGFloat
    
    @Binding var label: String
    
    @Binding var isEditable: Bool
    
    var maximumRating = Constants.kMaximumNumberOfRreviewRating
    
    var offImage: Image?
    
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    
    var onColor = Color.yellow
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if label.count > 0 {
                Text(self.label)
                    .padding(.bottom, 5)
            }
            
            HStack {
                
                ForEach(1..<maximumRating + 1, id:\.self) { number in
                    
                    self.image(for: number)
                        .padding(.trailing, self.spacing)
                        .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                        .onTapGesture {
                            if isEditable {
                                LoggerManager.shared.uiLogger.log(level: .debug, "[Adidas] Review star tapped: \(number, privacy: .public))")
                                self.rating = number
                            }
                        }
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        
        if number > rating {
            
            return offImage ?? onImage
            
        } else {
            
            return onImage
            
        }
    }
}

struct ProductRatingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            Form {
                
                Section {
                    
                    ProductRatingView(rating: .constant(3),
                                      spacing: .constant(10),
                                      label: .constant("Please tap to rate:"),
                                      isEditable: .constant(true))
                    
                }
            }
            
            Form {
                
                Section {
                    
                    ProductRatingView(rating: .constant(3),
                                      spacing: .constant(10),
                                      label: .constant("Please tap to rate:"),
                                      isEditable: .constant(true))
                    
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
