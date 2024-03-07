import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

Future<void> generatePDF(String programName, String programType, int participants, String startDate, String startTime, String endDate, String endTime) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Program Name: $programName'),
          pw.Text('Program Type: $programType'),
          pw.Text('Number of Participants: $participants'),
          pw.Text('Start Date: $startDate'),
          pw.Text('Start Time: $startTime'),
          pw.Text('End Date: $endDate'),
          pw.Text('End Time: $endTime'),
        ],
      ),
    ),
  );

  final file = File('event_details.pdf');
  await file.writeAsBytes(await pdf.save());
}
