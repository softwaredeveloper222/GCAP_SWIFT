//
//  component.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import SwiftUI
import AVKit
import PDFKit

struct DualAlignedTextField: View {
    @Binding var checkValue: Int
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.trailing, 4)
                    .font(.system(size: 12))
            }
            
            TextField("", text: $text)
                .keyboardType(.decimalPad)
                .onChange(of: $text.wrappedValue) { newValue in
                    var filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "-" }
                    
                    if filtered.contains("-") && !filtered.hasPrefix("-") {
                        filtered = filtered.replacingOccurrences(of: "-", with: "")
                    }
                    
                    let parts = filtered.split(separator: ".")
                    if parts.count > 2 {
                        filtered = parts[0] + "." + parts[1]
                    }
                    
                    if filtered != newValue {
                        $text.wrappedValue = filtered
                    }
                }
                .multilineTextAlignment(.leading)
                .font(.system(size: 12))
                .onSubmit {
                    checkValue = Int(arc4random())
                }
                .foregroundStyle(Color.black)
        }
    }
}

struct IconTextField: View {
    @Binding var text: String
    let icon: String
    var placeholder: String
    
    @State private var lineWidth_size: Double = 1
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(icon)
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 14, height: 14)
                TextField(placeholder, text: $text)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                    .focused($isFocused)
            }
            .padding(10)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.blue : Color(hex: "#F3F3F3"), lineWidth: lineWidth_size) // 👈 Blue when focused
        )
        .onAppear{
            if isFocused == true {
                lineWidth_size = 1
            }
            else{
                lineWidth_size = 0.3
            }
        }
    }
}

struct IconTextEditor: View {
    @Binding var text: String
    let icon: String
    var placeholder: String
    
    @State private var lineWidth_size: Double = 1
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $text)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGray6))
                        .focused($isFocused)
                        .font(.system(size: 12))
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.cyan : Color(hex: "#F3F3F3"), lineWidth: lineWidth_size) // 👈 Blue when focused
        )
        .onAppear{
            if isFocused == true {
                lineWidth_size = 1
            }
            else{
                lineWidth_size = 0.3
            }
        }
    }
}

struct CustomTextEditor: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(icon)
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 14, height: 14)
                .padding(.top, 12)
                .padding(.leading, 2)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                        .padding(.leading, 2)
                        .font(.system(size: 12))
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $text)
                    .padding(.top, 4)
                    .frame(minHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
//                    .foregroundStyle(Color.black)
                    .focused($isFocused)
                    .font(.system(size: 12))
            }
        }
        .padding(8)
        .background(Color(hex: "#F9F9F9"))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.cyan : Color(hex: "#F3F3F3"), lineWidth: isFocused ? 1 : 0.3)
        )
        .animation(.easeInOut, value: isFocused)
    }
}

//MARK: FullscreenImageView
struct FullScreenImageGalleryView: View {
    let imageUrls: [String]
    @Binding var currentIndex: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 {
                        isPresented = false
                    }
                }
        )
    }
}


//MARK: This is Animations List Item
struct AnimationsCardItem: View {
    let imageUrls: String
    let imageText: String
    let popup_url: String
    
    @Binding var show_popup_image: Bool
    @Binding var popup_image_url: String
    
    var body: some View{
        GeometryReader{ geo in
            VStack{
                VideoThumbnailView(videoURL: URL(string: IMAGE_URL + imageUrls)!)
                    .frame(width: geo.size.width - 14, height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                    .padding(6)
                
                HStack(spacing: 4){
                    Image("video_play_icon")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .padding(.top, 8)
                    
                    Text(imageText)
                        .font(.system(size: 10))
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .frame(height: 60)
            }
            .background(Color(hex: "#F3F3F3"))
            .frame(width: geo.size.width, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
            .cornerRadius(8)
            .shadow(radius: 5)
            .onTapGesture {
                video_url = popup_url
                show_popup_image = true
            }
        }
    }
}

struct VideoThumbnailView: View {
    let videoURL: URL
    @State private var thumbnailImage: UIImage? = nil
    
    var body: some View {
        if let thumbnailImage = thumbnailImage {
            Image(uiImage: thumbnailImage)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100, alignment: .center)
                .cornerRadius(8)
                .shadow(radius: 4)
        } else {
            ProgressView("")
                .task {
                    await generateThumbnail()
                }
        }
    }
    
    // MARK: - Generate Thumbnail from Video
    func generateThumbnail() async {
        print(videoURL)
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 800, height: 600)
        
        do {
            let cgImage = try await generator.image(at: .zero).image
            DispatchQueue.main.async {
                self.thumbnailImage = UIImage(cgImage: cgImage)
            }
        } catch {
            print(videoURL)
            print("❌ Failed to generate thumbnail:", error)
        }
    }
}

struct FullscreenVideoPlayer: View {
    @Environment(\.dismiss) private var dismiss
    let videoURL: URL
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VideoPlayer(player: AVPlayer(url: videoURL))
                .edgesIgnoringSafeArea(.all)
            
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
}

//MARK: This is Charts/Graphs List item
struct ChartsListItem: View {
    let imageUrls: String
    let imageText: String
    let popup_url: String
    @Binding var show_popup_image: Bool
    @Binding var popup_image_url: String
    
    @State private var fileType: Int? = nil
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if let fileType = fileType {
                    if fileType == 0 {
                        AsyncImage(url: URL(string: IMAGE_URL + imageUrls)) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: geo.size.width - 14, height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(6)
                        } placeholder: {
                            ProgressView()
                                .frame(width: geo.size.width - 14, height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                        }
                        
                    } else if fileType == 1 {
                        PDFPreviewView(pdfURL: URL(string: IMAGE_URL + imageUrls) ?? URL(filePath: ""))
                            .frame(width: geo.size.width - 14, height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                            .padding(6)
                    }
                } else {
                    ProgressView()
                        .frame(width: geo.size.width - 14, height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                        .padding(6)
                }
                
                Text(imageText)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
            }
            .frame(width: geo.size.width, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
            .background(Color(hex: "#F3F3F3"))
            .cornerRadius(8)
            .shadow(radius: 5)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    popup_image_url = popup_url
                    show_popup_image = true
                }
            }
            
        }
        .task {
            await detectFileType()
        }
    }
    
    func detectFileType() async {
        do {
            let type: Int
            guard let url = URL(string: IMAGE_URL + imageUrls) else {
                type = 2
                return
            }
            
            let (_, response) = try await URLSession.shared.data(from: url)
            if let mimeType = response.mimeType {
                if mimeType == "application/pdf" {
                    type = 1
                } else if mimeType.starts(with: "image/") {
                    type = 0
                } else {
                    type = 2
                }
            } else {
                type = 2
            }
            
            await MainActor.run { fileType = type }
        } catch {
            fileType = 2
        }
    }
}


//MARK: This is Valve Positions List Item
struct ImageListItem: View {
    let imageUrls: String
    let imageText: String
    let popup_url: String
    @Binding var show_popup_image: Bool
    @Binding var popup_image_url: String
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                ZStack {
                    AsyncImage(url: URL(string: IMAGE_URL + imageUrls)) { image in
                        image.resizable()
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 140)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 140)
                    }
                    
                    LinearGradient(
                        colors: [Color(hex: "#2E2E93").opacity(0.8), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    withAnimation{
                        show_popup_image = true
                        
                        popup_image_url = popup_url
                    }
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Text("▐")
                            .foregroundColor(Color(hex: "#90CFF2"))
                        
                        Text(imageText)
                            .font(.system(size: 14, weight: .semibold))
                        
                        Spacer()
                        
                        Image("arrow")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 4)
                    .padding(.trailing, 10)
                    .foregroundColor(Color.white)
                }
                .padding(.bottom, 4)
            }
        }
        .frame(height: 140)
    }
}

//MARK: this is Industry Contacts
struct ContactListItem: View {
    @Binding var path: NavigationPath
    
    let imageID: String
    let imageUrls: String
    let imageText: String
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                ZStack {
                    AsyncImage(url: URL(string: IMAGE_URL + imageUrls)) { image in
                        image.resizable()
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 140)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 140)
                    }
                    
                    LinearGradient(
                        colors: [Color(hex: "#2E2E93").opacity(0.8), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack{
                    Spacer()
                    HStack{
                        Text("▐")
                            .foregroundColor(Color(hex: "#90CFF2"))
                            .font(.system(size: 16))
                        
                        Text(imageText)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Image("arrow")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 4)
                    .padding(.trailing, 10)
                    .foregroundColor(Color.white)
                }
                .padding(.bottom, 4)
            }
        }
        .frame(height: 140)
    }
}

//MARK: CustomToggle

struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var onTrackColor: Color = .green
    var offTrackColor: Color = .gray.opacity(0.3)
    var onThumbColor: Color = .white
    var offThumbColor: Color = .black
    
    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            // Background track
            RoundedRectangle(cornerRadius: 20)
                .fill(isOn ? onTrackColor : offTrackColor)
                .frame(width: 55, height: 30)
            
            // Thumb (circle)
            Circle()
                .fill(isOn ? onThumbColor : offThumbColor)
                .frame(width: 26, height: 26)
                .padding(2)
                .shadow(radius: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: isOn)
        .onTapGesture {
            isOn.toggle()
        }
    }
}


//MARK: SliderBar
struct DCThresholdView: View {
    @Binding var is_rotate: Bool
    @Binding var threshold: Double
    @Binding var is_clicked_activate: Bool
    var range: ClosedRange<Double> = 1...2000
    var step: Double = 1
    var onDone: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            // Title showing current value
            Text("DC Threshold: \(Int(threshold)) µT")
                .font(.headline)
            
            // Slider + min/max labels
            VStack(spacing: 8) {
                Slider(value: $threshold, in: range, step: step)
                    .tint(Color(.systemTeal))
                    .onChange(of: threshold){
                        if is_clicked_activate == false {
                            if threshold <= 37{
                                is_rotate = true
                            }
                            else{
                                is_rotate = false
                            }
                        }
                        else{
                            is_rotate = false
                        }
                    }
                
                HStack {
                    Text("\(Int(range.lowerBound)) µT")
                    Spacer()
                    Text("\(Int(range.upperBound)) µT")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            
            HStack {
                HStack(spacing: 0) {
                    Button {
                        threshold = max(range.lowerBound, threshold - step)
                        if is_clicked_activate == false {
                            if threshold <= 37{
                                is_rotate = true
                            }
                            else{
                                is_rotate = false
                            }
                        } else{
                            is_rotate = false
                        }
                    } label: {
                        Text("–")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: "#656566"))
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                        .frame(height: 24)
                    
                    Button {
                        threshold = min(range.upperBound, threshold + step)
                        if is_clicked_activate == false {
                            if threshold <= 37{
                                is_rotate = true
                            }
                            else{
                                is_rotate = false
                            }
                        } else{
                            is_rotate = false
                        }
                    } label: {
                        Text("+")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: "#656566"))
                    }
                    .padding(.vertical, 10)
                }
                .frame(width: 120)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(hex: "#C6C6C8"))
                )
                
                Spacer(minLength: 24)
                
                Button("DONE") {
                    onDone?()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(hex: "#C6C6C8"))
                )
                .foregroundColor(Color(hex: "#656566"))
            }
        }
        .padding()
    }
}

//MARK: Notification View
struct NotificationView: View {
    let message: String
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                HStack(spacing: 12) {
                    Text(message)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: "#333333"))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.horizontal, 16)
            }
            .position(x : geo.size.width/2, y: geo.size.height - 30)
        }
    }
}

struct PDFPreviewView: View {
    let pdfURL: URL
    @State private var thumbnail: UIImage?
    @State private var showFullPDF = false
    
    var body: some View {
        VStack {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                    .clipped()
                    .cornerRadius(10)
                    .onTapGesture {
                        showFullPDF = true
                    }
            } else {
                ProgressView("Loading Preview...")
                    .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 100)
                    .task {
                        await loadThumbnail()
                    }
            }
        }
        .fullScreenCover(isPresented: $showFullPDF) {
            FullScreenPDFView(pdfURL: pdfURL)
        }
    }
    
    func loadThumbnail() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: pdfURL)
            if let document = PDFDocument(data: data),
               let page = document.page(at: 0) {
                let pageRect = page.bounds(for: .mediaBox)
                let scale: CGFloat = 0.3
                let thumbnailSize = CGSize(width: pageRect.width * scale,
                                           height: pageRect.height * scale)
                let image = page.thumbnail(of: thumbnailSize, for: .mediaBox)
                thumbnail = image
            }
        } catch {
            print("Failed to load PDF preview: \(error.localizedDescription)")
        }
    }
}

struct FullScreenPDFView: View {
    let pdfURL: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            PDFKitRepresentedView(url: pdfURL)
                .ignoresSafeArea()
                .navigationTitle("PDF Viewer")
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { dismiss() }) {
                            Label("Back", systemImage: "chevron.left")
                        }
                    }
                }
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .systemBackground
        
        loadPDFAsync(from: url){ document in
            DispatchQueue.main.async {
                pdfView.document = document
            }}
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
    
    func loadPDFAsync(from url: URL, completion: @escaping (PDFDocument?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let document = PDFDocument(data: data)
            completion(document)
        }.resume()
    }
}

#Preview{
    //    CustomTextEditor(icon: "email", placeholder: "Message", text: "afd")
}
