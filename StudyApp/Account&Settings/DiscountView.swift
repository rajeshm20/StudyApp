//
//  DiscountView.swift
//  InterviewApp
//
//  Created by Rajesh Mani on 22/05/26.
//

import SwiftUI
import Observation


struct DiscountView: View {
    let price: Double
    let discountPercentage: Int?
    var discountedPrice: Double? {
        if let discountPercentage {
            // $20 -> (25/100) * $20 = $5
            return (Double(100 - discountPercentage) / 100)*price
        }
        return nil
    }
    let discountColor: Color
    let bgColor: Color
    let yOffset: CGFloat
    let discountAngle: Double
    
    init(
        price: Double,
        discountPercentage: Int?,
        discountColor: Color = .blue,
        bgColor: Color = .pink,
        yOffset: CGFloat = -20,
        discountAngle: Double = -15
    ) {
        self.price = price
        self.discountPercentage = discountPercentage
        self.discountColor = discountColor
        self.bgColor = bgColor
        self.yOffset = yOffset
        self.discountAngle = discountAngle
    }
    var body: some View {
        VStack {
            if let discountPercentage {
                Text("\(discountPercentage)% OFF")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .background(discountColor)
                    .clipShape(.rect(cornerRadius: 15))
                    .rotationEffect(Angle(degrees: discountAngle))
                    .offset(y: yOffset)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                Text("BUY NOW")
                Spacer()
                Text("$\(price, specifier: "%.2f")")
                    .foregroundStyle(.white)
                    .strikethrough(discountedPrice != nil)
                    .font(.title)
                    .fontWeight(.semibold)
                if let discountedPrice {
                    Text("\(discountedPrice, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                }
               
            }
            Text(" + 20% OFF ON NEXT PURCHASE")
                .padding(8)
                .background(.yellow.opacity(0.3))
                .clipShape(.rect(cornerRadius: 8))
                .shadow(color: .white, radius: 5)
                .rotationEffect(.degrees(20))
                .offset(x: 10, y: -40)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(bgColor)
        )

    }
}

#Preview {
    ZStack {
        Color
            .black
            .opacity(0.7)
            .ignoresSafeArea()
        VStack {
            DiscountView(price: 150.0, discountPercentage: 75)
            DiscountView(price: 150.0, discountPercentage: nil)
            ProfileEditor(vm: UsrProfile(name: "Rajesh"))
        }
        .padding(5)
    }
}
//has a ProfileEditor view where a user can change their name. Sam is using an Observable class for the user's profile. However, when the user types in the TextField, the Text view displaying the name doesn't update immediately. Sam's code looks something like this:
@Observable
class UsrProfile {
    var name: String = ""

    init(name: String = "") {
        self.name = name
    }
}

struct ProfileEditor: View {
   @Bindable var userProfile: UsrProfile

    init(vm: UsrProfile){
        self.userProfile = vm
    }
    var body: some View {
        VStack {
            TextField("Name", text: $userProfile.name)
                .background(.red)
            Text("Hello, \(userProfile.name)!")
        }
    }
}
#Preview {
    VStack {
        ProfileEditor(vm: UsrProfile(name: "Sam"))
    }
}
//What's the fundamental issue here that's preventing the Text view from updating, and how would you correct it using the appropriate property wrapper for userProfile within ProfileEditor?
