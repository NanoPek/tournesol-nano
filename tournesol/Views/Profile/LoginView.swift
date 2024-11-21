//
//  LoginView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 15/07/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userEnv: UserEnvironment

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggin: Bool = false
    @State private var error: AppError?

    var body: some View {
        Form {
            loginSection
        }
        .navigationTitle("Log in")
    }
}

// MARK: - Sections -
private extension LoginView {
    var loginSection: some View {
        Section {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
        } header: {
            Text("Log in to see your comparisons!")
        } footer: {
            VStack(alignment: .leading) {
                Button("Log in", systemImage: "person.badge.key", action: login)
                    .buttonStyle(.borderedProminent)
                    .disabled(username.isEmpty || password.isEmpty || isLoggin)
                if let error {
                    VStack(alignment: .leading) {
                        Text(error.localizedDescription)
                            .bold()
                        if let guidance = error.guidance {
                            Text(guidance)
                        }
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
}

private extension LoginView {
    func login() {
        Task {
            isLoggin = true
            defer { isLoggin = false }
            do {
                try await userEnv.login(username: username, password: password)
                dismiss()
            } catch {
                self.error = error.toAppError
            }
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                LoginView()
                    .environmentObject(UserEnvironment())
            }
        }
}
