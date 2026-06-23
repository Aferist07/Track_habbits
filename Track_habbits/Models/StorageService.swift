import Foundation

final class StorageService {

    static let shared = StorageService()

    private init() {}

    private let trackersKey = "trackers"
    private let historyKey = "history"

    func saveTrackers(_ trackers: [HabitTracker]) {

        if let data = try? JSONEncoder().encode(trackers) {
            UserDefaults.standard.set(data, forKey: trackersKey)
        }
    }

    func loadTrackers() -> [HabitTracker] {

        guard
            let data = UserDefaults.standard.data(forKey: trackersKey),
            let trackers = try? JSONDecoder().decode([HabitTracker].self, from: data)
        else {
            return []
        }

        return trackers
    }

    func saveHistory(_ history: [HabitHistoryEntry]) {

        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    func loadHistory() -> [HabitHistoryEntry] {

        guard
            let data = UserDefaults.standard.data(forKey: historyKey),
            let history = try? JSONDecoder().decode([HabitHistoryEntry].self, from: data)
        else {
            return []
        }

        return history
    }
}
