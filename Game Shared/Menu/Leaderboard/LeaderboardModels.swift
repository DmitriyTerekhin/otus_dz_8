//

import Foundation

struct LeaderboardModel: Identifiable {
    
    var id: UUID = UUID()
    
    var name: String
    var points: String
}

extension Mocks {
    static let leaderboard: [LeaderboardModel] = [
        LeaderboardModel(name: "Oskar", points: "120"),
        LeaderboardModel(name: "Player", points: "90"),
        LeaderboardModel(name: "Vitino", points: "84"),
        LeaderboardModel(name: "Maye", points: "65"),
        LeaderboardModel(name: "Yamal", points: "40"),
        LeaderboardModel(name: "Levandovski", points: "12"),
        LeaderboardModel(name: "MBAPE", points: "4"),
        LeaderboardModel(name: "Ju", points: "1")
    ]
}
