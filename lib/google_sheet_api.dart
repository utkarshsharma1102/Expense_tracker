import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "expense-tracker-395020",
  "private_key_id": "660ef2949dd348d10416558a45fd2f766cba85b6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDFD2r9fCMvZU6d\nFRzGBbjS75RYsrZFOeUEE1WcGKrpSuUvF5JCMP45XKM5CmP7lbPVUjZKKLJgyThj\nWus5c4IfC4ODJMj5GcoQPnENgAlFSsFhtp1vIFMNuO0sPjLSHuWl1B4oDjqxIk6R\nqUecZURU8TcinfZiaWgoSop4vyqxu6FKImHp+QtWssmCqiLupZsqFCXj+fMy8vzA\n2gnUcSRnRgdTYiGKMZ0ZTYIon7xuNUr74GFUJUb38eF9eThqxpapLgKtfdXtj8yg\n+GmwBNhFASmFDykKi1UoLFi5VH3CtmKQf5ju+DoEc23dY6HEofbAbpsj5/nFOJPg\nW76h4KLFAgMBAAECggEABwlrKGSZrAxZz42sspyLMksYWMd+7z9nQGtBVBrkZYLF\nZtZYZHEz7s/ySyvmEJqSqqQuKJ1F62NcFl4thqZrh9jFKDZ0z8JePxC/wDvpeNY3\nzBm1iv2UQanwHDOXZH3ydOa7cfI6Ic+oDxcEpd7O3xqi/aM25GI/tCqfQbsP1vtc\ndu7v5Knbed1qJvUWtT1+abXohta4RFSsoiLHrRnh6aUPbh8bnWg70dcAcowipoVs\naVfrHaHSYmFhdv7FFcZTOL/UGC4DKj8ppPTO4UmxCufq+ISrBZ64oYvuRxjwBiWs\njagOrv4IcckWAKDAfW2wEK+DXkoCq95b/np4WC2p8QKBgQDjxFpqgazH3QAg7x1Y\nwrD7ghtkvE7zuLirZJYSSchjJ7FBDhnxjeZE12HzgI2DVj64qKtvjS0jWHRpoKEG\nWO/s2a2Sib63Kyfz0LOaISCYab0CyH5WUGjKgEjN31qtlE0WwYxW4OEDC4nsEwEC\nJdR+vySH3XWPAtOKaJBHA2oN1QKBgQDdfKhmJ1/3QsvJ+06xW9+ooZCI2MVScbqp\n4LEMo7r+gPjUsLLmHkbHvsfyXDM8trUU6FLy+ZiqzpS0A277H6iqS29j6hYaKf1Q\nHiHg6dBw6EK3I26NZaHDGV/NI4Repwv96fUbmVkMDnxp5I5r2+6kWWT6th687Kup\ny/luMfmJMQKBgEedL0iZqTfWNvoj9Lg5zuflirNrue9Lv1S0dbMeW9FBY6wuwN2A\nXkx65CNp4hTPgz0QW4bhfrXEVCX6CWczg4yXDMosYTi6av9wOWhWzibd6D39yCtf\ncPNqznlcpug43twu0u9mGZmZgS4m84Q3XM7VTqkhapsiqly0b9jELA5ZAoGAFkuH\nFAlgop4pr2JJsJbD89CXoP7ZFgx2ssT4bYJJv3ayFY7X40wm6dJthBr92V226qzc\nNLMlSARVea1izYqJSuMfClq08NtLMXZnCKHgpozqsk6xwS/60Y3LU/YATBranSug\nza9pBEqtAWfNYlQYOJj7DjWo8HGOciAjMpF7QfECgYAs+J5YvRPJwcNwSdmZXaXg\nF+A/x1LLbjYM50aMNolclOK+8lOS8Rd+VTIpOfqlneP7qg80C6U1u+5na4LDkyhn\ntCub4L+gyhefEHETTgk0PHZfIcMp3jM9+wgPk+pq9MXJ483mD371N9OGeTQdOsJx\nMvYw1m0kZJzfe5f5KlO2JA==\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker@expense-tracker-395020.iam.gserviceaccount.com",
  "client_id": "108149805184536145220",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker%40expense-tracker-395020.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static final _spreedsheetId = '1NZujbt8TYSYG7k_msp-wVp24mNbT4SAcnfDcrLOYIsE';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransaction = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreedsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransaction + 1)) !=
        '') {
      numberOfTransaction++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; 1 < numberOfTransaction; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);
      if (currentTransactions.length < numberOfTransaction) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    loading = false;
  }

  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransaction++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
