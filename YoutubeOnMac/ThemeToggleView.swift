import SwiftUI

struct ThemeToggleView: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        HStack(spacing: 6) {
            
            Image(systemName: "moon.fill")
                .foregroundColor(isDarkMode ? .blue : .gray)

            Toggle("", isOn: Binding(
                // to invert the toggle logic (off = left)
                get: { !isDarkMode },
                set: { isDarkMode = !$0 }
            ))
            .toggleStyle(
                SwitchToggleStyle(
                    tint: isDarkMode ? .gray : .teal
                )
            )
            .labelsHidden()
            .frame(width: 40)
            .scaleEffect(0.8)

            Image(systemName: "sun.max.fill")
                .foregroundColor(isDarkMode ? .gray : .yellow)
        }
        .padding(.horizontal, 8)
    }
}


#Preview {
    ThemeToggleView(isDarkMode: Binding<Bool>.constant(true))
}
