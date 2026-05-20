import SwiftUI

struct WallpaperPreset: Identifiable {

    let id = UUID()
    let colors: [Color]
    let emojis: [String]
    let emojiCount: Int
    let presetName: String
    let textColor: Color  //ОДИН Color, не массив
}

extension WallpaperPreset {
    
    static let blank = WallpaperPreset(
        colors: [.clear],
        emojis: [],
        emojiCount: 0,
        presetName: "🌌",
        textColor: .clear
    )
    
    static let smoking = WallpaperPreset(
        colors: [Color(red: 0.60 , green: 0.77 , blue: 0.42)],
        emojis: ["🌿", "🌱", "🍃"],
        emojiCount: 80,
        presetName: "🚬",
        textColor: Color(red: 0.16, green: 0.38, blue: 0.30)
    )

    static let fire = WallpaperPreset(
        colors: [Color(red: 0.85, green: 0.58, blue: 0.62),
                 Color(red: 0.98, green: 0.92, blue: 0.92),
                 Color(red: 0.92, green: 0.75, blue: 0.77)],
        emojis: ["🌸", "🎀", "🍥"],
        emojiCount: 100,
        presetName: "🍷",
        textColor: Color(red: 0.45, green: 0.28, blue: 0.33)
    )
    
    static let freshness = WallpaperPreset(
        colors: [
            Color.white,
            Color(red: 0.90, green: 0.97, blue: 1.00), // легкий голубой
            Color(red: 0.94, green: 1.00, blue: 0.97)  // легкий зелёный
        ],
        emojis: ["💧", "🌱", "🕊️"],
        emojiCount: 50,
        presetName: "💉",
        textColor: Color(red: 0.40, green: 0.50, blue: 0.55) // приглушенно серый бирюзовый
    )

    static let allPresets = [
        smoking, fire, freshness
    ]
}
#Preview {
    ContentView()
}
