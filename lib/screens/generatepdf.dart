// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// // import 'package:pdf_google_fonts/pdf_google_fonts.dart';
// import 'package:printing/printing.dart';

// class GeneratePdf extends StatefulWidget {
//   const GeneratePdf({Key? key}) : super(key: key);

//   @override
//   State<GeneratePdf> createState() => _GeneratePdfState();
// }

// class _GeneratePdfState extends State<GeneratePdf> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Page'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               await createPDF();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('PDF Generated and opened!')),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error generating PDF: $e')),
//               );
//             }
//           },
//           child: const Text('Generate PDF'),
//         ),
//       ),
//     );
//   }

//   Future<void> createPDF() async {
//     try {
//       final logo = (await rootBundle.load('assets/images/cites.png')).buffer.asUint8List();
//       final doc = pw.Document();
//       final fontFamily = await PdfGoogleFonts.poppinsRegular();

//       doc.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           theme: pw.ThemeData(
//             defaultTextStyle: pw.TextStyle(
//               fontSize: 10,
//               font: fontFamily,
//               color: PdfColor.fromHex('#444444'),
//             ),
//           ),
//           build: (context) {
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Row(
//                   // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
//                   children: [
//                     pw.Image(pw.MemoryImage(logo), height: 60),
//                     pw.SizedBox(width: 15,),
//                     pw.Text('INTERNATIONAL TRADE IN \nENDANGERED SPECIES OF \nWILD FAUNA AND FLORA',
//                     style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),),
//                     pw.SizedBox(width: 120,),
//                     pw.BarcodeWidget(
//                       barcode: pw.Barcode.qrCode(),
//                       data: 'Sample QR Code Data',
//                       width: 60,
//                       height: 60,
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 // pw.Text(
//                 //   'INTERNATIONAL TRADE IN ENDANGERED SPECIES OF WILD FAUNA AND FLORA',
//                 //   style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//                 // ),
//                 pw.SizedBox(height: 5),
//                 pw.Text('Original', style: pw.TextStyle(fontSize: 10)),
//                 pw.SizedBox(height: 5),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('2. Valid until:')),
//                     pw.Expanded(child: pw.Text('01/01/2025')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Importer (name and address)')),
//                     pw.Expanded(child: pw.Text('Gabriel Duo-nah Health Centre, Enchi')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Country of import:')),
//                     pw.Expanded(child: pw.Text('Greece')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text('Special conditions', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.Text('This permit is valid for six months from the date of issue. Possession of this permit does not exempt the holder from compliance with any other relevant laws or regulations.'),
//                 pw.SizedBox(height: 10),
//                 pw.Text('SCIENTIFIC NAME (genus and species) AND COMMON NAME OF ANIMAL OR PLANT'),
//                 pw.Text('Homo Sapien (human)'),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Country of origin: Ghana')),
//                     pw.Expanded(child: pw.Text('Date: 01/01/2022')),
//                     pw.Expanded(child: pw.Text('Country of last re-export:')),
//                     pw.Expanded(child: pw.Text('')),
//                     pw.Expanded(child: pw.Text('Certificate No.:')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Scientific Name: Homo Sapien (human)')),
//                     pw.Expanded(child: pw.Text('9. hi')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Scientific Name: Atropoda (ant)')),
//                     pw.Expanded(child: pw.Text('9. Hwello')),
//                   ],
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Row(
//                   children: [
//                     pw.Expanded(child: pw.Text('Scientific Name: Omycota (Frog)')),
//                     pw.Expanded(child: pw.Text('9. Hey Baby')),
//                   ],
//                 ),
//                 // Add more fields as needed
//               ],
//             );
//           },
//         ),
//       );

//       final dir = await getTemporaryDirectory();
//       const fileName = 'sample.pdf';
//       final savePath = path.join(dir.path, fileName);
//       final file = File(savePath);

//       await file.writeAsBytes(await doc.save());
//       await OpenFilex.open(file.path);
//     } catch (e) {
//       throw Exception('Failed to create PDF: $e');
//     }
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf_google_fonts/pdf_google_fonts.dart';
import 'dart:async';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// void main() => runApp(MyApp());


class PDFHome extends StatefulWidget {
  //new added
  final String pdfUrl;

  PDFHome({required this.pdfUrl});
  //
  
  @override
  _PDFHomeState createState() => _PDFHomeState();
}
class _PDFHomeState extends State<PDFHome> {
  String remotePDFpath = "";
  String errorMessage = "";  // To hold any error messages

  @override
  void initState() {
    super.initState();
    _downloadAndOpenPdf();
  }

  Future<void> _downloadAndOpenPdf() async {
    try {
      File? pdfFile = await createFileOfPdfUrl();
      if (pdfFile != null) {
        setState(() {
          remotePDFpath = pdfFile.path;
          errorMessage = "";
        });

        if (remotePDFpath.isNotEmpty) {
          // Automatically navigate to the PDFScreen once the PDF is ready
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(path: remotePDFpath),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      print("Error downloading PDF: $e");
    }
  }

  Future<File?> createFileOfPdfUrl() async {
    Completer<File?> completer = Completer();
    final url = widget.pdfUrl;

    final filename = url.substring(url.lastIndexOf("/") + 1);

    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        var dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/$filename");
        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
      } else {
        throw Exception('Failed to download PDF, Status: ${response.statusCode}');
      }
    } catch (e) {
      completer.completeError(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error downloading PDF: $e')));
    }

    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Center(
        child: remotePDFpath.isEmpty
            ? errorMessage.isEmpty
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        "Wait as your document downloads...",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $errorMessage'),
                      ElevatedButton(
                        onPressed: _downloadAndOpenPdf,  // Retry download
                        child: const Text('Retry'),
                      ),
                    ],
                  )
            : const Text("PDF Ready!"),
      ),
    );
  }
}


//THIS IS WORKING
class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CITES Certificate"),
        centerTitle: true,
        
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(child: CircularProgressIndicator())
                  : Container()
              : Center(child: Text(errorMessage)),
        ],
      ),
    );
  }
}
