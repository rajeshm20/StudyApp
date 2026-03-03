//
//  CourseDetailsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/11/25.
//

import AVKit
import SwiftUI

struct CourseDetailsView: View {
    @State private var selectedVideoIndex: Int? = 0
    private let courseTitle = "How to make your design more artful & lyrical"
    private let courseDescription = "Aliquam tincidunt viverra fames convallis. Elementum hendrerit semper lectus placerat."
    private let videos = [
        ("Introductions", "30 min"),
        ("Getting Inspired", "15 min"),
        ("Make a Concept", "10 min"),
        ("Make a Design Sketch", "10 min"),
    ]
    var router: Router<MainRoute>

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Course Title

                VStack(alignment: .leading, spacing: 6) {
                    Text(courseTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .lineSpacing(2)
                        .padding(.horizontal)

                    // MARK: - Video Preview

                    VideoThumbnailView()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .padding(.top)

                    // About this course
                    Text("About this course")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.horizontal)

                    Text(courseDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }

                // MARK: - Contents Section

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Contents")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))

                        Spacer()
                        Text("\(videos.count) videos")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 10) {
                        ForEach(videos.indices, id: \.self) { index in
                            Button {
                                withAnimation {
                                    selectedVideoIndex = index
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(selectedVideoIndex == index ? Color.white : Color.clear)
                                        .frame(width: 10, height: 10)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedVideoIndex == index ? Color.white : Color.gray.opacity(0.4), lineWidth: 1)
                                        )

                                    Text(videos[index].0)
                                        .font(.body)
                                        .fontWeight(selectedVideoIndex == index ? .semibold : .regular)
                                        .foregroundColor(selectedVideoIndex == index ? .white : .black)
                                        .lineLimit(1)

                                    Spacer()

                                    Text(videos[index].1)
                                        .font(.subheadline)
                                        .foregroundColor(selectedVideoIndex == index ? .white.opacity(0.9) : .gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(selectedVideoIndex == index ? Color(hex: "4178D4") : Color.gray.opacity(0.1))
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // MARK: - Add to My Course Button

                Button(action: {
                    print("Added to course")
                }) {
                    Text("Add to my course")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "52B6DF"))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// REVISED: VideoThumbnailView plays an actual video using VideoPlayer and AVPlayer.
// NOTE: Replace the URL below with your own direct playable video link if you wish.
struct VideoThumbnailView: View {
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    @State private var player = AVPlayer(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)

    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 180)
            .onAppear {
                player.play()
            }
            .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        CourseDetailsView(router: Router<MainRoute>())
    }
}
