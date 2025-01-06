import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../app/app.locator.dart';
import '../model/encounter.dart';
import '../model/outcome_measures/outcome_measure.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pdf_merger/pdf_merger.dart';

import '../model/patient.dart';
import 'logger_service.dart';

class PdfService {
  final _logger = locator<LoggerService>().getLogger((PdfService).toString());

  late NumberFormat numberFormatter;
  late String dirPath;

  // TODO: Translate 'Patient ID', and 'Date' into selected language
  Future<MergeMultiplePDFResponse> exportPdf(
      BuildContext context, Encounter encounter, Patient patient,
      {String locale = 'en'}) async {
    _logger.d('');

    DateTime sessionDate =
        DateTime.now(); //encounter.encounterCreatedTimeString!;
    numberFormatter = NumberFormat.decimalPattern(locale);
    Directory directory = await path_provider.getTemporaryDirectory();
    dirPath = directory.path;
    List<String> filesPath = [];

    // filesPath
    //     .add(await _createClientPage(context, encounter, patient, sessionDate));

    filesPath.add(await _createCover(context, encounter, patient, sessionDate));
    filesPath.addAll(
        await _createOutcomeMeasures(context, encounter, patient, sessionDate));

    //TODO: Jiyun - outputPath is correct?
    DateFormat dateFormat = DateFormat('yyyyMMdd');
    String outputPath = '$dirPath/smartpo_${patient.id}_${dateFormat.format(encounter.encounterCreatedTime!)}.pdf';
    return PdfMerger.mergeMultiplePDF(
        paths: filesPath, outputDirPath: outputPath);
  }

  // Future<String> _createClientPage(BuildContext context, Encounter encounter,
  //     Patient patient, DateTime sessionDate,
  //     {String locale = 'en'}) async {
  //   _logger.d('');
  //
  //   ByteData data =
  //       await rootBundle.load('packages/comet_foundation/pdf/client_page.pdf');
  //   PdfDocument clientPageDoc =
  //       PdfDocument(inputBytes: data.buffer.asUint8List());
  //
  //   print(patient.toJsonForPDF());
  //
  //   Map<String, dynamic> pdfJson = patient.toJsonForPDF();
  //
  //   print(pdfJson);
  //
  //   //import data into pdf form
  //   clientPageDoc.form
  //       .importData(utf8.encode(jsonEncode(pdfJson)), DataFormat.json);
  //   clientPageDoc.form.flattenAllFields();
  //
  //   await _addHeaderFooterForCOMET(
  //       context, clientPageDoc, patient.id, sessionDate, locale);
  //   File clientPageFile = await File('$dirPath/${patient.id}_client_page.pdf')
  //       .writeAsBytes(await clientPageDoc.save());
  //   clientPageDoc.dispose();
  //   return clientPageFile.path;
  // }

  Future<List<String>> _createOutcomeMeasures(BuildContext context,
      Encounter encounter, Patient patient, DateTime sessionDate,
      {String locale = 'en'}) async {
    _logger.d('');

    List<String> filePaths = [];
    for (var i = 0; i < encounter.outcomeMeasures!.length; i++) {
      OutcomeMeasure outcome = encounter.outcomeMeasures![i];
      ByteData data;
      try {
        data = await rootBundle.load(
            'packages/comet_foundation/pdf/${outcome.id}_${locale.toString()}.pdf');
      } catch (e) {
        data = await rootBundle
            .load('packages/comet_foundation/pdf/${outcome.id}_en.pdf');
      }

      PdfDocument document = PdfDocument(inputBytes: data.buffer.asUint8List());
      await _addHeaderFooterForCOMET(
          context, document, patient.id, sessionDate, 'en',
          outcome: outcome);

      print(outcome.exportResponses(locale));

      document.form.importData(
          utf8.encode(jsonEncode(outcome.exportResponses(locale))),
          DataFormat.json);
      document.form.flattenAllFields();

      File file = await File('$dirPath/${outcome.id}.pdf')
          .writeAsBytes(await document.save());
      document.dispose();
      filePaths.add(file.path);
    }
    return filePaths;
  }

  Future<String> _createCover(BuildContext context, Encounter encounter,
      Patient patient, DateTime sessionDate,
      {String locale = 'en'}) async {
    _logger.d('');

    ByteData data =
        await rootBundle.load('packages/comet_foundation/pdf/cover.pdf');
    PdfDocument coverDoc = PdfDocument(inputBytes: data.buffer.asUint8List());
    await _addHeaderFooterForCOMET(
        context, coverDoc, patient.id, sessionDate, locale);
    PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14,
        multiStyle: [PdfFontStyle.bold, PdfFontStyle.underline]);
    PdfFont outcomeFont = PdfStandardFont(PdfFontFamily.helvetica, 14);
    PdfFont scoreFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
    );
    double titleHeaderLeft = 210;
    double headerLeft = 75;
    double scoreTitleLeft = 105;
    double headerHeight = 40;
    double scoreHeight = 24;
    double currentTop = 120;
    Size pageSize = coverDoc.pageSettings.size;
    PdfPage coverPage = coverDoc.pages[0];
    coverPage.graphics.drawString("Outcome Measures Completed", headerFont,
        bounds: Rect.fromLTWH(
            titleHeaderLeft, currentTop, pageSize.width, headerHeight));
    currentTop += headerHeight;
    for (var i = 0; i < encounter.outcomeMeasures!.length; i++) {
      OutcomeMeasure outcome = encounter.outcomeMeasures![i];
      List<String> scores = [];
      if (outcome.totalScore.isNotEmpty) {
        scores.clear();
        outcome.totalScore.forEach((key, value) => scores.add(value));
      }
      coverPage.graphics.drawString(outcome.name, outcomeFont,
          bounds: Rect.fromLTWH(
              headerLeft, currentTop, pageSize.width, headerHeight));
      currentTop += headerHeight;
      // if (scores.isNotEmpty) {
      //   for (var j = 0; j < scores.length; j++) {
      //     print(scoreHeight);
      //     scoreHeight += scoreHeight *
      //         '\n'.allMatches(outcome.getSummaryScoreTitle(j)).length;
      //     print(scoreHeight);
      //     coverPage.graphics.drawString(
      //         "${outcome.getSummaryScoreTitle(j)}", scoreFont,
      //         bounds: Rect.fromLTWH(
      //             scoreTitleLeft, currentTop, pageSize.width / 3, scoreHeight));
      //     coverPage.graphics.drawString("${scores[j]}", scoreFont,
      //         bounds: Rect.fromLTWH(scoreTitleLeft + pageSize.width / 3 + 200,
      //             currentTop, pageSize.width, scoreHeight));
      //     currentTop += scoreHeight;
      //   }
      // } else {
      //   coverPage.graphics.drawString(
      //       AppLocalizations.of(context).seeDetailedReport, scoreFont,
      //       bounds: Rect.fromLTWH(
      //           scoreTitleLeft, currentTop, pageSize.width / 3, scoreHeight));
      //   currentTop += scoreHeight;
      // }
    }
    File coverFile = await File('$dirPath/${patient.id}_cover.pdf')
        .writeAsBytes(await coverDoc.save());
    coverDoc.dispose();
    return coverFile.path;
  }

  Future<void> _addHeaderFooterForCOMET(
      BuildContext context,
      PdfDocument document,
      String patientID,
      DateTime sessionDate,
      String locale,
      {OutcomeMeasure? outcome}) async {
    numberFormatter = NumberFormat.decimalPattern(locale);
    PdfBitmap cometLogo = PdfBitmap(await _readImageData("smartpo-logo.png"));
    PdfBitmap oiLogo = PdfBitmap(await _readImageData("oi-logo.png"));
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('E, MM/dd/yyyy');
    final String value = formatter.format(now);
    PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12,
        multiStyle: [PdfFontStyle.bold]);
    for (int i = 0; i < document.pages.count; i++) {
      PdfPage page = document.pages[i];
      page.graphics.drawImage(cometLogo, const Rect.fromLTWH(408, 45, 140, 40));
      page.graphics.drawString("Date: $value", headerFont,
          bounds: const Rect.fromLTWH(75, 45, 200, 60));
      page.graphics.drawString("Patient ID: $patientID", headerFont,
          bounds: const Rect.fromLTWH(75, 70, 200, 60));
      page.graphics.drawImage(
          oiLogo,
          Rect.fromLTWH(
              75, document.pages[0].getClientSize().height - 90, 96, 32));
      if (outcome != null) {
        double textWidth = 100;
        page.graphics.drawString(outcome.shortName, headerFont,
            bounds: Rect.fromLTWH(
                document.pages[0].getClientSize().width / 2 - textWidth / 2,
                document.pages[0].getClientSize().height - 90,
                textWidth,
                60),
            format: PdfStringFormat(alignment: PdfTextAlignment.center));
      }
    }
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data =
        await rootBundle.load('packages/comet_foundation/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
