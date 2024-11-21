//
//  ThumbnailView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 24/06/2024.
//

import SwiftUI
import Model

struct ThumbnailView: View {
    let video_id: String
    let duration: Duration?

    var body: some View {
        AsyncImage(url: URL(string: Constants.URL.Youtube.ytPreview(uid: video_id))!,
                   content: { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(alignment: .bottomTrailing) {
                    if let duration {
                        Text(duration.formatted(.time(pattern: .minuteSecond)))
                            .font(.footnote)
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.xSmall)
                            .background(
                                RoundedRectangle(cornerRadius: .small)
                                    .fill(.black.opacity(0.7))
                            )
                            .padding(.small)
                    }
                }
        }, placeholder: {
            Rectangle()
                .fill(.surfaceCard)
                .overlay { ProgressView() }
                .frame(maxWidth: .infinity)
                .aspectRatio(16/9, contentMode: .fit)
        })
    }
}
