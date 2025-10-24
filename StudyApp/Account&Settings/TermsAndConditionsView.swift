import SwiftUI

struct TermsAndConditionsView: View {
    @State private var acceptEnabled = false
    @State private var accepted = false

    var body: some View {
        VStack(spacing: 0) {
            // Title
            HStack {
                Text("Terms & Conditions")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()

            // Scrollable terms content
            GeometryReader { outerProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        // Replace the text below with your actual terms. This is a long placeholder
                        Group {
                            Text(sampleTerms)
                                .fixedSize(horizontal: false, vertical: true)

                            // add some more paragraphs to ensure scrollable content
                            ForEach(0..<4) { _ in
                                Text(sampleParagraph)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        // A hidden view at the bottom we measure in the named coordinate space
                        GeometryReader { bottomGeo in
                            Color.clear
                                .preference(key: BottomMinYPreferenceKey.self,
                                            value: bottomGeo.frame(in: .named("termsScroll")).minY)
                        }
                        .frame(height: 1)
                    }
                    .padding()
                }
                .coordinateSpace(name: "termsScroll")
                .onPreferenceChange(BottomMinYPreferenceKey.self) { bottomMinY in
                    // If the bottom's minY is <= visible height of the scroll area -> bottom is visible
                    // small tolerance to account for fractional pixels
                    let visible = bottomMinY <= outerProxy.size.height + 1
                    if visible != acceptEnabled {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            acceptEnabled = visible
                        }
                    }
                }
            }

            // Accept button pinned to bottom
            VStack(spacing: 12) {
                Divider()
                Button(action: {
                    accepted = true
                }) {
                    Text(accepted ? "Accepted" : "Accept")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.headline)
                }
                .disabled(!acceptEnabled || accepted)
                .opacity((acceptEnabled && !accepted) ? 1.0 : 0.5)
                .padding([.leading, .trailing, .bottom])
            }
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// PreferenceKey that carries the bottom geometry's minY in the named coordinate space
private struct BottomMinYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Sample placeholder text
private let sampleTerms = """
Welcome to our app. Please read these Terms & Conditions carefully before using the service. By tapping Accept you agree to be bound by these terms.\n\n1. Acceptance of terms.\n2. Use license.\n3. Privacy and data collection.\n4. Intellectual property.\n5. Termination.\n\nThis is placeholder legal text to demonstrate scrolling behaviour — replace with your real terms.
"""

private let sampleParagraph = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet.\n\n"

// MARK: - Preview
struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}