//

import Foundation
import AVFAudio

class MenuViewModel {
    
    private var musicPlayer: AVAudioPlayer? = {
        var bgMusicUrl: URL = Bundle.main.url(forResource: "the-epic-2-by-rafael-krux(chosic.com)", withExtension: "mp3")!
        let player = try? AVAudioPlayer(contentsOf: bgMusicUrl, fileTypeHint: nil)
        player?.numberOfLoops = (-1)
        return player
    }()
    
    func playMusic() {
        guard musicPlayer?.prepareToPlay() ?? false else { return }
        musicPlayer?.play()
    }
    
    func changeVolume(on volume: ChangeVolume) {
        musicPlayer?.volume += volume.change
    }
    
}
