//

import SwiftUI

struct LeaderboardSwiftUIView: View {
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                VStack {
                    HStack {
                        Text("Name")
                            .fontWeight(.bold)
                        Spacer()
                        Text("Points")
                            .fontWeight(.bold)
                        Spacer()
                            .frame(width: 30)
                    }
                    .padding([.leading, .top], 20)
                    .frame(width: proxy.size.width)
                    List(Mocks.leaderboard) { player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            Text(player.points)
                            Spacer()
                                .frame(width: 20)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationBarTitle("Leaderboard") //DZ_8_2
    }
}

#Preview {
    LeaderboardSwiftUIView()
}

extension View {
#if os(macOS)
    @ViewBuilder
    func navigationBarTitle(_ title: String) -> some View {
        if #available(macOS 11.0, *) {
            navigationTitle(title)
        }
    }
#endif
}
