import 'package:web_scraper/web_scraper.dart';

void initChaptersFoodListScrap() async {
  final rawUrl =
      'https://www.gbs.hs.kr/main/main.php?categoryid=05&menuid=04&groupid=02?%3E';
  final webScraper = WebScraper('https://www.gbs.hs.kr');
  final endpoint = rawUrl.replaceAll(r'https://www.gbs.hs.kr', '');
  if (await webScraper.loadWebPage(endpoint)) {
    final titleElements = webScraper.getElement(
        'div.wrapper_sub > div.container'
            '> table.calendar2'
            '> div.info1', []);
    print(titleElements);
    final titleList = <String>[];
    titleElements.forEach((element) {
      final title = element['title'];
      titleList.add('$title');
    });
    print("${titleList}asdas");
  } else {
    print('Cannot load url');
  }
}