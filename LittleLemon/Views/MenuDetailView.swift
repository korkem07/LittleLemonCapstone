import SwiftUI

struct MenuDetailView: View {
    let item: MenuItem
    @State private var savedToFavorites = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                AsyncImage(url: URL(string: item.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty, .failure:
                        Image("HeroSalad").resizable().scaledToFill()
                    @unknown default:
                        Image("HeroSalad").resizable().scaledToFill()
                    }
                }
                .frame(height: 245)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24))

                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.displayCategory.uppercased())
                            .font(.caption.weight(.bold))
                            .tracking(1)
                            .foregroundStyle(LemonTheme.muted)
                        Text(item.title)
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundStyle(LemonTheme.ink)
                    }
                    Spacer()
                    Text(item.formattedPrice)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(LemonTheme.green)
                }
                Text(item.description)
                    .font(.body)
                    .foregroundStyle(LemonTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    Image(systemName: "leaf")
                    Text("Freshly prepared with care")
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(LemonTheme.green)

                Button {
                    savedToFavorites.toggle()
                } label: {
                    Label(savedToFavorites ? "Saved to favorites" : "Add to favorites",
                          systemImage: savedToFavorites ? "heart.fill" : "heart")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(LemonTheme.yellow, in: RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(LemonTheme.ink)
                }
            }
            .padding(20)
        }
        .background(LemonTheme.ivory.ignoresSafeArea())
        .navigationTitle("Dish details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}
