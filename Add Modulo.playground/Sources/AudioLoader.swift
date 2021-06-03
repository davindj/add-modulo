
import AVFoundation

public class AudioLoader{
    private init(){}
    static func load(filename: String, fileType: String)->AVAudioPlayer{
        var audio: AVAudioPlayer!
        do{
            audio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: fileType)!))
            audio?.prepareToPlay()
        }catch{
            fatalError("Audio \(filename) not found!")
        }
        return audio
    }
}
