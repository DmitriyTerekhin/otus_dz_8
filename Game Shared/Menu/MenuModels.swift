//

import Foundation


enum Menu: String, Identifiable, CaseIterable {
    
    var id: String { rawValue }
    
    case play
    case leaderboard
    case settings
    
    var title: String {
        return rawValue.capitalized
    }
}

enum ChangeVolume {
    case up(Float)
    case down(Float)
    
    var change: Float {
        switch self {
        case .up(let float):
            return float
        case .down(let float):
            return -float
        }
    }
}
