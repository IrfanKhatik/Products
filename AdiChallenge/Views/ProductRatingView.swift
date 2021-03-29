//
//  ProductRatingView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductRatingView: View {
    
    // Binding property to provide initial rating.
    @Binding var rating: Int
    
    // Binding property to provide space between rating stars.
    @Binding var spacing: CGFloat
    
    // Binding property to provide title label for star ratings.
    @Binding var label: String
    
    // Binding property to provide is ProductRatingView editable or not.
    @Binding var isEditable: Bool
    
    // State property for maximum rating for review
    @State private var maximumRating = Constants.kMaximumNumberOfRreviewRating
    
    // State property for not given rating image
    @State private var offImage: Image?
    
    // State property for given rating image
    @State private var onImage = Image(systemName: "star.fill")
    
    // State property for gray color for offImage
    @State private var offColor = Color.gray
    
    // State property for yellow star for onImage
    @State private var onColor = Color.yellow
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // If star rating title given set
            if label.count > 0 {
                Text(self.label)
                    .padding(.bottom, 5)
            }
            
            HStack {
                
                // Prepare rating star and add tap guesture for star images if isEditable true.
                ForEach(1..<maximumRating + 1, id:\.self) { number in
                    
                    self.image(for: number)
                        .padding(.trailing, self.spacing)
                        .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                        .onTapGesture {
                            if isEditable {
                                // Tap guesture for star images
                                LogManager.shared.uiLogger.log(level: .debug, "[Adidas] Review star tapped: \(number, privacy: .public))")
                                self.rating = number
                            }
                        }
                }
            }
        }
    }
    
    // Update image on/off based on tap number.
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
