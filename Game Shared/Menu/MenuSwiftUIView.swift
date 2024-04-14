//

import SwiftUI

struct MenuSwiftUIView: View {
    
    private let menu = Menu.allCases
    @State private var menuViewModel = MenuViewModel()
    @State private var selectedItem: String?
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 50) {
                    // DZ_8_1
                    ForEach(menu) { raw in
                        NavigationLink(
                            raw.title,
                            tag: raw.title,
                            selection: $selectedItem) {
                            switch raw {
                            case .play:
                                //DZ_8_1.1
                                SceneView(scene: GameScene.newGameScene())
                                    .navigationBarTitle("Game") //DZ_8_2
                            case .leaderboard:
                                //DZ_8_1.3
                                LeaderboardSwiftUIView()
                            case .settings:
                                //DZ_8_1.2
                                SettingsSwiftUIView(
                                    viewModel: $menuViewModel
                                )
                            }
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }.onAppear(perform: {
            menuViewModel.playMusic()
        })
    }
}

#Preview {
    MenuSwiftUIView()
}
