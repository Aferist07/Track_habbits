import SwiftUI

struct AchievementsView: View {
    @ObservedObject var manager: HabitTrackerManager
    @State private var expandedPreset: String? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(WallpaperPreset.allPresets, id: \.presetName) { preset in
                    Section {
                        Button {
                            withAnimation {
                                expandedPreset = expandedPreset == preset.presetName ? nil : preset.presetName
                            }
                        } label: {
                            HStack {
                                Text(preset.presetName)
                                    .font(.system(size: 32))
                                Spacer()
                                Image(systemName: expandedPreset == preset.presetName ? "chevron.down" : "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(.plain)

                        if expandedPreset == preset.presetName {
                            let achievements = manager.achievements(for: preset.presetName)
                            ForEach(achievements) { achievement in
                                HStack(alignment: .center, spacing: 16) {
                                    Text(achievement.emoji)
                                        .font(.largeTitle)
                                        .frame(width: 40, height: 40)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(achievement.title)
                                            .font(.headline)
                                        if let date = achievement.dateAchieved {
                                            Text("Получено: \(date.formatted(date: .abbreviated, time: .omitted))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("Не получено")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        ProgressView(
                                            value: min(Double(manager.currentProgress(for: preset.presetName)), Double(achievement.duration)),
                                            total: Double(achievement.duration)
                                        )
                                        .progressViewStyle(.linear)
                                        .frame(height: 8)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Достижения")
        }
    }
}

#Preview {
    AchievementsView(manager: HabitTrackerManager())
}
