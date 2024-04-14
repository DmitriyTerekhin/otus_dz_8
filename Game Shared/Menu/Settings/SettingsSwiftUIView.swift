//

import SwiftUI

struct SettingsSwiftUIView: View {
    
    @Binding var viewModel: MenuViewModel
    
    var body: some View {
        VStack { //DZ_8_2
            Text("Change music volume")
            HStack {
                Button {
                    viewModel.changeVolume(on: .up(0.1))
                } label: {
                    Text("+")
                }
                Button {
                    viewModel.changeVolume(on: .down(0.1))
                } label: {
                    Text("-")
                }
            }

        }
        .navigationBarTitle("Settings") //DZ_8_2
    }
}

#Preview {
    SettingsSwiftUIView(viewModel: .constant(MenuViewModel()))
}
