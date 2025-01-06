import 'dart:io';

import 'package:biot/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf_merger/pdf_merger_response.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../model/encounter.dart';
import '../../../model/patient.dart';
import '../../../services/database_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/pdf_service.dart';

class CompleteViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _localdbService = locator<DatabaseService>();
  final _pdfService = locator<PdfService>();
  final _logger =
      locator<LoggerService>().getLogger((CompleteViewModel).toString());

  bool get isAnonymous => _localdbService.currentPatient == null;

  String? patientID;

  Patient get currentPatient => _localdbService.currentPatient!.value;
  final Encounter encounter;
  BuildContext context;

  CompleteViewModel({required this.context, required this.encounter}) {
    _logger.d('');
  }

  Future<void> exportPDF({String locale = 'en'}) async {
    _logger.d('export PDF');

    if (!isAnonymous) {
      patientID = _localdbService.currentPatient?.value.id;
    }
    // final File file = await _pdfService.exportPdf(context, session, patientID,
    //     locale: locale);
    MergeMultiplePDFResponse response = await _pdfService
        .exportPdf(context, encounter, currentPatient, locale: locale);
    // TODO: workaround to navigate to back. WillPopScope
    _navigationService.back();
    if (response.status == "success") {
      final file = File(response.response!);
      OpenResult result =
          await OpenFilex.open(file.path, type: 'application/pdf');
      if (result.type == ResultType.noAppToOpen) {
        //TODO: JK- display no reader alert
        _logger.d('no pdf reader is available');
      }
    } else {
      _logger.d('failed to export pdf');
    }
  }

  Future<void> navigateToLoginView() async {
    _logger.d('');

    _navigationService.navigateToLoginView(isAuthCheck: true);
  }
}
