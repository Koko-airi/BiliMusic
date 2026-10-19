import SwiftUI

/// Feature 5: Interactive Scrubber with live drag feedback and time formatters
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
        onSeek = onSeek
        self.onSeek = onSeek
    }
    
    private var displayTime: TimeInterval {
        isDragging ? dragTime : currentTime
    }
    
    private var progress: Double {
        guard duration > 0 else { return 0 }
        return min(1.0, max(0.0, displayTime / duration))
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track background
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: isDragging ? 7 : 4)
                    
                    // Filled progress
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.pink, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geo.size.width * CGFloat(progress)), height: isDragging ? 7 : 4)
                    
                    // Scrubber thumb
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                        .frame(width: isDragging ? 18 : 12, height: isDragging ? 18 : 12)
                        .offset(x: max(0, min(geo.size.width - (isDragging ? 18 : 12), (geo.size.width * CGFloat(progress)) - (isDragging ? 9 : 6))))
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let percent = max(0, min(1, value.location.x / geo.size.width))
                            dragTime = percent * duration
                        }
                        .onEnded { value in
                            let percent = max(0, min(1, value.location.x / geo.size.width))
                            let targetTime = percent * duration
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
                
                Text("-" + formatTime(max(0, duration - displayTime)))
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        guard !time.isNaN && time >= 0 else { return "0:00" }
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}
