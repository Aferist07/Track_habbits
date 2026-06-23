import SwiftUI

struct WelcomePopupView: View
{
    let usedPresets: [WallpaperPreset]
    let onPresetSelected: (WallpaperPreset) -> Void
    let onCancel: () -> Void
    var body: some View
    {
        VStack(spacing: 20)
        {
            Text("Что бросаем/начинаем?")
                .font(.largeTitle)
                .bold()
                .fontDesign(.rounded)
            ForEach(WallpaperPreset.allPresets, id: \.presetName)
            {
                preset in
                ///уже выбранные привычки отключаются
                let isUsed = usedPresets.contains
                {
                    $0.presetName == preset.presetName
                }
                Button
                {
                    if !isUsed
                    {
                        onPresetSelected(preset)
                    }
                }
            label:
                {
                    Text("\(preset.presetName)")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isUsed ? Color.gray.opacity(0.2) : Color(uiColor: .systemGray4))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .disabled(isUsed)
            }
            Button("Отмена")
            { onCancel()
            }
            .foregroundColor(.secondary)
        }
        .padding(30)
        .background(.white)
        .cornerRadius(25)
        .padding(40)
        .shadow(radius: 24)
    }
}



#Preview {
    ContentView()
}
