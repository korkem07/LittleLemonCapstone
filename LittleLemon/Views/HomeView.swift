import SwiftUI

struct HomeView: View {
    @AppStorage("littlelemon.firstName") private var firstName = ""
    @StateObject private var store = MenuStore()
    @State private var searchText = ""
    @State private var category = "All"

    private var filteredMenu: [MenuItem] {
        MenuFilter.apply(to: store.items, category: category, search: searchText)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    hero
                    categories
                    menuList
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 40)
            }
            .background(LemonTheme.ivory.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .task { await store.refresh() }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 10) {
            BrandLogo()
            Spacer(minLength: 4)
            NavigationLink {
                ProfileView()
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 37))
                    .foregroundStyle(LemonTheme.green)
                    .frame(width: 48, height: 48)
                    .accessibilityLabel("Open profile")
            }
            .accessibilityIdentifier("home.profileButton")
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(alignment: .top, spacing: 9) {
                VStack(alignment: .leading, spacing: 9) {
                    Text("Hello, \(firstName.isEmpty ? "friend" : firstName)!")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(LemonTheme.yellow)
                    Text("Little Lemon")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(LemonTheme.yellow)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("Chicago")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Fresh Mediterranean flavors, made with love and served every day.")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.92))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image("HeroSalad")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 150)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .accessibilityLabel("Fresh Greek salad")
            }

            HStack(spacing: 11) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                TextField("Search dishes...", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("home.search")
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .accessibilityLabel("Clear search")
                }
            }
            .foregroundStyle(LemonTheme.ink)
            .padding(14)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(19)
        .background(LemonTheme.green, in: RoundedRectangle(cornerRadius: 23))
    }

    private var categories: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("ORDER FOR DELIVERY")
                .font(.system(size: 19, weight: .heavy, design: .rounded))
                .foregroundStyle(LemonTheme.ink)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach(MenuFilter.categories, id: \.self) { value in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { category = value }
                        } label: {
                            Text(value)
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 17)
                                .padding(.vertical, 11)
                                .background(category == value ? LemonTheme.green : .white,
                                            in: Capsule())
                                .foregroundStyle(category == value ? .white : LemonTheme.green)
                                .overlay(Capsule().stroke(LemonTheme.line, lineWidth: category == value ? 0 : 1))
                        }
                        .accessibilityAddTraits(category == value ? .isSelected : [])
                        .accessibilityIdentifier("category.\(value.lowercased())")
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var menuList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Our menu")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(LemonTheme.ink)
                Spacer()
                if store.isRefreshing {
                    ProgressView().tint(LemonTheme.green)
                } else if store.isOffline {
                    Label("Offline menu", systemImage: "wifi.slash")
                        .font(.caption2)
                        .foregroundStyle(LemonTheme.muted)
                }
            }
            .padding(.bottom, 12)

            if filteredMenu.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 38))
                        .foregroundStyle(LemonTheme.green)
                    Text("No dishes found")
                        .font(.headline)
                    Text("Try another category or search term.")
                        .font(.footnote)
                        .foregroundStyle(LemonTheme.muted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                ForEach(filteredMenu) { item in
                    NavigationLink {
                        MenuDetailView(item: item)
                    } label: {
                        DishRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("dish.\(item.id)")
                    if item.id != filteredMenu.last?.id {
                        Rectangle()
                            .fill(LemonTheme.line)
                            .frame(height: 1)
                    }
                }
            }
        }
    }
}

private struct DishRow: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 13) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(LemonTheme.ink)
                Text(item.description)
                    .font(.system(size: 13))
                    .foregroundStyle(LemonTheme.muted)
                    .lineLimit(2)
                Text(item.formattedPrice)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(LemonTheme.green)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            AsyncImage(url: URL(string: item.image)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .empty, .failure:
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable().scaledToFit()
                        .padding(21)
                        .foregroundStyle(LemonTheme.green)
                @unknown default:
                    Image(systemName: "fork.knife").resizable().scaledToFit()
                }
            }
            .frame(width: 94, height: 92)
            .background(LemonTheme.line.opacity(0.65))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}
