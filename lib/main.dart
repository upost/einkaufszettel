import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:platform_icons/platform_icons.dart' as platform_icons;
import 'package:flutter/services.dart' show rootBundle;
import 'db.dart';
import 'article.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  List<dynamic> jsonList = jsonDecode(
    await rootBundle.loadString("assets/artikel.json"),
  );

  await DB.prepareArticles(
    jsonList.map((json) => Article.fromJson(json)).toList(),
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    List<Article> articles = DB.getAllArticles();
    return PlatformApp(
      home: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("Einkaufszettel"),
          leading: Image.asset("assets/einkaufszettel.png"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return PlatformListTile(
                    leading: Image.asset('assets/${articles[index].img}'),
                    title: Text(
                      articles[index].name,
                      style: TextStyle(fontSize: 24),
                    ),
                    trailing: PlatformIconButton(
                      icon: platform_icons.PlatformIcon(
                        articles[index].status == Article.statusNone
                            ? platform_icons.PlatformIcons.circle
                            : articles[index].status == Article.statusBuy
                            ? platform_icons.PlatformIcons.cart
                            : platform_icons.PlatformIcons.checkMark,
                      ),
                      onPressed: () {
                        DB.setNextStatus(articles[index]).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  );
                },
                itemCount: articles.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: PlatformTextButton(
                onPressed: () {
                  DB.resetAllStatus().then((value) {
                    setState(() {});
                  });
                },
                child: Text('Zurücksetzen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
