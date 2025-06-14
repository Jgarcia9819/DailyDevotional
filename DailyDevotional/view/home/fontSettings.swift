import SwiftUI

struct FontSettingsView: View {
  @AppStorage("customFontSize") var customFontSize: Double = 17
  @AppStorage("customLineSize") var customLineSize: Double = 3

  var body: some View {
    VStack {
      HStack {
        Text("Front Size")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)
        Spacer()
        HStack {
          Button(action:{
            if customFontSize >= 1 {
              customFontSize = customFontSize - 3
            }
          }){
            Image(systemName: "minus")
          .frame(width: 20, height: 20)
          }
          .buttonStyle(.bordered)
          .foregroundStyle(.black)
          .padding(.horizontal, 16)
  
          Button(action:{
            if customFontSize <= 36 {
              customFontSize = customFontSize + 3
            }
          }){
            Image(systemName: "plus")
          .frame(width: 20, height: 20)
          }
          .buttonStyle(.bordered)
          .foregroundStyle(.black)
          .padding(.horizontal, 16)
        }
      }
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
      .padding(.bottom, 16)
      .frame(height: 50)
      HStack {
        Text("Line Height")
          .font(.system(size: 16, weight: .regular, design: .serif))
          .padding(.leading, 16)
        Spacer()
        HStack {
          Button(action:{
            if customLineSize >= 1 {
              customLineSize = customLineSize - 1
            }
          }){
            Image(systemName: "minus")
          .frame(width: 20, height: 20)
          }
          .buttonStyle(.bordered)
          .foregroundStyle(.black)
          .padding(.horizontal, 16)

          Button(action:{
            if customLineSize <= 8 {
              customLineSize = customLineSize + 1
            }
          }){
            Image(systemName: "plus")
          .frame(width: 20, height: 20)
          }
          .buttonStyle(.bordered)
          .foregroundStyle(.black)
          .padding(.horizontal, 16)
        }
      }
      .background(Color.gray.opacity(0.1))
      .cornerRadius(12)
      .padding(.bottom, 16)
      .frame(height: 50)
    }
  }
}
