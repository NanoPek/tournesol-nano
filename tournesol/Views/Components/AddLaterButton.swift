//
//  AddLaterButton.swift
//  tournesol
//
//  Created by Jérémie Carrez on 15/11/2024.
//

import SwiftUI

struct AddLaterButton: View {
    let video_id: String
    let onRemoved: (() async -> Void)?

    @Environment(\.isRateLater) private var isRateLater
    @Environment(\.showError) private var showError

    var body: some View {
        if isRateLater {
            Button("Remove from rate later", systemImage: "trash", role: .destructive) {
                Task {
                    do {
                        try await UseCase.removeFromRateLaterList(video_id)
                        await onRemoved?()
                    } catch {
                        showError(error)
                    }
                }
            }
        } else {
            Button("Rate later", systemImage: "clock.arrow.circlepath") {
                Task {
                    do {
                        try await UseCase.addToRateLaterList(video_id)
                    } catch {
                        showError(error)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        AddLaterButton(video_id: "", onRemoved: nil)
        AddLaterButton(video_id: "", onRemoved: nil)
            .environment(\.isRateLater, true)
    }
}
