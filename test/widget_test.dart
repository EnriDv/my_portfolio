import 'package:flutter_test/flutter_test.dart';

import 'package:my_portfolio/app/portfolio_app.dart';

void main() {
  testWidgets('home renders hero and opens cv page', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('ENRI DV'), findsOneWidget);
    expect(find.textContaining('Flutter Developer'), findsOneWidget);

    await tester.tap(find.text('Abrir CV'));
    await tester.pumpAndSettle();

    expect(find.text('Descargar PDF'), findsOneWidget);
  });
}
