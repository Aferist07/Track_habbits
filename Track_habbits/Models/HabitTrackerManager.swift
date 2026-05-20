import Foundation
import SwiftUI
import Combine

struct Achievement: Identifiable, Codable {
    let id: UUID = UUID()
    let title: String // "день", "неделя"
    let emoji: String // иконка
    let duration: Int // в секундах
    let dateAchieved: Date? // nil если не достигнуто
}

struct HabitHistoryEntry: Identifiable, Codable {
    let id: UUID = UUID()
    let trackerID: UUID
    let presetName: String
    let attemptDate: Date
    let duration: Int
    let reason: String?
}

class HabitTrackerManager: ObservableObject {

    @Published var trackers: [HabitTracker] = [] // все трекеры
    @Published var selectedTrackerID: UUID?
    @Published var showTrackersList: Bool = false
    @Published var history: [HabitHistoryEntry] = []

    private var timerCancellable: AnyCancellable?

    init() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }

    func addTracker(with preset: WallpaperPreset) {
        guard !trackers.contains(where: { $0.preset.presetName == preset.presetName }) else { return }
        let tracker = HabitTracker(
            preset: preset,
            startDate: nil,
            isOn: false
        )
        trackers.append(tracker)
        selectedTrackerID = tracker.id
    }

    func startTracker(_ tracker: HabitTracker) {
        updateTracker(tracker.id) { t in
            t.isOn = true
            t.startDate = Date().timeIntervalSince1970
        }
    }

    func finishTracker(_ tracker: HabitTracker, reason: String?) {
        if tracker.isOn {
            let entry = HabitHistoryEntry(
                trackerID: tracker.id,
                presetName: tracker.preset.presetName,
                attemptDate: Date(),
                duration: tracker.totalSeconds,
                reason: reason
            )
            history.append(entry)
        }
        removeTracker(tracker)
    }

    func removeTracker(_ tracker: HabitTracker) {
        if selectedTrackerID == tracker.id {
            selectedTrackerID = nil
        }
        trackers.removeAll { $0.id == tracker.id }
    }

    func selectTracker(_ tracker: HabitTracker) {
        selectedTrackerID = tracker.id
    }

    var selectedTracker: HabitTracker? {
        trackers.first(where: { $0.id == selectedTrackerID })
    }

    private func updateTracker(_ id: UUID, mutate: (inout HabitTracker) -> Void) {
        guard let idx = trackers.firstIndex(where: { $0.id == id }) else { return }
        mutate(&trackers[idx])
    }

// MARK: - Статистика для экрана "История"

    func attemptsCount(for presetName: String) -> Int {
        history.filter { $0.presetName == presetName }.count
    }

    func bestResult(for presetName: String) -> Int {
        history.filter { $0.presetName == presetName }
            .map { $0.duration }
            .max() ?? 0
    }

    func entries(for presetName: String) -> [HabitHistoryEntry] {
        history.filter { $0.presetName == presetName }
            .sorted { $0.attemptDate > $1.attemptDate }
    }

    // MARK: - Live-ачивки

/// Текущий live-прогресс по трекеру — либо активный трекер, либо лучший результат
    func currentProgress(for presetName: String) -> Int {
        if let tracker = trackers.first(where: { $0.preset.presetName == presetName && $0.isOn }),
           let start = tracker.startDate {
            return Int(Date().timeIntervalSince1970 - start)
        }
        return bestResult(for: presetName)
    }

/// Ачивки для трекера (live: учитываем и активный прогресс)
    func achievements(for presetName: String) -> [Achievement] {
        let thresholds: [(String, String, Int)] = [
            ("1 день", "🥇", 86400),
            ("3 дня", "🥈", 3 * 86400),
            ("Неделя", "🥉", 7 * 86400),
            ("Месяц", "🏅", 30 * 86400),
            ("3 месяца", "🎖️", 90 * 86400),
            ("Полгода", "🏆", 182 * 86400),
            ("Год", "🏵️", 365 * 86400)
        ]
        let entries = self.entries(for: presetName)
        let liveProgress = currentProgress(for: presetName)
        var result: [Achievement] = []
        for (title, emoji, threshold) in thresholds {
            let firstAchieved = entries.first { $0.duration >= threshold }
            let dateAchieved: Date? = firstAchieved?.attemptDate ?? (firstAchieved == nil && liveProgress >= threshold ? Date() : nil)
            result.append(Achievement(
                title: title,
                emoji: emoji,
                duration: threshold,
                dateAchieved: dateAchieved
            ))
        }
        return result
    }
}

#Preview{
    ContentView()
}
