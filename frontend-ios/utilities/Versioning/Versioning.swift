import Foundation

struct AppVersion: Comparable {
    let major: Int, minor: Int, patch: Int
    init(_ string: String) {
        let parts = string.split(separator: ".").map { Int($0) ?? 0 }
        major = parts.indices.contains(0) ? parts[0] : 0
        minor = parts.indices.contains(1) ? parts[1] : 0
        patch = parts.indices.contains(2) ? parts[2] : 0
    }
    static func < (l: AppVersion, r: AppVersion) -> Bool {
        if l.major != r.major { return l.major < r.major }
        if l.minor != r.minor { return l.minor < r.minor }
        return l.patch < r.patch
    }
}

func currentShortVersion() -> String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
}
