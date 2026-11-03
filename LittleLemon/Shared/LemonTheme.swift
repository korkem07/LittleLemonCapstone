import SwiftUI

// The Little Lemon-inspired visual language is defined in one place.
enum LemonTheme {
    static let green = Color(red: 0.286, green: 0.369, blue: 0.341)
    static let yellow = Color(red: 0.957, green: 0.808, blue: 0.078)
    static let ivory = Color(red: 0.982, green: 0.978, blue: 0.950)
    static let ink = Color(red: 0.157, green: 0.208, blue: 0.192)
    static let muted = Color(red: 0.47, green: 0.51, blue: 0.49)
    static let line = Color(red: 0.89, green: 0.91, blue: 0.88)
}

struct BrandLogo: View {
    var compact = false

    var body: some View {
        HStack(spacing: 7) {
            ZStack {
                Circle().fill(LemonTheme.yellow)
                Image(systemName: "leaf.fill")
                    .font(.system(size: compact ? 13 : 17, weight: .black))
                    .foregroundStyle(LemonTheme.green)
                    .rotationEffect(.degrees(-27))
            }
            .frame(width: compact ? 27 : 34, height: compact ? 27 : 34)

            Text("little lemon")
                .font(.system(size: compact ? 20 : 26, weight: .heavy, design: .rounded))
                .tracking(-1.4)
                .foregroundStyle(LemonTheme.green)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Little Lemon restaurant")
    }
}

struct LemonButton: View {
    let title: String
    var enabled = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(enabled ? LemonTheme.yellow : LemonTheme.line)
            .foregroundStyle(LemonTheme.ink)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!enabled)
        .accessibilityLabel(title)
    }
}
