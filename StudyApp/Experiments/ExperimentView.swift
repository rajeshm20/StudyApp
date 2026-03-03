//
//  ExperimentView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 17/11/25.
//

import SwiftUI

struct ExperimentView: View {
    @State private var score = 0
    @State private var count = 0

    var body: some View {
        VStack(spacing: 16) {
            SearchView()
//                 MapView()
//                 OutlineView()
            Stepper("Quantity: \(count)", value: $count, in: 0 ... 10)
                .font(.title)
            Gauge(value: 0.7) {
                Text("Loading")
            }
            LabeledContent("Username") {
                Text("Rajesh Mani")
            }
            .padding(10)
//                 Image(systemName: "heart.fill")
//                             .font(.system(size: 80))
//                             .foregroundColor(.red)
//                             .phaseAnimator([false, true]) { view, phase in
//                                 view.scaleEffect(phase ? 1.2 : 1.0)
//                             }
            Text("\(score)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .contentTransition(.interpolate)
                .animation(.interactiveSpring(duration: 0.25), value: score)

            Button("Score") { score += 1 }
                .buttonStyle(.borderedProminent)
            Button(action: {
                print("Tapped!")
            }) {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white))
            }
        }
    }

    struct SearchView: View {
        @State private var searchText = ""
        @State private var results: [String] = []

        var body: some View {
            VStack {
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                List(results, id: \.self) { item in
                    Text(item)
                }
                ControlGroup {
                    Button {
                        print("Rewind")
                    } label: {
                        Image(systemName: "backward.fill")
                    }

                    Button {
                        print("Play")
                    } label: {
                        Image(systemName: "play.fill")
                    }

                    Button {
                        print("Forward")
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                }.controlGroupStyle(.automatic)
            }
            .onChange(of: searchText, initial: true) { _, newValue in
                results = getResults(for: newValue)
            }
        }

        func getResults(for query: String) -> [String] {
            guard !query.isEmpty else { return [] }
            return (1 ... 5).map { "\(query) result \($0)" }
        }
    }
}

#Preview {
    ExperimentView()
}

struct Animal: Identifiable {
    let id = UUID()
    let name: String
    var children: [Animal]?
}

let animals: [Animal] = [
    Animal(name: "Mammals", children: [
        Animal(name: "Dog"),
        Animal(name: "Cat"),
        Animal(name: "Elephant"),
    ]),
    Animal(name: "Birds", children: [
        Animal(name: "Parrot"),
        Animal(name: "Eagle"),
        Animal(name: "Sparrow"),
    ]),
]

struct OutlineView: View {
    var body: some View {
        List {
            OutlineGroup(animals, children: \.children) { animal in
                Text(animal.name)
            }
            .cardStyle()
        }
    }
}

import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    var body: some View {
        Map(position: $position) {
            Annotation("San Francisco",
                       coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
            {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(.red)
                    .font(.title)
            }
        }
        .frame(height: 300)
    }
}

struct SelectableList: View {
    @State private var viewSize: CGSize = .zero
    @State private var selectedFruit: Set<String> = []
    let fruits = ["🍎 Apple", "🍌 Banana", "🍇 Grapes", "🍉 Watermelon", "🍍 Pineapple"]
    var body: some View {
        NavigationView {
//            List(fruits, id: \.self, selection: $selectedFruit) { fruit in
//                Text(fruit)
//                    .selectionDisabled(fruit == "🍍 Pineapple")
//            }
//            .navigationTitle("Select Fruits")
//            .toolbar {
//                EditButton()
//            }
//            ScrollView {
//                VStack(spacing: 0) {
//                    GeometryReader { geo in
//                        let offset = geo.frame(in: .named("scroll")).minY
//                        let opacity = max(0.1, min(1, offset / 100))
//
//                        Text("Header")
//                            .font(.largeTitle)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .opacity(opacity)
//                    }
//                    .frame(height: 100)
//
//                    ForEach(0..<50) { i in
//                        Text("Row \(i)")
//                            .padding()
//                    }
//                }
//            }
//            .coordinateSpace(name: "scroll")
            // MARK: Proportional sizing:

//            GeometryReader { geo in
//                HStack(spacing: 0) {
//                    Rectangle()
//                        .fill(.blue)
//                        .frame(width: geo.size.width * 0.3)
//
//                    Rectangle()
//                        .fill(.green)
//                        .frame(width: geo.size.width * 0.7)
//                }
//            }
//            .frame(height: 200)
            // MARK: Adaptive columns:

//            GeometryReader { geo in
//                let columns = Int(geo.size.width / 150)
//                let columnWidth = geo.size.width / CGFloat(columns)
//
//                LazyVGrid(columns: Array(repeating: GridItem(.fixed(columnWidth)), count: columns)) {
//                    ForEach(0..<20) { i in
//                        Rectangle()
//                            .fill(.blue)
//                            .frame(height: 100)
//                    }
//                }
//            }
            // MARK: Aspect ratio containers:

//            GeometryReader { geo in
//                let size = min(geo.size.width, geo.size.height)
//
//                Circle()
//                    .fill(.purple)
//                    .frame(width: size, height: size)
//                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
//            }

            // MARK: Responsive card layout:

//            GeometryReader { geo in
//                let isCompact = geo.size.width < 600
//
//                if isCompact {
//                    VStack(alignment: .leading, spacing: 16) {
//                        cardImage(width: geo.size.width)
//                        cardContent
//                    }
//                } else {
//                    HStack(spacing: 16) {
//                        cardImage(width: geo.size.width * 0.4)
//                        cardContent
//                    }
//                }
//            }

            // MARK: proportional spacing:

//            GeometryReader { geo in
//                VStack(spacing: geo.size.height * 0.05) {
//                    ForEach(0..<5) { i in
//                        Rectangle()
//                            .fill(.blue)
//                            .frame(height: 50)
//                    }
//                }
//            }

            // MARK: Mistake 1: Using it in Lists or ScrollViews carelessly

            // breaks layout
//            List {
//                ForEach(items) { item in
//                    GeometryReader { geo in
//                        Text(item.name)
//                    }
//                }
//            }

            // MARK: Nesting GeometryReaders unnecessarily

            // probably wrong
//            GeometryReader { outer in
//                GeometryReader { inner in
//                    Text("Over-engineered")
//                }
//            }
            // MARK: Mistake 3: Not constraining size when you should

            VStack {
                Text("Top")
                GeometryReader { geo in
                    Color.orange
                        .onAppear {
                            viewSize = geo.size
                        }
                    Circle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                }

                Text("Bottom")
            }
        }
    }

    func cardImage(width: CGFloat) -> some View {
        Rectangle()
            .fill(.blue)
            .frame(width: width, height: 200)
    }

    var cardContent: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.headline)
            Text("Description goes here")
                .font(.subheadline)
        }
    }
}

#Preview {
    SelectableList()
}
