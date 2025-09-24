import SwiftData
import SwiftUI
import StoreKit

struct HomeView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("fontSize") private var fontSize: Double = 24
    @AppStorage("lineHeight") private var lineHeight: Double = 4
    @AppStorage("lineSpacing") private var lineSpacing: Double = 8
    @AppStorage("fontFamily") private var fontFamily: FontFamily = .serif
    @AppStorage("refreshCount") private var refreshCount: Int = 0
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var homeViewModel = HomeViewModel.shared
    @ObservedObject var bibleService = BibleService.shared
    @ObservedObject var bibleAudioService = BibleAudioService.shared
    @FocusState private var isTextEditorFocused: Bool
    @State private var buttonTrigger: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if homeViewModel.isRefreshing || bibleService.loading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else {
                    LazyVStack(alignment: .leading) {
                      if !homeViewModel.showingEntireChapter {
                        ForEach(homeViewModel.randomBibleData, id: \.id) { verse in
                            Text("\(verse.verse_start)")
                                .font(
                                    .system(
                                        size: fontSize - 5, weight: .light, design: fontFamily.fontDesign)
                                )
                                .foregroundColor(.secondary).baselineOffset(3)
                            + Text(" \(verse.verse_text) ")
                        }
                        .textSelection(.enabled)
                        .font(.system(size: fontSize, weight: .regular, design: fontFamily.fontDesign))
                        .lineSpacing(lineHeight)
                        .padding(.vertical, lineSpacing)
                        .padding(.horizontal, 16)
                      } else {
                        ForEach(homeViewModel.entireRandomBibleData, id: \.id) { verse in
                            Text("\(verse.verse_start)")
                                .font(
                                    .system(
                                        size: fontSize - 5, weight: .light, design: fontFamily.fontDesign)
                                )
                                .foregroundColor(.secondary).baselineOffset(3)
                            + Text(" \(verse.verse_text) ")
                        }
                        .textSelection(.enabled)
                        .font(.system(size: fontSize, weight: .regular, design: fontFamily.fontDesign))
                        .lineSpacing(lineHeight)
                        .padding(.vertical, lineSpacing)
                        .padding(.horizontal, 16)
                      }
                    }
                    .padding(.vertical, 12)
                    
                    Button("Show Full Chapter") {
                        homeViewModel.showingEntireChapter.toggle()
                    }
                    .tint(.gray)
                    .buttonStyle(.bordered)
                    .cornerRadius(8)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 13, weight: .regular, design: fontFamily.fontDesign))
                }
            }
                .refreshable {
        refreshCount += 1
        if refreshCount >= 3 {
          requestReview()
        }
        if !homeViewModel.entryText.isEmpty {
          homeViewModel.isRefreshing = true
          return
        }
        bibleAudioService.resetAudio()
        
        await Task {
          await performRefresh()
        }.value
      }
      .alert(
        "There is an unsaved reflection, would you like to save?",
        isPresented: $homeViewModel.isRefreshing
      ) {
        Button("Save") {
          saveEntry(homeViewModel: homeViewModel, modelContext: modelContext, dismiss: dismiss)
          homeViewModel.isRefreshing = false
          Task {
            // Reset audio state here too
            bibleAudioService.resetAudio()
            await performRefresh()
          }
        }
        Button("Discard", role: .destructive) {
          homeViewModel.isRefreshing = false
          Task {
            // Reset audio state here too
            bibleAudioService.resetAudio()
            await performRefresh()
          }
        }
      }
            
             
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                    }) {
                        Text(
                            homeViewModel.randomDevotional?.end == nil
                            ? "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)"
                            : homeViewModel.showingEntireChapter
                            ? "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0)"
                            : "\(homeViewModel.randomDevotional?.book ?? "") \(homeViewModel.randomDevotional?.chapter ?? 0):\(homeViewModel.randomDevotional?.start ?? 0)-\(homeViewModel.randomDevotional?.end ?? 0)"
                        )
                        .font(.system(size: 20, weight: .regular, design: fontFamily.fontDesign))
                        .tint(colorScheme == .dark ? .white : .black)
                    }
                    .allowsHitTesting(false)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        
                        Menu {
                            NavigationLink(destination: SettingsView()) {
                                Label("Settings", systemImage: "gearshape")
                                    .tint(colorScheme == .dark ? .white : .black)
                            }
                            
                            Button("Font Settings", systemImage: "textformat.size") {
                                homeViewModel.showingFontEditSheet = true
                            }
                            .tint(colorScheme == .dark ? .white : .black)
                            
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .tint(colorScheme == .dark ? .white : .black)
                        
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    
                        NavigationLink(destination: ArchiveView()) {
                            Image(systemName: "archivebox")
                                
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                        }
                        .tint(colorScheme == .dark ? .white : .black)
                        
                        
                        Button("", systemImage: homeViewModel.isPassageSaved ? "bookmark.fill" : "bookmark")
                        {
                            if homeViewModel.isPassageSaved {
                                deleteSavedPassage(modelContext: modelContext)
                            } else {
                                savePassage(
                                    homeViewModel: homeViewModel, modelContext: modelContext, dismiss: dismiss)
                            }
                            homeViewModel.isPassageSaved.toggle()
                            buttonTrigger.toggle()
                        }
                        
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        .sensoryFeedback(
                            .success,
                            trigger: buttonTrigger
                        )
                        .tint(colorScheme == .dark ? .white : .black)
                        Button(
                            "",
                            systemImage: bibleAudioService.isAudioLoading
                            ? "arrow.2.circlepath"
                            : (bibleAudioService.isAudioPlaying ? "pause.fill" : "play.fill")
                        ) {
                            Task {
                                if bibleAudioService.isAudioPlaying {
                                    bibleAudioService.pauseAudio()
                                } else if bibleAudioService.isAudioPaused {
                                    bibleAudioService.playAudio()
                                } else {
                                    await bibleAudioService.setupAudioPlayer(
                                        book: homeViewModel.randomDevotional?.abbreviation ?? "",
                                        chapter: homeViewModel.randomDevotional?.chapter ?? 0,
                                        verseStart: homeViewModel.randomDevotional?.start ?? 1,
                                        verseEnd: homeViewModel.randomDevotional?.end)
                                    bibleAudioService.isAudioPlaying = true
                                }
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .tint(colorScheme == .dark ? .white : .black)
                        .disabled(bibleAudioService.isAudioLoading)
                    
                    
                    Spacer()
                   
                        Button(action: {
                            homeViewModel.showingEntrySheet = true
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(colorScheme == .dark ? .white : .black)
                    
                  
                }
            }
            
        
            .onAppear {
                checkIfPassageIsSaved(modelContext: modelContext)
            }
         }
         .sheet(isPresented: $homeViewModel.showingEntrySheet) {
             EntrySheetView()
                 .presentationDetents([.medium, .large])
                 .presentationDragIndicator(.visible)
         }
         .sheet(isPresented: $homeViewModel.showingFontEditSheet) {
             FontSettingsView()
                 .presentationDetents([.height(400)])
                 .presentationDragIndicator(.visible)
         }
         .sheet(isPresented: $homeViewModel.showingInfoSheet) {
             InfoView()
                 .presentationDetents([.medium, .large])
                 .presentationDragIndicator(.visible)
         }
     }
     
     //because swiftdata does not play nice with MVVM architecture, we place crud functionality in the views
     func saveEntry(homeViewModel: HomeViewModel, modelContext: ModelContext, dismiss: DismissAction) {
         homeViewModel.saved = true
         guard let devotional = homeViewModel.randomDevotional else {
             return
         }
         guard let start = devotional.start, let end = devotional.end else {
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
             start: start,
             end: end)
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
         guard let start = devotional.start, let end = devotional.end else {
             return
         }
         let saved = Saved(
             id: UUID(),  // Generate a new UUID for the entry
             devoID: devotional.id,
             book: devotional.book,
             chapter: devotional.chapter,
             start: start,
             end: end,
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
     
    @MainActor
    func performRefresh() async {
        homeViewModel.saved = false
        homeViewModel.entryText = ""
        homeViewModel.isPassageSaved = false
        homeViewModel.savedPassage = nil
        homeViewModel.showingEntireChapter = false
        homeViewModel.randomBibleData = []
        
        bibleAudioService.resetAudio()
        
        await homeViewModel.fetchRandomDevotional()
        await homeViewModel.fetchRandomBibleData()
        
        checkIfPassageIsSaved(modelContext: modelContext)
    }
     
     func checkIfPassageIsSaved(modelContext: ModelContext) {
         guard let devotional = homeViewModel.randomDevotional else {
             homeViewModel.isPassageSaved = false
             return
         }
         
         let devotionalId = devotional.id
         let predicate = #Predicate<Saved> { savedPassage in
             savedPassage.devoID == devotionalId
         }
         
         let descriptor = FetchDescriptor<Saved>(predicate: predicate)
         
         do {
             let savedPassages = try modelContext.fetch(descriptor)
             if let matchedPassage = savedPassages.first {
                 homeViewModel.isPassageSaved = true
                 homeViewModel.savedPassage = matchedPassage
             } else {
                 homeViewModel.isPassageSaved = false
                 homeViewModel.savedPassage = nil
             }
         } catch {
             print("Error fetching saved passages: \(error)")
             homeViewModel.isPassageSaved = false
             homeViewModel.savedPassage = nil
         }
     }
}

