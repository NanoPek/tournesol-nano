//
//  TutorialSheet.swift
//  Tournesol
//
//  Created by Jérémie Carrez on 14/11/2024.
//

import SwiftUI
import DesignSystem

struct TutorialSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: .zero) {
            Text("Welcome to Tournesol Nano!")
                .font(.title)
                .bold()

            VStack(alignment: .leading, spacing: .large) {
                TutorialRow(
                    headline: "Get Video Recommendations",
                    description: "Discover collaborative content recommendations tailored to your interests.",
                    systemName: "rectangle.stack"
                )
                TutorialRow(
                    headline: "Watch YouTube on the App",
                    description: "Enjoy all community-recommended videos directly on the app, ad-free!",
                    systemName: "play.display",
                    iconColor: .red
                )
                TutorialRow(
                    headline: "Compare Videos Easily",
                    description: "After watching a video, directly compare it to others you've seen. Help the community curate better content!",
                    systemName: "rectangle.on.rectangle.angled"
                )
                TutorialRow(
                    headline: "Log In to your Tournesol Account",
                    description: "View and edit your rate later list, comparison history, and more!",
                    systemName: "person.2"
                )
                Button("Let's Start!", systemImage: "sun.horizon") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.large)
        }
    }
}

#Preview {
    VStack {}
        .background(.gray)
        .sheet(isPresented: .constant(true)) {
            TutorialSheet()
        }
}
