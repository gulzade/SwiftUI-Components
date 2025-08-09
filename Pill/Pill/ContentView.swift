import SwiftUI

struct ContentView: View {
    // Tracks currently selected pill
    @State private var selected: String? = "All Accessories"

    // Returns badge count for a given pill title
    private func pillCount(for title: String) -> Int? {
        switch title {
        case "MagSafe": return 12
        case "AirPods": return 4
        default: return nil
        }
    }
    
    // Custom label view with optional badge
    struct PillLabel: View {
        let title: String
        let count: Int?
    
        var body: some View {
            HStack(spacing: 6) {
                Text(title)
                if let c = count, c > 0 {
                    Text("\(c)")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.ultraThinMaterial))
                }
            }
        }
    }
    
    // List of pill titles
    private let pillItems: [String] = [
        "All Accessories", "MagSafe", "Apple Watch Bands", "iPhone", "iPad", "Mac", "AirPods", "Apple TV", "AirTag"
    ]
    
    // Returns SF Symbol name for given pill title
    private func symbolName(for title: String) -> String {
        switch title {
        case "All Accessories": return "square.grid.2x2"
        case "MagSafe": return "bolt.circle"
        case "Apple Watch Bands": return "applewatch"
        case "iPhone": return "iphone"
        case "iPad": return "ipad"
        case "Mac": return "laptopcomputer"
        case "AirPods": return "airpodspro"
        case "Apple TV": return "appletv.fill"
        case "AirTag": return "tag"
        default: return "square.grid.2x2"
        }
    }
    // Triggers haptic feedback and executes action
    func pillTap(_ action: () -> Void) {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        action()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title text
            Text("Accessories")
                .font(.largeTitle.weight(.bold))
                .padding(.bottom,4)
                .padding(.top,20)

            // Scroll view containing horizontal list of pill buttons
            ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 12) {
                    ForEach(pillItems, id: \.self) { title in
                        Button(action: {
                            pillTap {
                                    selected = title
                                } //update selected
                            print("Tapped: \(title)")
                        }){
                            HStack {
                                Image(systemName: symbolName(for: title))
                                    .imageScale(.medium)
                                PillLabel(title: title, count: pillCount(for: title))
                            }
                        }
                        .buttonStyle(PillButtons(isSelected: selected == title))
                        .contextMenu {
                            Button("Add to favorites", systemImage: "star") { /* ... */ }
                            Button("Share", systemImage: "square.and.arrow.up") { /* ... */ }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,4)
            }
            
            // Spacer to push content to top
          Spacer()
        }
        // Horizontal padding and background color
        .padding(.horizontal)
        .background(Color(uiColor: .systemGroupedBackground))
      }
    
    
    }


// Custom button style for pill appearance
struct PillButtons:ButtonStyle {
    var isSelected: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        // Apple Store like pill style
        configuration.label
            // Font style for pill text
            .font(.body.weight(.semibold))
            // Vertical and horizontal padding for pill size
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            // Background capsule with adaptive color for light/dark mode
            .background(
                Capsule().fill(
                    Color(UIColor { trait in
                        trait.userInterfaceStyle == .dark ? .secondarySystemBackground : .white
                    })
                )
            )
            // Capsule stroke with opacity depending on selection state
            .overlay(
                Capsule().stroke(
                    Color.black.opacity(isSelected ? 0.15 : 0.06),
                    lineWidth: 0.5
                )
            )
            // Foreground color adapts to light/dark mode and selection state
            .foregroundStyle(
                Color(UIColor { trait in
                    if trait.userInterfaceStyle == .dark {
                        return isSelected ? .label : .secondaryLabel
                    } else {
                        return isSelected ? .black : UIColor.label.withAlphaComponent(0.45)
                    }
                })
            )
            // Shadow with different opacity and radius based on pressed and selected states
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.12 : (isSelected ? 0.16 : 0.08)),
                    radius: isSelected ? 12 : 8, x: 0, y: isSelected ? 5 : 2)
            // Scale effect for pressed state to provide tap feedback
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            // Spring animation for smooth scaling
            .animation(.spring(response: 0.22, dampingFraction: 0.9), value: configuration.isPressed)
    }
}
#Preview {
    ContentView()
}
