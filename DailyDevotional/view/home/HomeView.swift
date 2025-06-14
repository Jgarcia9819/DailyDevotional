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
  @State private var showingFontEditSheet: Bool = false
  @State private var showingTextEditor: Bool = false
  @State private var isPassageSaved: Bool = false
  @State private var savedPassage: Saved?
  @State private var showingEntireChapter: Bool = false
  @State private var showingEntrySheet: Bool = false

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
            if showingEntireChapter {
              homeViewModel.entireRandomBibleData.reduce(Text("")) { result, verse in
                result
                  + Text("\(verse.verse_start)")
                  .font(
                    .system(
                      size: customFontSize - 4, weight: .light, design: .serif)
                  )
                  .foregroundColor(.secondary).baselineOffset(3)
                  + Text(" \(verse.verse_text) ")
              }
              .textSelection(.enabled)
              .font(.system(size: customFontSize, weight: .regular, design: .serif))
              .lineSpacing(customLineSize)
            } else {
              homeViewModel.randomBibleData.reduce(Text("")) { result, verse in
                result
                  + Text("\(verse.verse_start)")
                  .font(
                    .system(
                      size: customFontSize - 4, weight: .light, design: .serif)
                  )
                  .foregroundColor(.secondary).baselineOffset(3)
                  + Text(" \(verse.verse_text) ")
              }
              .textSelection(.enabled)
              .font(.system(size: customFontSize, weight: .regular, design: .serif))
              .lineSpacing(customLineSize)
            }
            Button("Show Full Chapter") {
              showingEntireChapter.toggle()
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
      .sheet(isPresented: $showingEntrySheet) {
        EntrySheetView()
          .presentationDetents([.medium, .large])
          .presentationDragIndicator(.visible)
      }
      .sheet(isPresented: $showingFontEditSheet) {
        FontSettingsView()
          .presentationDetents([.height(200)])
          .presentationDragIndicator(.visible)
      }

      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          NavigationLink(destination: ArchiveView()) {
            Image(systemName: "archivebox")
          }
          .tint(colorScheme == .dark ? .white : .black)
          Button("", systemImage: "textformat.size") {
            showingFontEditSheet = true
          }
          .tint(colorScheme == .dark ? .white : .black)
          Button("", systemImage: isPassageSaved ? "bookmark.fill" : "bookmark") {
            if isPassageSaved {
              deleteSavedPassage(modelContext: modelContext)
            } else {
              savePassage(
                homeViewModel: homeViewModel, modelContext: modelContext, dismiss: dismiss)
            }
            isPassageSaved.toggle()
            buttonTrigger.toggle()
          }
          .sensoryFeedback(
            .success,
            trigger: buttonTrigger
          )
          .tint(colorScheme == .dark ? .white : .black)
          Spacer()
          Button(action: {
            showingEntrySheet = true
          }) {
            Image(systemName: "square.and.pencil")
          }
          .tint(colorScheme == .dark ? .white : .black)
        }
        ToolbarItem(placement: .navigationBarLeading) {
          if showingEntireChapter {
            Text(
              "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0)"
            )
            .font(.system(size: 18, weight: .regular, design: .serif))
          } else {
            Text(
              "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
            )
            .font(.system(size: 18, weight: .regular, design: .serif))
          }
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
      .refreshable {
        homeViewModel.saved = false
        homeViewModel.entryText = ""
        isPassageSaved = false
        savedPassage = nil
        showingEntireChapter = false
        await homeViewModel.fetchRandomDevotional()
        await homeViewModel.fetchRandomBibleData()
      }
    }

  }

  //because swiftdata does not play nice with MVVM architecture, we place crud functionality in the views
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
    savedPassage = saved

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
    if let savedPassage = savedPassage {
      modelContext.delete(savedPassage)
    }
    do {
      try modelContext.save()
    } catch {
      print("Error deleting passage: \(error)")
    }
  }

}
