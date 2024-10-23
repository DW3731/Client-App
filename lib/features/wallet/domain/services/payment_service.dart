import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String apiKey = 'ed22ed54f70f141d51a486589e1f2757afd0bcff'; // Remplacez par votre clé API

  Future<String> initiatePayment() async {
    final Uri url = Uri.parse('https://sandbox.paymee.tn/api/v2/payments/create'); // Utilisez l'URL en production pour la version finale

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $apiKey',
      },
      body: jsonEncode({
        'amount': 220.25,
        'note': 'Order #123',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'test@paymee.tn',
        'phone': '+21611222333',
        'return_url': 'https://www.return_url.tn',
        'cancel_url': 'https://www.cancel_url.tn',
        'webhook_url': 'https://www.webhook_url.tn',
        'order_id': '244557',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['payment_url'];
    } else {
      throw Exception('Failed to initiate payment');
    }
  }
}
