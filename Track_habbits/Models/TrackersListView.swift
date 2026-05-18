import SwiftUI

struct TrackersListView: View {
    @ObservedObject var manager: HabitTrackerManager

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        manager.showTrackersList = false
                    }
                }
            VStack(spacing: 0) {
                Text("Мои трекеры")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(manager.trackers) { tracker in
                            HStack {
                                Button {
                                    manager.selectTracker(tracker)
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                        manager.showTrackersList = false
                                    }
                                } label: {
                                    HStack {
                                        Text(tracker.preset.presetName)
                                            .font(.system(size: 40))
                                        Spacer()
///мини таймер только с максимальной единицей
                                        Text(shortTime(for: tracker))
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(14)
                                }
///кнопка удаления
                                Button(role: .destructive) {
                                    manager.deleteTracker(tracker)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white)
                    .shadow(radius: 18, y: 10)
            )
            .padding(40)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

///мини таймер с самой большой единицей

    func shortTime(for tracker: HabitTracker) -> String {
        let s = tracker.totalSeconds
        let days = s / 86400
        let hours = (s % 86400) / 3600
        let minutes = (s % 3600) / 60
        let secs = s % 60
        if days > 0 { return "\(days) д" }
        if hours > 0 { return "\(hours) ч" }
        if minutes > 0 { return "\(minutes) м" }
        return "\(secs) с"
    }
}
