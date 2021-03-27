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
    
    var label = "Please tap to rate:"
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).padding(.bottom, 5)
            HStack {
                ForEach(1..<maximumRating + 1) { number in
                    self.image(for: number)
                        .padding(.trailing, self.spacing)
                        .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                        .onTapGesture {
                            self.rating = number
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
            GeometryReader { geometry in
                Form {
                    Section {
                        ProductRatingView(rating: .constant(3), spacing: .constant(geometry.size.width / 10))
                    }
                }
            }
            
            GeometryReader { geometry in
                Form {
                    Section {
                        ProductRatingView(rating: .constant(3), spacing: .constant(geometry.size.width / 10))
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
