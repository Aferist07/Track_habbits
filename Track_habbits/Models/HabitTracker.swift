import Foundation
import SwiftUI

struct HabitTracker: Identifiable {
    let id: UUID = UUID()
    var preset: WallpaperPreset //внешний вид (имя пресета в стикере)
    var startDate: Double? //время запуска (если nil, то не запущено)
    var isOn: Bool //активен ли таймер

    var totalSeconds: Int {
        guard isOn, let start = startDate else { return 0 }
        return Int(Date().timeIntervalSince1970 - start)
    }
}
