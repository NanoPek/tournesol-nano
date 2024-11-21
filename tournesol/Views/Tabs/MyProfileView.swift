//
//  MyProfileView.swift
//  tournesol
//
//  Created by Jérémie Carrez on 17/06/2024.
//

import SwiftUI
import Model
import DesignSystem

struct MyProfileView: View {
    @Environment(\.showError) private var showError
    @Environment(\.openURL) private var openURL

    @EnvironmentObject private var userEnv: UserEnvironment
    @StateObject private var navEnv: NavigationEnvironment = .init()

    @State private var isLogginSheetPresented: Bool = false
    @State private var showDeleteAccountAlert: Bool = false

    var body: some View {
        NavigationStack(path: $navEnv.path) {
            contentView
                .animation(.default, value: userEnv.isLogged)
                .navigationTitle("My Profile")
                .navigationDestination(for: NavigationEnvironment.Path.self) { path in
                    switch path {
                    case .video(let video):
                        VideoDetailsView(video: video)
                    case .videoInRateLater(let video):
                        VideoDetailsView(video: video)
                            .environment(\.isRateLater, true)
                    case .compare(let video_a, let video_b):
                        ComparisonView(video_a: video_a, video_b: video_b)
                    case .webView(let url):
                        WebView(url: url)
                    case .myRecos(let username):
                        TournesolVideoList(kind: .perso(username))
                            .navigationTitle("My recommendations")
                    case .myComparisons:
                        MyComparisonsView()
                    case .myRateLater:
                        TournesolVideoList(kind: .rateLater)
                            .navigationTitle("My rate later list")
                            .environment(\.isRateLater, true)
                    }
                }
                .toolbar {
                    if userEnv.user != nil {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu("Logout", systemImage: "person.badge.minus") {
                                Button("Logout", systemImage: "person.badge.minus") {
                                    userEnv.logout()
                                }
                                .labelStyle(.titleAndIcon)
                                Button("Delete my account", systemImage: "trash", role: .destructive) {
                                    showDeleteAccountAlert = true
                                }
                                .labelStyle(.titleAndIcon)
                            }
                            .buttonStyle(.borderedProminent)
                            .labelStyle(.iconOnly)
                        }
                    }
                }
                .sheet(isPresented: $isLogginSheetPresented) {
                    NavigationStack {
                        LoginView()
                    }
                }
                .alert("Are you sure you want to delete your account?", isPresented: $showDeleteAccountAlert) {
                    if let url = URL(string: Constants.URL.Tournesol.deleteAccount) {
                        Button("Yes, delete my account", role: .destructive) {
                            userEnv.logout()
                            openURL(url)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("You will be redirected to the Tournesol website to delete your account.")
                }

        }
        .environmentObject(navEnv)
    }

    private var contentView: some View {
        List {
            Group {
                profileSection
                if userEnv.isLogged, let username = userEnv.user?.username {
                    Section {
                        NavigationLink(value: NavigationEnvironment.Path.myRecos(username)) {
                            Text("My recommendations")
                        }
                        NavigationLink(value: NavigationEnvironment.Path.myComparisons) {
                            Text("My comparisons")
                        }
                        NavigationLink(value: NavigationEnvironment.Path.myRateLater) {
                            Text("My rate later list")
                        }
                    }
                }
            }
            .listRowBackground(.surfaceCard)
        }
        .listBackground()
    }

    private func profileRow(username: String?) -> some View {
        VStack {
            LargeIconLabel(systemImage: username == nil ? "person.fill.questionmark" : "person.fill", backgroundColor: .accentColor)
            Group {
                if let username {
                    Text(username)
                } else {
                    Text("Disconnected")
                }
            }
            .font(.title2)
            .bold()
            Text(username == nil ? "Log in to see your comparisons!" : "Welcome to your profile!")
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private var profileSection: some View {
        Section {
            profileRow(username: userEnv.user?.username)
        } footer: {
            if !userEnv.isLogged {
                VStack(alignment: .leading) {
                    Button("Log in", systemImage: "person.badge.key") {
                        isLogginSheetPresented = true
                    }
                    if let url = URL(string: Constants.URL.Tournesol.signUp) {
                        Button("Sign Up", systemImage: "person.badge.plus") {
                            navEnv.path.append(.webView(url))
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    MyProfileView()
}
