import SwiftUI

struct ThemeStoreView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var searchText = ""

    private let categories = ["推荐", "热门", "最新", "免费", "官方", "社区"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("主题")
                        .font(.system(size: 32, weight: .bold, design: .rounded))

                    searchField
                    categoryRow

                    Text("为你推荐")
                        .font(.title3.bold())

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(themeManager.availableThemes) { theme in
                            ThemePreviewView(
                                theme: theme,
                                isSelected: theme.id == themeManager.currentTheme.id
                            ) {
                                themeManager.apply(theme)
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .toolbar(.hidden, for: .navigationBar)
            .themedPage()
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)

            TextField("搜索主题", text: $searchText)
                .textInputAutocapitalization(.never)
        }
        .padding(.horizontal, 15)
        .frame(height: 46)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var categoryRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 9) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(category == "推荐" ? themeManager.currentTheme.accentColor : themeManager.currentTheme.secondaryTextColor)
                        .padding(.horizontal, 14)
                        .frame(height: 34)
                        .background(
                            category == "推荐" ? themeManager.currentTheme.accentColor.opacity(0.16) : .white.opacity(0.05),
                            in: Capsule()
                        )
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ThemeStoreView()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
}
