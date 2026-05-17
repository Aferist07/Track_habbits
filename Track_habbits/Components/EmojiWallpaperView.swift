//
//  EmojiWallpaperView.swift
//  Track_habbits
//
//  Created by Егор Ерохин on 16/05/2026.
//

import SwiftUI

struct EmojiWallpaperView: View {

    let preset: WallpaperPreset

    var body: some View {

        GeometryReader { geo in

            ZStack {

                LinearGradient(
                    colors: preset.colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ForEach(
                    0..<preset.emojiCount,
                    id: \.self
                ) { _ in

                    Text(
                        preset.emojis.randomElement()!
                    )
                    .font(
                        .system(
                            size: CGFloat.random(
                                in: 25...30
                            )
                        )
                    )
                    .rotationEffect(
                        .degrees(
                            Double.random(in: -10...10)
                        )
                    )
                    .opacity(
                        Double.random(in: 0.1...1)
                    )
                    .position(
                        x: CGFloat.random(
                            in: 0...geo.size.width
                        ),
                        y: CGFloat.random(
                            in: 0...geo.size.height
                        )
                    )
                }
            }
        }
    }
}
