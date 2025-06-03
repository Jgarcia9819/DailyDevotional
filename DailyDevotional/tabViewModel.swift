import SwiftUI

final class TabViewModel: ObservableObject {
    @Published var selectedTab: Int = 0;
    
    func selectTab(_ tab: Int) {
        selectedTab = tab
    }
    
    func isSelected(_ tab: Int) -> Bool {
        return selectedTab == tab
    }
}