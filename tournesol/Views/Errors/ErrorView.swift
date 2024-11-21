//
//  ErrorView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 13/04/2024.
//

import SwiftUI

struct ErrorView: View {
    let appError: AppError

    var body: some View {
        VStack {
            Label("An error has occurred!", systemImage: "exclamationmark.warninglight")
                .foregroundStyle(.red)
                .font(.headline)
                .padding(.bottom)
            Text(appError.localizedDescription)
                .font(.title3)
                .fontWeight(.medium)
            if let guidance = appError.guidance {
                Text(guidance)
                    .font(.caption)
                    .padding(.top)
            }
        }
        .presentationDetents([.fraction(0.2), .large])
    }
}

#Preview {
    return VStack {}
        .sheet(isPresented: .constant(true)) {
            ErrorView(appError: .loggedOut)
        }
}
