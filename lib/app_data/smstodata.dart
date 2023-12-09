import 'package:expense_tracker/app_data/dataclass.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsToData extends GetxController {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> messages = [];
  List<SmsMessage> creditmessages = [];
  List<SmsMessage> debitmessages = [];
  final List<String> creditAmountlist = [];
  final List<String> debitAmountlist = [];
  final List<String> creditAmountlistlast = [];
  final List<String> debitAmountlistlast = [];
  final List<String> creditAmountlistlasttolast = [];
  final List<String> debitAmountlistlasttolast = [];
  final List<String> creditAmountlistlast3dr = [];
  final List<String> debitAmountlistlastt3dr = [];
  final List<String> creditAmountlistnow = [];
  final List<String> debitAmountlistnow = [];

  final RegExp minbal = RegExp(r'min bal|avl bal | aval', caseSensitive: false);
  final RegExp acPattern = RegExp(r'A/c \*|account', caseSensitive: false);
  final RegExp upiPattern = RegExp(r'UPI', caseSensitive: false);
  final RegExp bankPattern = RegExp(r'bank', caseSensitive: false);
  final RegExp debitAmount = RegExp(r'(\d+\.\d*d*)', caseSensitive: false);
  final RegExp creditAmount = RegExp(r'(\d+\.\d*d*)', caseSensitive: false);
  final RegExp credit = RegExp(r'credited|recived', caseSensitive: false);
  final RegExp debit = RegExp(r'debited|paid|sent', caseSensitive: false);

  List<MyMessageType> filteredMessages = [];
  List<MyMessageType> filteredMessageslast = [];
  List<MyMessageType> creditfilteredMessages = [];
  List<MyMessageType> debitfilteredMessages = [];
  getpermissionwithdata() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final message = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
        ],
      );

      messages = message;

      filteredMessages = messages
          .where((message) =>
              bankPattern.hasMatch(message.body!.toLowerCase()) &&
              upiPattern.hasMatch(message.body!.toLowerCase()) &&
              !minbal.hasMatch(message.body!.toLowerCase()) &&
              acPattern.hasMatch(message.body!.toLowerCase()))
          .map((message) => MyMessageType(message.address!, message.body!,
              message.date!.toString(), extractAmount(message.body!)))
          .toList();
    } else {
      await Permission.sms.request();
    }
  }

  String extractAmount(String body) {
    final match = debitAmount.firstMatch(body) ?? creditAmount.firstMatch(body);
    return match?.group(0) ?? '0.00';
  }

  double? sumList(List<String> items) {
    final List<double> doubleList =
        items.map((str) => double.parse(str)).toList();
    if (doubleList.isNotEmpty) {
      return doubleList.reduce((value, element) => value + element);
    }
    return 000.00;
  }

  smsdatacollector() {
    for (int i = 0; i < filteredMessages.length; i++) {
      var message = filteredMessages[i];
      final transactionAmount = extractAmount(message.body);
      if (credit.hasMatch(message.body)) {
        creditAmountlist.add(transactionAmount);
      } else if (debit.hasMatch(message.body)) {
        debitAmountlist.add(transactionAmount);
      }
    }
  }

  getcreditfilter() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final message = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
        ],
      );

      creditmessages = message;

      creditfilteredMessages = creditmessages
          .where((message) =>
              bankPattern.hasMatch(message.body!.toLowerCase()) &&
              upiPattern.hasMatch(message.body!.toLowerCase()) &&
              !minbal.hasMatch(message.body!.toLowerCase()) &&
              credit.hasMatch(message.body!.toLowerCase()) &&
              acPattern.hasMatch(message.body!.toLowerCase()))
          .map((message) => MyMessageType(message.address!, message.body!,
              message.date!.toString(), extractAmount(message.body!)))
          .toList();
    } else {
      await Permission.sms.request();
    }
  }

  getdebitfilter() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final message = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
        ],
      );

      debitmessages = message;

      debitfilteredMessages = debitmessages
          .where((message) =>
              bankPattern.hasMatch(message.body!.toLowerCase()) &&
              upiPattern.hasMatch(message.body!.toLowerCase()) &&
              !minbal.hasMatch(message.body!.toLowerCase()) &&
              debit.hasMatch(message.body!.toLowerCase()) &&
              acPattern.hasMatch(message.body!.toLowerCase()))
          .map((message) => MyMessageType(message.address!, message.body!,
              message.date!.toString(), extractAmount(message.body!)))
          .toList();
    } else {
      await Permission.sms.request();
    }
  }

  String getCurrentMonth() {
    DateTime currentDate = DateTime.now();
    String monthName = DateFormat('MMMM').format(currentDate);
    return monthName;
  }

  String getPreviousMonth() {
    DateTime currentDate = DateTime.now();
    DateTime previousMonth =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    String monthName = DateFormat('MMMM').format(previousMonth);
    return monthName;
  }

  String getMonthBeforePrevious() {
    DateTime currentDate = DateTime.now();
    DateTime monthBeforePrevious =
        DateTime(currentDate.year, currentDate.month - 2, currentDate.day);

    String monthName = DateFormat('MMMM').format(monthBeforePrevious);
    return monthName;
  }

  String getMonthBeforeThat() {
    DateTime currentDate = DateTime.now();
    DateTime monthBeforeThat =
        DateTime(currentDate.year, currentDate.month - 3, currentDate.day);

    String monthName = DateFormat('MMMM').format(monthBeforeThat);
    return monthName;
  }

  currentMonth() {
    DateTime now = DateTime.now();
    DateTime currentMonthStart = DateTime(
      now.year,
      now.month,
    );
    DateTime nextMonthStart = DateTime(
      now.year,
      now.month + 1,
    );

    for (int i = 0; i < filteredMessages.length; i++) {
      var message = filteredMessages[i];
      final transactionAmount = extractAmount(message.body);
      DateTime messageDate = DateTime.parse(message.date);

      if (messageDate.isAfter(currentMonthStart) &&
          messageDate.isBefore(nextMonthStart)) {
        if (credit.hasMatch(message.body)) {
          creditAmountlistnow.add(transactionAmount);
        } else if (debit.hasMatch(message.body)) {
          debitAmountlistnow.add(transactionAmount);
        }
      }
    }
  }

  lastotlast() {
    DateTime now = DateTime.now();
    DateTime lasttolastMonthStart = DateTime(
      now.year,
      now.month - 2,
    );
    DateTime lasttolastMonthEnd = DateTime(
      now.year,
      now.month - 1,
    );
    for (int i = 0; i < filteredMessages.length; i++) {
      var message = filteredMessages[i];
      final transactionAmount = extractAmount(message.body);
      DateTime messageDate = DateTime.parse(message.date);

      if (messageDate.isAfter(lasttolastMonthStart) &&
          messageDate.isBefore(lasttolastMonthEnd)) {
        if (credit.hasMatch(message.body)) {
          creditAmountlistlasttolast.add(transactionAmount);
        } else if (debit.hasMatch(message.body)) {
          debitAmountlistlasttolast.add(transactionAmount);
        }
      }
    }
  }

  last3rd() {
    DateTime now = DateTime.now();
    DateTime last3rdMonthStart = DateTime(now.year, now.month - 3);
    DateTime last3rdMonthEnd = DateTime(
      now.year,
      now.month - 2,
    );

    for (int i = 0; i < filteredMessages.length; i++) {
      var message = filteredMessages[i];
      final transactionAmount = extractAmount(message.body);
      DateTime messageDate = DateTime.parse(message.date);

      if (messageDate.isAfter(last3rdMonthStart) &&
          messageDate.isBefore(last3rdMonthEnd)) {
        if (credit.hasMatch(message.body)) {
          creditAmountlistlast3dr.add(transactionAmount);
        } else if (debit.hasMatch(message.body)) {
          debitAmountlistlastt3dr.add(transactionAmount);
        }
      }
    }
  }

  lastmonth() {
    DateTime now = DateTime.now();
    DateTime lastMonthStart = DateTime(
      now.year,
      now.month - 1,
    );
    DateTime lastMonthEnd = DateTime(
      now.year,
      now.month,
    );

    for (int i = 0; i < filteredMessages.length; i++) {
      var message = filteredMessages[i];
      final transactionAmount = extractAmount(message.body);
      DateTime messageDate = DateTime.parse(message.date);

      if (messageDate.isAfter(lastMonthStart) &&
          messageDate.isBefore(lastMonthEnd)) {
        if (credit.hasMatch(message.body)) {
          creditAmountlistlast.add(transactionAmount);
        } else if (debit.hasMatch(message.body)) {
          debitAmountlistlast.add(transactionAmount);
        }
      }
    }
  }
}
