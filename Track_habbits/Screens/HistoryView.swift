import SwiftUI

struct HistoryView: View {
    @ObservedObject var manager: HabitTrackerManager
    @State private var selectedPreset: String?
    @State private var selectedEntry: HabitHistoryEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(WallpaperPreset.allPresets, id: \.presetName) { preset in
                    Section {
                        let attempts = manager.attemptsCount(for: preset.presetName)
                        let best = manager.bestResult(for: preset.presetName)
                        HStack {
                            Text(preset.presetName)
                                .font(.system(size: 36))
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("попытки")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(attempts)")
                                    .font(.title3)
                                    .bold()
                            }
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("рекорд")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(shortTime(seconds: best))
                                    .font(.title3)
                                    .bold()
                            }
                        }
                        // Список завершений
                        let entries = manager.entries(for: preset.presetName)
                        if !entries.isEmpty {
                            ForEach(entries) { entry in
                                Button {
                                    selectedEntry = entry
                                } label: {
                                    HStack {
                                        Image(systemName: "clock.arrow.circlepath")
                                            .foregroundColor(.gray)
                                        Text(shortTime(seconds: entry.duration))
                                        Spacer()
                                        Text(entry.attemptDate, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        } else {
                            Text("История пуста")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                                .padding(.leading, 32)
                        }
                    }
                }
            }
            .navigationTitle("История")
            .sheet(item: $selectedEntry) { entry in
                HistoryDetailView(entry: entry)
            }
        }
    }

    func shortTime(seconds: Int) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if days > 0 { return "\(days) д" }
        if hours > 0 { return "\(hours) ч" }
        if minutes > 0 { return "\(minutes) м" }
        return "\(secs) с"
    }
}

struct HistoryDetailView: View {
    let entry: HabitHistoryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Попытка \(entry.presetName)")
                .font(.largeTitle)
                .bold()
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Дата завершения")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(entry.attemptDate, style: .date)
                        .font(.body)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Продолжительность")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(shortTime(seconds: entry.duration))")
                    .font(.title2)
                    .bold()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Причина обнуления трекера")
                    .font(.caption)
                    .foregroundColor(.secondary)
                if let reason = entry.reason, !reason.isEmpty {
                    Text(reason)
                } else {
                    Text("—")
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding()
    }

    func shortTime(seconds: Int) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if days > 0 { return "\(days) д" }
        if hours > 0 { return "\(hours) ч" }
        if minutes > 0 { return "\(minutes) м" }
        return "\(secs) с"
    }
}
