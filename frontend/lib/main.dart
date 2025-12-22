import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------------------
// Configuration
// -----------------------------------------------------------------------------
<<<<<<< HEAD
// Dynamic API base URL based on platform to handle localhost/emulator differences
final String apiBaseUrl = () {
  if (kIsWeb) {
    // Web platform: use localhost
    return 'http://localhost:8000';
  } else {
    // Mobile platforms: Android emulator uses 10.0.2.2, physical devices use actual IP
    // For physical devices, replace with your machine's IP address (e.g., http://192.168.x.x:8000)
    return 'http://10.0.2.2:8000';
  }
}();

=======
const String apiBaseUrl = 'http://10.0.2.2:8000'; 
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
const String predictEndpoint = '/predict';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartChecker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
<<<<<<< HEAD
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        textTheme: GoogleFonts.interTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
=======
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
      ),
      home: const InferenceScreen(),
    );
  }
}

class InferenceScreen extends StatefulWidget {
  const InferenceScreen({super.key});

  @override
  State<InferenceScreen> createState() => _InferenceScreenState();
}

class _InferenceScreenState extends State<InferenceScreen> {
  File? _image;
  Uint8List? _imageBytes;
  String _predictionResult = 'No image selected.';
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _predictionData;

  // ---------------------------------------------------------------------------
  // Image Picking Logic
  // ---------------------------------------------------------------------------
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
<<<<<<< HEAD
        if (!kIsWeb) {
          _image = File(pickedFile.path);
        }
        _imageBytes = bytes;
        _predictionResult = 'Image selected. Ready to predict.';
=======
        _image = File(pickedFile.path);
        _predictionResult = 'Image selected. Ready to verify.';
        _predictionData = null;
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
      });
    } else {
      setState(() {
        _predictionResult = 'No image selected.';
        _predictionData = null;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // API Communication Logic
  // ---------------------------------------------------------------------------
  Future<void> _uploadImageAndPredict() async {
    if (_imageBytes == null && _image == null) {
      setState(() {
        _predictionResult = 'Please select an image first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _predictionResult = 'Verifying payment slip...';
      _predictionData = null;
    });

    try {
      var uri = Uri.parse('$apiBaseUrl$predictEndpoint');
      var request = http.MultipartRequest('POST', uri);

<<<<<<< HEAD
      // 2. Attach the image file
      // The field name 'file' must match the parameter name in the FastAPI endpoint:
      // async def predict_image(file: UploadFile = File(...)):
      if (kIsWeb && _imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          _imageBytes!,
          filename: 'image.jpg',
        ));
      } else if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          _image!.path,
        ));
      }
=======
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        _image!.path,
      ));
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
<<<<<<< HEAD

        // Format the result for display
        String label = result['predicted_label'] ?? 'N/A';
        double probFake = result['probabilities']['Fake'] ?? 0.0;
        double probReal = result['probabilities']['Real'] ?? 0.0;

        setState(() {
          _predictionResult = 'Prediction: $label\n'
              'Fake Probability: ${(probFake * 100).toStringAsFixed(2)}%\n'
              'Real Probability: ${(probReal * 100).toStringAsFixed(2)}%';
=======
        
        setState(() {
          _predictionData = result;
          _predictionResult = 'Verification Complete.';
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
        });
      } else {
        final errorBody = jsonDecode(response.body);
        String detail = errorBody['detail'] ?? 'Unknown error';
        setState(() {
          _predictionResult = 'Error (${response.statusCode}): $detail';
          _predictionData = null;
        });
      }
    } catch (e) {
      setState(() {
        _predictionResult = 'Network Error: Failed to connect to API.\n'
<<<<<<< HEAD
            'Please check if the API is running at $apiBaseUrl and if the IP is correct.';
=======
                            'Check if the API is running at $apiBaseUrl and if the IP is correct.';
        _predictionData = null;
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // UI Building
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          'AI Image Classifier',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 2,
=======
        title: const Text('SmartChecker Verification'),
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Center(
<<<<<<< HEAD
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Top info / instruction
                Text(
                  'Select an image to classify whether it is Real or Fake.',
                  style:
                      GoogleFonts.inter(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Display the selected image
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  height: 340,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _imageBytes == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image,
                                  size: 56, color: Colors.grey[300]),
                              const SizedBox(height: 8),
                              Text(
                                'No image selected',
                                style: GoogleFonts.inter(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                        ),
                ),

                // Action row: pick + predict
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: Text('Choose Image',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _isLoading
                          ? SizedBox(
                              height: 48,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _uploadImageAndPredict,
                              icon: const Icon(Icons.send),
                              label: Text('Run Prediction',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Result Display Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prediction Result',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Divider(),
                        Text(
                          _predictionResult,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: _predictionResult.startsWith('Error')
                                ? Colors.red
                                : Colors.black87,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
=======
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 1. Image Display Area
              _buildImageDisplay(context),
              
              const SizedBox(height: 24),

              // 2. Action Buttons
              _buildActionButtons(context),
              
              const SizedBox(height: 30),

              // 3. Result Display
              _buildResultDisplay(context),
            ],
>>>>>>> 1569809 (FEAT: Improve Flutter UI for professional look (SmartChecker theme))
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _image == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'Payment Slip Preview',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image!,
                fit: BoxFit.contain,
              ),
            ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Select Image Button
        Expanded(
          child: FilledButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_library),
            label: const Text('Select Slip'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),

        // Predict Button
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: _image != null ? _uploadImageAndPredict : null,
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Verify Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildResultDisplay(BuildContext context) {
    if (_predictionData == null) {
      return Text(
        _predictionResult,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: _predictionResult.startsWith('Error') ? Colors.red : Colors.grey.shade600,
        ),
      );
    }

    String label = _predictionData!['predicted_label'] ?? 'N/A';
    double probFake = _predictionData!['probabilities']['Fake'] ?? 0.0;
    double probReal = _predictionData!['probabilities']['Real'] ?? 0.0;
    
    Color resultColor = label == 'Real' ? Colors.green.shade700 : Colors.red.shade700;
    IconData resultIcon = label == 'Real' ? Icons.check_circle : Icons.cancel;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(resultIcon, size: 36, color: resultColor),
                const SizedBox(width: 10),
                Text(
                  'Verification Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            
            // Main Prediction Result
            Center(
              child: Text(
                label == 'Real' ? 'AUTHENTIC' : 'FRAUDULENT',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: resultColor,
                ),
              ),
            ),
            const Divider(height: 20),

            // Probability Details
            _buildProbabilityRow('Real Payment Probability', probReal, Colors.green),
            _buildProbabilityRow('Fake Payment Probability', probFake, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityRow(String title, double probability, Color color) {
    String percentage = (probability * 100).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
