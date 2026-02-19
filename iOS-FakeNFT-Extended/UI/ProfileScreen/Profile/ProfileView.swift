//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct ProfileView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: ProfileViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appWhite.ignoresSafeArea()
                
                if let profile = viewModel.profile {
                    contentView(profile)
                } else {
                    Color.clear
                }
            }
            .task {
                if viewModel.profile == nil {
                    await viewModel.loadProfile()
                }
            }
            .onChange(of: viewModel.isLoading) { _, isLoading in
                if isLoading {
                    ProgressHUD.animate()
                } else {
                    ProgressHUD.dismiss()
                }
            }
            .alert(ProfileConstants.errorAlertTitle, isPresented: $viewModel.showErrorAlert) {
                Button(ProfileConstants.retryButton) {
                    Task {
                        await viewModel.retry()
                    }
                }
                Button(ProfileConstants.cancelButton, role: .cancel) {}
            } message: {
                if let message = viewModel.errorMessage {
                    Text(message)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.openEditProfile()
                    } label: {
                        Image(.edit)
                            .foregroundStyle(.appBlack)
                    }
                    .disabled(viewModel.profile == nil)
                }
            }
            .navigationDestination(isPresented: $viewModel.showEditProfile) {
                if let profile = viewModel.profile,
                   let editViewModel = viewModel.createEditViewModel() {
                    EditProfileView(
                        profile: profile,
                        viewModel: editViewModel,
                        onProfileUpdated: {
                            Task {
                                await viewModel.refreshProfile()
                            }
                        }
                    )
                }
            }
            .sheet(isPresented: $viewModel.showWebView) { // sheet показался для ux лучше.
                if let website = viewModel.profile?.website {
                    let url = website.hasPrefix("http") ? website : "https://\(website)"
                    WebViewScreen(urlString: url)
                }
            }
            .navigationDestination(isPresented: $viewModel.showMyNFT) {
                MyNFTView(
                    viewModel: MyNFTViewModel(
                        service: ProfileMyNFTService()
                    )
                )
            }
            .navigationDestination(isPresented: $viewModel.showFavoriteNFT) {
                FavoriteNFTView()
            }
            
        }
    }
    
    // MARK: - View Components
    
    private func contentView(_ profile: UserProfile) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                avatarNameSection(profile)
                bioSection(profile)
                menuSection(profile)
            }
            .padding()
        }
    }
    
    private func avatarNameSection(_ profile: UserProfile) -> some View {
        HStack(spacing: 16) {
            ProfileAvatar(urlString: profile.avatar, editMode: false)
                .font(.caption)
                .foregroundStyle(.red)
            Text(profile.name)
                .font(Font.bold22)
                .foregroundStyle(.appBlack)
        }
        
    }
    
    private func bioSection(_ profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(profile.description)
                .font(Font.regular13)
                .foregroundStyle(.appBlack)
            
            Button {
                viewModel.openWebsite()
            } label: {
                Text(profile.website
                    .replacingOccurrences(of: "https://", with: "")
                    .replacingOccurrences(of: "http://", with: ""))
                .font(Font.regular15)
                .foregroundStyle(.appBlue)
            }
        }
    }
    
    private func menuSection(_ profile: UserProfile) -> some View {
        VStack(spacing: 0) {
            Button {
                viewModel.openMyNFT()
            } label: {
                ProfileMenuLabel(title: ProfileConstants.Menu.myNFTTitle, count: profile.myNftCount)
            }
            
            Button {
                viewModel.openFavoriteNFT()
            } label: {
                ProfileMenuLabel(title: ProfileConstants.Menu.favoriteNFTTitle, count: profile.favoriteNftCount)
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(
            profileService: ProfileService(
                networkClient: DefaultNetworkClient(),
                storage: ProfileStorage()
            )
        )
    )
}
