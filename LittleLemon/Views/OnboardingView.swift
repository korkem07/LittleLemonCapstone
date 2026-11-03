import SwiftUI
import UIKit

struct OnboardingView: View {
    @AppStorage("littlelemon.isOnboarded") private var isOnboarded = false
    @AppStorage("littlelemon.firstName") private var savedFirstName = ""
    @AppStorage("littlelemon.lastName") private var savedLastName = ""
    @AppStorage("littlelemon.email") private var savedEmail = ""

    @State private var page = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showEmailError = false

    private var namesValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private var emailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.split(separator: "@").count == 2 &&
            trimmed.split(separator: ".").count > 1 && !trimmed.contains(" ")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BrandLogo(compact: true)
                Spacer()
                Text("\(page + 1) of 3")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(LemonTheme.muted)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            HStack(spacing: 7) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(index <= page ? LemonTheme.green : LemonTheme.line)
                        .frame(height: 5)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            TabView(selection: $page) {
                introduction.tag(0)
                nameStep.tag(1)
                emailStep.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(spacing: 14) {
                if page == 2 {
                    LemonButton(title: "Get started", enabled: namesValid && emailValid) { finish() }
                } else {
                    LemonButton(title: "Next", enabled: page == 0 || namesValid) {
                        withAnimation(.easeInOut(duration: 0.2)) { page += 1 }
                    }
                }

                if page > 0 {
                    Button("Back") {
                        withAnimation { page -= 1 }
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(LemonTheme.green)
                    .padding(.vertical, 5)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 25)
        }
        .background(LemonTheme.ivory.ignoresSafeArea())
    }

    private var introduction: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to\nLittle Lemon")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundStyle(LemonTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("A little sunshine in every bite. Discover fresh Mediterranean favorites from Chicago.")
                    .font(.system(size: 17))
                    .foregroundStyle(LemonTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                Image("HeroSalad")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 245)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                Label("Fresh food, made with love", systemImage: "heart.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(LemonTheme.green)
            }
            .padding(.horizontal, 24)
            .padding(.top, 35)
        }
    }

    private var nameStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                stepHeading("Nice to meet you!", subtitle: "Tell us your name so we can make your visits personal.")
                VStack(alignment: .leading, spacing: 17) {
                    inputField("First name", placeholder: "e.g. Alex", text: $firstName, contentType: .givenName)
                    inputField("Last name", placeholder: "e.g. Morgan", text: $lastName, contentType: .familyName)
                }
                Label("Your details stay on this device.", systemImage: "lock.shield")
                    .font(.footnote)
                    .foregroundStyle(LemonTheme.muted)
            }
            .padding(.horizontal, 24)
            .padding(.top, 44)
        }
    }

    private var emailStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                stepHeading("One last thing", subtitle: "Add your email to complete your profile.")
                VStack(alignment: .leading, spacing: 9) {
                    Text("Email address")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(LemonTheme.ink)
                    TextField("e.g. alex@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(16)
                        .background(.white, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(LemonTheme.line))
                        .accessibilityIdentifier("onboarding.email")
                    if !email.isEmpty && !emailValid {
                        Text("Please enter a valid email address.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                HStack(spacing: 11) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(LemonTheme.green)
                    Text("You're ready to explore the menu!")
                        .font(.subheadline)
                        .foregroundStyle(LemonTheme.ink)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white, in: RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.top, 44)
        }
    }

    private func stepHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(LemonTheme.ink)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(LemonTheme.muted)
        }
    }

    private func inputField(_ label: String, placeholder: String, text: Binding<String>, contentType: UITextContentType) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(label).font(.subheadline.weight(.semibold)).foregroundStyle(LemonTheme.ink)
            TextField(placeholder, text: text)
                .textContentType(contentType)
                .textInputAutocapitalization(.words)
                .padding(16)
                .background(.white, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(LemonTheme.line))
        }
    }

    private func finish() {
        guard namesValid, emailValid else { showEmailError = true; return }
        savedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        savedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        savedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        isOnboarded = true
    }
}
