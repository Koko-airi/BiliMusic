import SwiftUI

/// Feature 5 & Bug 4: Interactive Scrubber with strictly clamped bounds to prevent overflow
public struct ScrubberBar: View {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void
    
    @State private var isDragging: Bool = false
    @State private var dragTime: TimeInterval = 0
    
    public init(
        currentTime: TimeInterval,
        duration: TimeInterval,
        onSeek: @escaping (TimeInterval) -> Void
    ) {
        self.currentTime = currentTime
        self.duration = duration
        self.onSeek = onSeek
    }
    
    private var displayTime: TimeInterval {
        isDragging ? dragTime : currentTime
    }
    
    /// Bug 4: Progress ratio clamped strictly between 0 and 1
    private var progressRatio: Double {
        guard duration > 0, !duration.isNaN else { return 0.0 }
        let rawRatio = displayTime / duration
        return min(max(rawRatio, 0.0), 1.0)
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                let totalWidth = geo.size.width
                // Bug 4: Strictly clamp active track width within [0, totalWidth]
                let activeTrackWidth = min(max(totalWidth * CGFloat(progressRatio), 0), totalWidth)
                let thumbSize: CGFloat = isDragging ? 18 : 12
                let maxOffset = max(0, totalWidth - thumbSize)
                let thumbOffset = min(max((totalWidth * CGFloat(progressRatio)) - (thumbSize / 2), 0), maxOffset)
                
                ZStack(alignment: .leading) {
                    // Track background
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: isDragging ? 7 : 4)
                    
                    // Filled progress - guaranteed not to overflow totalWidth
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.pink, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: activeTrackWidth, height: isDragging ? 7 : 4)
                    
                    // Scrubber thumb - strictly clamped within [0, totalWidth - thumbSize]
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: thumbOffset)
                }
                .clipped()
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard totalWidth > 0 else { return }
                            isDragging = true
                            let percent = min(max(value.location.x / totalWidth, 0.0), 1.0)
                            dragTime = percent * max(0, duration)
                        }
                        .onEnded { value in
                            guard totalWidth > 0 else { return }
                            let percent = min(max(value.location.x / totalWidth, 0.0), 1.0)
                            let targetTime = percent * max(0, duration)
                            onSeek(targetTime)
                            isDragging = false
                        }
                )
            }
            .frame(height: 20)
            
            // Time Labels
            HStack {
                Text(formatTime(displayTime))
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                let remaining = max(0, duration - displayTime)
                Text("-" + formatTime(remaining))
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        guard !time.isNaN && time >= 0 else { return "00:00" }
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
