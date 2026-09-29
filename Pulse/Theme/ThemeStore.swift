import Foundation

struct ThemeStore {
    enum StoreError: LocalizedError {
        case missingResource(String)
        case missingDefaultTheme

        var errorDescription: String? {
            switch self {
            case let .missingResource(name):
                return "找不到内置主题资源：\(name).json"
            case .missingDefaultTheme:
                return "内置主题中缺少 Pulse Dark"
            }
        }
    }

    private let bundle: Bundle

    /// 创建主题资源仓库。
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// 从应用资源中严格解码全部内置 JSON 主题。
    func loadBuiltInThemes() throws -> [PulseTheme] {
        let resourceNames = ["pulse-dark", "ocean", "forest"]
        var themes: [PulseTheme] = []

        for resourceName in resourceNames {
            guard let resourceURL = bundle.url(forResource: resourceName, withExtension: "json") else {
                throw StoreError.missingResource(resourceName)
            }

            let data = try Data(contentsOf: resourceURL)
            themes.append(try JSONDecoder().decode(PulseTheme.self, from: data))
        }

        return themes
    }
}
