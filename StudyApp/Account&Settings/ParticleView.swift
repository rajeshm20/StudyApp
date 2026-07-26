//
//  ParticleView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 06/03/26.
//

import SwiftUI

struct DemoView1: View {
    @State private var toggle: Bool = false
    @State private var color: Color = [
        .purple, .cyan, .green, .blue, .pink
    ].randomElement()!
    
    var body: some View {
        ZStack {

            ParticleBackground()

            VStack {
                Text("Cyber UI")
                    .foregroundColor(toggle == false ? color : color)
                    .font(.largeTitle)

                Button("Activate") {
                    toggle.toggle()
                }
                .padding()
                .background(.green)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
        }
    }
}

struct ParticleBackground: View {

    let particles: [Particle] = (0..<150).map { _ in Particle() }

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for particle in particles {

                    let rect = CGRect(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height),
                        width: particle.size,
                        height: particle.size
                    )

                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particle.color)
                    )
                }
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
}

struct Particle {
    let size: CGFloat = CGFloat.random(in: 1...3)

    let color: Color = [
        .purple, .cyan, .green, .blue, .pink
    ].randomElement()!
}

#Preview {
    DemoView1()
}

//import SwiftUI
//
//struct Particle1 {
//    var x: CGFloat
//    var y: CGFloat
//    var size: CGFloat
//    var speedX: CGFloat
//    var speedY: CGFloat
//
//    static func random(width: CGFloat, height: CGFloat) -> Particle1 {
//        return Particle1(
//            x: CGFloat.random(in: 0...width),
//            y: CGFloat.random(in: 0...height),
//            size: CGFloat.random(in: 1...4),
//            speedX: CGFloat.random(in: -1...1),
//            speedY: CGFloat.random(in: -1...1)
//        )
//    }
//}
//
//class ParticleEngine: ObservableObject {
//    @Published var particles: [Particle1] = []
//    let width: CGFloat
//    let height: CGFloat
//
//    init(count: Int, width: CGFloat, height: CGFloat) {
//        self.width = width
//        self.height = height
//        particles = (0..<count).map { _ in Particle1.random(width: width, height: height) }
//    }
//}
//
//struct ParticleBackground: View {
//    @ObservedObject var engine: ParticleEngine
//
//    var body: some View {
//        Canvas { context, size in
//            for particle in engine.particles {
//                let rect = CGRect(x: particle.x, y: particle.y, width: particle.size, height: particle.size)
//                context.fill(
//                    Path(ellipseIn: rect),
//                    with: .color(.purple.opacity(0.7))
//                )
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//
//class ParticleEngineHolder: ObservableObject {
//    @Published var engine: ParticleEngine? = nil
//}
//
//struct ParticleView: View {
//    @StateObject private var engineHolder = ParticleEngineHolder()
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                Color.black.edgesIgnoringSafeArea(.all)
//                if let engine = engineHolder.engine {
//                    ParticleBackground(engine: engine)
//                }
//                VStack {
//                    Text("Cyber UI")
//                        .foregroundColor(.purple)
//                        .font(.largeTitle)
//                        .shadow(color: .black, radius: 0.7)
//                }
//            }
//            .onAppear {
//                if engineHolder.engine == nil {
//                    engineHolder.engine = ParticleEngine(count: 300, width: geo.size.width, height: geo.size.height)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ParticleView()
//}


//import SwiftUI
//
//struct Particle1: Identifiable {
//    let id = UUID()
//    var x = Double.random(in: 0...1)
//    var y = Double.random(in: 0...1)
//    var size = Double.random(in: 1...2.5)
//    var speed = Double.random(in: 0.0001...0.0003)
//}
//
//class ParticleEngine: ObservableObject {
//    @Published var particles: [Particle1]
//    var width: Double
//    var height: Double
//
//    init(count: Int, width: Double, height: Double) {
//        self.width = width
//        self.height = height
//        particles = (0..<count).map { _ in Particle1() }
//    }
//
//    func update() {
//        for i in particles.indices {
//            particles[i].y -= particles[i].speed
//            if particles[i].y < 0 {
//                particles[i].y = 1
//                particles[i].x = Double.random(in: 0...1)
//            }
//        }
//    }
//}
//
//struct ParticleBackground: View {
//    @ObservedObject var engine: ParticleEngine
//
//    var body: some View {
//        TimelineView(.animation) { timeline in
//            Canvas { context, size in
//                engine.width = size.width
//                engine.height = size.height
//                engine.update()
//
//                for particle in engine.particles {
//                    let x = particle.x * size.width
//                    let y = particle.y * size.height
//                    let rect = CGRect(x: x, y: y, width: particle.size, height: particle.size)
//                    context.fill(Path(ellipseIn: rect), with: .color(.purple))
//                }
//            }
//        }
//    }
//}
//
//struct DemoView1: View {
//    @StateObject private var engine = ParticleEngine(count: 1120, width: 470, height: 760)
//
//    var body: some View {
//        ZStack {
//            ParticleBackground(engine: engine)
//            VStack {
//                Text("Cyber UI")
//                    .foregroundColor(.purple)
//                    .font(.largeTitle)
//            }
//        }
//    }
//}
//
//#Preview {
//    DemoView1()
//}
