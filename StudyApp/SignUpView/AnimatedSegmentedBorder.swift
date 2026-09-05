//
//  AnimatedSegmentedBorder.swift
//  StudyApp
//
//  Created by Rajesh Mani on 28/07/26.
//
import SwiftUI

struct AnimatedSegmentedBorder<S: InsettableShape>: View {

    let shape: S

    var colors: [Color]
    var lineWidth: CGFloat = 3
    var segmentCount: Int = 60
    var visibleRatio: CGFloat = 0.7

    @State
    private var phase = 0

    var body: some View {

        ZStack {

            ForEach(0..<segmentCount, id: \.self) { index in

                let step = 1.0 / Double(segmentCount)

                let from = Double(index) * step
                let to = from + step * Double(visibleRatio)

                shape
                    .trim(from: from, to: to)
                    .stroke(
                        colors[(index + phase) % colors.count],
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
            }
        }
        .onAppear {

            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
                phase += 1
            }
        }
    }
}
