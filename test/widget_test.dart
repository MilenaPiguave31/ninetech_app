// Importa las herramientas para hacer pruebas en Flutter.
import 'package:flutter_test/flutter_test.dart';

// Importa nuestra aplicación principal.
import 'package:ninetech_app/main.dart';

void main() {

  testWidgets(
    'La aplicación 9 Tech inicia correctamente',
    (WidgetTester tester) async {

      // Inicia la aplicación.
      await tester.pumpWidget(const MyApp());

      // Espera a que termine de cargar.
      await tester.pumpAndSettle();

      expect(
        find.text('Hola, Mile 👋'),
        findsOneWidget,
      );
    },
  );
}