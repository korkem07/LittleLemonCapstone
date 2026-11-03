import SwiftUI
import UIKit

struct ProfileView: View {
    @AppStorage("littlelemon.isOnboarded") private var isOnboarded = false
    @AppStorage("littlelemon.firstName") private var firstName = ""
    @AppStorage("littlelemon.lastName") private var lastName = ""
    @AppStorage("littlelemon.email") private var email = ""
    @AppStorage("littlelemon.orderUpdates") private var orderUpdates = true
    @AppStorage("littlelemon.specialOffers") private var specialOffers = false

    @State private var showLogoutConfirmation = false
    @State private var showSaved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(LemonTheme.green)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("My Profile")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundStyle(LemonTheme.ink)
                        Text("Manage your personal details")
                            .font(.footnote)
                            .foregroundStyle(LemonTheme.muted)
                    }
                }

                VStack(alignment: .leading, spacing: 18) {
                    sectionHeading("PERSONAL INFORMATION")
                    profileField("First name", text: $firstName, contentType: .givenName)
                    profileField("Last name", text: $lastName, contentType: .familyName)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(LemonTheme.ink)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .padding(13)
                            .background(LemonTheme.ivory, in: RoundedRectangle(cornerRadius: 10))
                            .accessibilityIdentifier("profile.email")
                    }
                }
                .padding(19)
                .background(.white, in: RoundedRectangle(cornerRadius: 19))

                VStack(alignment: .leading, spacing: 16) {
                    sectionHeading("EMAIL NOTIFICATIONS")
                    Toggle("Order status updates", isOn: $orderUpdates)
                    Toggle("Special offers", isOn: $specialOffers)
                }
                .tint(LemonTheme.green)
                .padding(19)
                .background(.white, in: RoundedRectangle(cornerRadius: 19))

                Button {
                    showSaved = true
                } label: {
                    Label("Save changes", systemImage: "checkmark")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(LemonTheme.yellow, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(LemonTheme.ink)
                }
                .accessibilityIdentifier("profile.save")

                Button(role: .destructive) {
                    showLogoutConfirmation = true
                } label: {
                    Text("Log out")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.red.opacity(0.4)))
                        .foregroundStyle(.red)
                }
                .accessibilityIdentifier("profile.logout")
            }
            .padding(20)
        }
        .background(LemonTheme.ivory.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .alert("Changes saved", isPresented: $showSaved) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile is saved on this device and will be available after you restart the app.")
        }
        .confirmationDialog("Log out of Little Lemon?", isPresented: $showLogoutConfirmation) {
            Button("Log out and clear data", role: .destructive) {
                firstName = ""
                lastName = ""
                email = ""
                orderUpdates = true
                specialOffers = false
                isOnboarded = false
            }
        } message: {
            Text("Your profile data will be removed from this device.")
        }
    }

    private func sectionHeading(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .bold))
            .tracking(1.1)
            .foregroundStyle(LemonTheme.green)
    }

    private func profileField(_ label: String, text: Binding<String>, contentType: UITextContentType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(LemonTheme.ink)
            TextField(label, text: text)
                .textContentType(contentType)
                .textInputAutocapitalization(.words)
                .padding(13)
                .background(LemonTheme.ivory, in: RoundedRectangle(cornerRadius: 10))
        }
    }
}
