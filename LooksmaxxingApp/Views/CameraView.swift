//
//  CameraView.swift
//  LooksmaxxingApp
//
//  Face capture view with AVFoundation camera
//  Captures front and side profile photos
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var viewModel = ScanViewModel()
    @StateObject private var cameraController = CameraController()
    @Environment(\.dismiss) private var dismiss
    @State private var showResults = false
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(session: cameraController.captureSession)
                .ignoresSafeArea()
            
            // Overlay
            VStack {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Mode indicator
                    Text(viewModel.captureMode.instruction)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding()
                
                Spacer()
                
                // Face guide
                FaceGuideOverlay(mode: viewModel.captureMode)
                
                Spacer()
                
                // Capture status
                HStack(spacing: 30) {
                    // Front photo indicator
                    VStack {
                        Image(systemName: viewModel.frontImage != nil ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(viewModel.frontImage != nil ? .green : .white)
                        Text("Front")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    // Side photo indicator
                    VStack {
                        Image(systemName: viewModel.sideImage != nil ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(viewModel.sideImage != nil ? .green : .white)
                        Text("Side")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 20)
                
                // Capture button
                Button(action: capturePhoto) {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 65, height: 65)
                        
                        if viewModel.isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        }
                    }
                }
                .disabled(viewModel.captureMode == .complete || viewModel.isProcessing)
                .padding(.bottom, 50)
            }
            
            // Processing overlay
            if viewModel.isProcessing {
                ProcessingOverlay(progress: viewModel.processingProgress)
            }
            
            // Error overlay
            if let error = viewModel.error {
                ErrorOverlay(error: error) {
                    viewModel.reset()
                }
            }
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            cameraController.stopSession()
        }
        .onChange(of: viewModel.analysisResult) { result in
            if result != nil {
                showResults = true
            }
        }
        .fullScreenCover(isPresented: $showResults) {
            if let result = viewModel.analysisResult {
                ResultsView(analysis: result)
            }
        }
    }
    
    private func capturePhoto() {
        cameraController.capturePhoto { image in
            if let image = image {
                switch viewModel.captureMode {
                case .front:
                    viewModel.captureFront(image)
                case .side:
                    viewModel.captureSide(image)
                case .complete:
                    break
                }
            }
        }
    }
}

// MARK: - Camera Preview View

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}

// MARK: - Face Guide Overlay

struct FaceGuideOverlay: View {
    let mode: ScanViewModel.CaptureMode
    
    var body: some View {
        ZStack {
            // Face outline
            if mode == .front {
                Ellipse()
                    .stroke(Color.white.opacity(0.7), lineWidth: 3)
                    .frame(width: 250, height: 320)
            } else if mode == .side {
                // Side profile guide
                SideProfileGuide()
                    .stroke(Color.white.opacity(0.7), lineWidth: 3)
                    .frame(width: 200, height: 300)
            }
        }
    }
}

// MARK: - Side Profile Guide Shape

struct SideProfileGuide: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Simple side profile outline
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.minY + 20))
        path.addCurve(
            to: CGPoint(x: rect.maxX - 30, y: rect.midY - 40),
            control1: CGPoint(x: rect.midX + 40, y: rect.minY),
            control2: CGPoint(x: rect.maxX - 10, y: rect.midY - 100)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX + 20, y: rect.maxY - 20),
            control1: CGPoint(x: rect.maxX, y: rect.midY + 50),
            control2: CGPoint(x: rect.midX + 60, y: rect.maxY - 50)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX - 20, y: rect.minY + 20),
            control1: CGPoint(x: rect.minX + 30, y: rect.maxY),
            control2: CGPoint(x: rect.minX + 20, y: rect.minY + 100)
        )
        
        return path
    }
}

// MARK: - Processing Overlay

struct ProcessingOverlay: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 200)
                
                Text("Analyzing your face...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(40)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
        }
    }
}

// MARK: - Error Overlay

struct ErrorOverlay: View {
    let error: AppError
    let onRetry: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                Text(error.errorDescription ?? "An error occurred")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if let recovery = error.recoverySuggestion {
                    Text(recovery)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                if error.isRetryable {
                    Button(action: onRetry) {
                        Text("Try Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(40)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
        }
    }
}

// MARK: - Camera Controller

class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var completion: ((UIImage?) -> Void)?
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        // Front camera for selfies
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            completion?(nil)
            return
        }
        
        // Mirror the image for front camera
        let mirrored = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        completion?(mirrored)
    }
}

#Preview {
    CameraView()
}
