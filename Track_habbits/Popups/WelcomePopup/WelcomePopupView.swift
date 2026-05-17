//
//  WelcomePopupView.swift
//  Track_habbits
//
//  Created by Егор Ерохин on 17/05/2026.
//

import SwiftUI

struct WelcomePopupView: View {

    let onPresetSelected: (WallpaperPreset) -> Void // ContentView передает функцию

    var body: some View {

        VStack(spacing: 20) {

            Text("Что бросаем?")
                .font(.largeTitle)
                .bold()
                .fontDesign(Font.Design.rounded)

            ForEach(
                WallpaperPreset.allPresets,
                id: \.id
            ) { preset in

                Button {

                    onPresetSelected(preset) // Отправка выбранного пресета обратно

                } label: {

                    Text("\(preset.presetName)")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .systemGray4))
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(30)
        .background(.white)
        .cornerRadius(25)
        .padding(40)
    }
}

#Preview
{
    ContentView()
}
