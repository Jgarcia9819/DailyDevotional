import SwiftData
import SwiftUI

struct HomeView: View {
  @AppStorage("customFontSize") var customFontSize: Double = 17
  @AppStorage("customLineSize") var customLineSize: Double = 3
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var colorScheme
  @ObservedObject var homeViewModel = HomeViewModel.shared
  @ObservedObject var bibleService = BibleService.shared
  @FocusState private var isTextEditorFocused: Bool
  @State private var buttonTrigger: Bool = false

  var body: some View {
    NavigationStack {
      List {
        if bibleService.loading {
          Section {
            ProgressView()
              .progressViewStyle(
                CircularProgressViewStyle(
                  tint: colorScheme == .dark ? .white : .blue)
              )
              .frame(maxWidth: .infinity, alignment: .center)
          }
        } else {
          Section {
            if homeViewModel.showingEntireChapter {
              homeViewModel.entireRandomBibleData.reduce(Text("")) { result, verse in
                result
                  + Text("\(verse.verse_start)")
                  .font(
                    .system(
                      size: customFontSize - 5, weight: .light, design: .serif)
                  )
                  .foregroundColor(.secondary).baselineOffset(3)
                  + Text(" \(verse.verse_text) ")
              }
              .textSelection(.enabled)
              .font(.system(size: customFontSize, weight: .regular, design: .serif))
              .lineSpacing(customLineSize)
              .padding(.horizontal, 4)
            } else {
              homeViewModel.randomBibleData.reduce(Text("")) { result, verse in
                result
                  + Text("\(verse.verse_start)")
                  .font(
                    .system(
                      size: customFontSize - 5, weight: .light, design: .serif)
                  )
                  .foregroundColor(.secondary).baselineOffset(3)
                  + Text(" \(verse.verse_text) ")
              }
              .textSelection(.enabled)
              .font(.system(size: customFontSize, weight: .regular, design: .serif))
              .lineSpacing(customLineSize)
              .padding(.horizontal, 4)
            }
            Button("Show Full Chapter") {
              homeViewModel.showingEntireChapter.toggle()
              print(homeViewModel.entireRandomBibleData)
            }.tint(.gray)
              .buttonStyle(.bordered)
              .cornerRadius(12)
              .frame(height: 30)
              .frame(maxWidth: .infinity, alignment: .center)
              .font(.system(size: 13, weight: .regular, design: .serif))
          }
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(PlainListStyle())
      .refreshable {
        if !homeViewModel.entryText.isEmpty {
          homeViewModel.isRefreshing = true
          return
        }
        await performRefresh()
      }
      .alert(
        "There is an unsaved reflection, would you like to save?",
        isPresented: $homeViewModel.isRefreshing
      ) {
        Button("Save") {
          saveEntry(homeViewModel: homeViewModel, modelContext: modelContext, dismiss: dismiss)
          homeViewModel.isRefreshing = false
          Task {
            await performRefresh()
          }
        }
        Button("Discard", role: .destructive) {
          homeViewModel.isRefreshing = false
          Task {
            await performRefresh()
          }
        }
      }
      .sheet(isPresented: $homeViewModel.showingEntrySheet) {
        EntrySheetView()
          .presentationDetents([.medium, .large])
          .presentationDragIndicator(.visible)
      }
      .sheet(isPresented: $homeViewModel.showingFontEditSheet) {
        FontSettingsView()
          .presentationDetents([.height(200)])
          .presentationDragIndicator(.visible)
      }
      .navigationTitle(
        homeViewModel.showingEntireChapter
          ? "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0)"
          : "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
      )
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          NavigationLink(destination: ArchiveView()) {
            Image(systemName: "archivebox")
          }
          .tint(colorScheme == .dark ? .white : .black)
          Button("", systemImage: "textformat.size") {
            homeViewModel.showingFontEditSheet = true
          }
          .tint(colorScheme == .dark ? .white : .black)
          Button("", systemImage: homeViewModel.isPassageSaved ? "bookmark.fill" : "bookmark") {
            if homeViewModel.isPassageSaved {
              deleteSavedPassage(modelContext: modelContext)
            } else {
              savePassage(
                homeViewModel: homeViewModel, modelContext: modelContext, dismiss: dismiss)
            }
            homeViewModel.isPassageSaved.toggle()
            buttonTrigger.toggle()
          }
          .sensoryFeedback(
            .success,
            trigger: buttonTrigger
          )
          .tint(colorScheme == .dark ? .white : .black)
          Spacer()
          Button(action: {
            homeViewModel.showingEntrySheet = true
          }) {
            Image(systemName: "square.and.pencil")
          }
          .tint(colorScheme == .dark ? .white : .black)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            NavigationLink(destination: SettingsView()) {
              Label("Settings", systemImage: "gearshape")
                .tint(colorScheme == .dark ? .white : .black)
            }
          } label: {
            Image(systemName: "ellipsis.circle")
          }
          .tint(colorScheme == .dark ? .white : .black)
        }
      }
    }
  }

  //because swiftdata does not play nice with MVVM architecture, we place crud functionality in the views
  func saveEntry(homeViewModel: HomeViewModel, modelContext: ModelContext, dismiss: DismissAction) {
    homeViewModel.saved = true
    guard let devotional = homeViewModel.randomDevotional else {
      return
    }

    let entry = Entry(
      id: UUID(),  // Generate a new UUID for the entry
      devoID: devotional.id,
      createdAt: Date(),
      content: homeViewModel.entryText,
      saved: true,
      book: devotional.book,
      chapter: devotional.chapter,
      start: devotional.start,
      end: devotional.end)
    print(devotional.book, devotional.chapter)

    modelContext.insert(entry)
    do {

      try modelContext.save()
      print("Entry saved successfully")
      homeViewModel.entryText = ""
    } catch {
      print("Error saving entry: \(error)")
    }
    dismiss()
  }

  func savePassage(homeViewModel: HomeViewModel, modelContext: ModelContext, dismiss: DismissAction)
  {
    guard let devotional = homeViewModel.randomDevotional else {
      return
    }

    let saved = Saved(
      id: UUID(),  // Generate a new UUID for the entry
      devoID: devotional.id,
      book: devotional.book,
      chapter: devotional.chapter,
      start: devotional.start,
      end: devotional.end,
      createdAt: Date()
    )
    homeViewModel.savedPassage = saved

    modelContext.insert(saved)
    do {

      try modelContext.save()
      print("Passage saved successfully")
    } catch {
      print("Error saving passage: \(error)")
    }
    dismiss()
  }

  func deleteSavedPassage(modelContext: ModelContext) {
    if let savedPassage = homeViewModel.savedPassage {
      modelContext.delete(savedPassage)
    }
    do {
      try modelContext.save()
    } catch {
      print("Error deleting passage: \(error)")
    }
  }

  func performRefresh() async {
    homeViewModel.saved = false
    homeViewModel.entryText = ""
    homeViewModel.isPassageSaved = false
    homeViewModel.savedPassage = nil
    homeViewModel.showingEntireChapter = false
    await homeViewModel.fetchRandomDevotional()
    await homeViewModel.fetchRandomBibleData()
  }

}
