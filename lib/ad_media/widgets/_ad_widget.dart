import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class AdWidget extends StatelessWidget {
  const AdWidget({
    super.key,
    required this.adContent,
  });

  final String adContent;

  dom.NodeList _parseHtml(String html) => parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;

  @override
  Widget build(BuildContext context) {
    final dom.NodeList nodes = _parseHtml(adContent);
    final dom.Element root = nodes.first as dom.Element;
    final String styles = root.attributes['style'] ?? '';
    final List<String> attributes = styles.split(';');

    List<int> flex = [];
    BoxDecoration decoration = const BoxDecoration(color: Colors.white);

    for (var a in attributes) {
      final List<String> style = a.split(':');
      final String name = style[0];
      final String value = style[1];
      if (name == 'border') {
        final List<String> border = value.split(' ');
        final double width = double.parse(border[0].replaceAll('px', ''));
        final Color color = Color(int.parse(border[2].replaceAll('#', ''), radix: 16));
        decoration = decoration.copyWith(border: Border.all(color: color, width: width));
      } else if (name == 'border-radius') {
        decoration = decoration.copyWith(borderRadius: BorderRadius.circular(double.parse(value.replaceAll('px', ''))));
      } else if (name == 'grid-template-columns') {
        final List<String> columns = value.split(' ');
        for (var c in columns) {
          final int? f = int.tryParse(c.replaceAll('fr', ''));
          if (f != null) {
            flex.add(f);
          }
        }
      } else if (name == 'background-color') {
        decoration = decoration.copyWith(color: Color(int.parse(value.replaceAll('#', ''), radix: 16)));
      }
    }
    return Container(
      decoration: decoration,
      child: Row(
        children: [
          for (var i = 0; i < flex.length; i++)
            Expanded(
              flex: flex[i],
              child: HtmlWidget(root.children[i].outerHtml),
            ),
        ],
      ),
    );
    return ColoredBox(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // return HtmlFlex(
          //   direction: Axis.horizontal,
          //   children: [
          //     HtmlWidget(
          //       '<div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/507b018b-b04e-51a1-b2e3-815901c07024.jpeg\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div>',
          //     ),
          //     HtmlWidget(
          //       '<div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Samsung galaxy Fold 6</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Điện thoại Samsung Galaxy Z Fold6 màn hình mỏng hơn, bộ camera mạnh mẽ, đa nhiệm siêu mượt.</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">38.000.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\"></span></div></div>',
          //     ),
          //   ],
          // );
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: HtmlWidget(
              adContent,
              enableCaching: true,
              customWidgetBuilder: (element) {
                if (element.localName == 'img') {
                  return Image.network(
                    element.attributes['src'] ?? '',
                    alignment: Alignment.center,
                    // width: width / 3,
                  );
                }
                return null;
              },
              customStylesBuilder: (element) {
                if (element.localName == 'div' && element.attributes['style']?.contains('display:grid') == true) {
                  // debugPrint('AdWidget element: ${element.attributes['style']}');
                  final List<String> attributes = element.attributes['style']!.split(';');
                  Map<String, String> styleMap = {};
                  for (String a in attributes) {
                    final List<String> style = a.split(':');
                    if (style[0] == 'display' && style[1] == 'grid') {
                      // styleMap['display'] = 'inline-block';
                      // styleMap['vertical-align'] = 'top';
                      styleMap['display'] = 'flex';
                      styleMap['flex-direction'] = 'row';
                      // styleMap['flex'] = '1';
                      // styleMap['flex-wrap'] = 'wrap';
                      // styleMap['justify-content'] = 'center';
                      // styleMap['align-items'] = 'center';
                      // styleMap['align-content'] = 'center';
                    } else if (style[0] == 'grid-template-columns') {
                      // styleMap['flex'] = '1';
                    } else {
                      styleMap[style[0]] = style[1];
                    }
                  }
                  return styleMap;
                } else if (element.localName == 'div' &&
                    element.attributes['style']?.contains('display:flex') == true &&
                    element.innerHtml.contains('img')) {
                  debugPrint('AdWidget element: ${element.attributes['style']}');
                  final List<String> attributes = element.attributes['style']!.split(';');
                  Map<String, String> styleMap = {'flex': '1'};
                  for (String a in attributes) {
                    final List<String> style = a.split(':');
                    if (style[0] == 'display' && style[1] == 'flex') {
                    } else if (style[0] == 'align-items') {
                      styleMap['align-items'] = 'left';
                    } else if (style[0] == 'justify-content') {
                      styleMap['justify-content'] = 'left';
                    } else {
                      styleMap[style[0]] = style[1];
                    }
                  }
                  return styleMap;
                } else if (element.localName == 'div' &&
                    element.attributes['style']?.contains('display:flex;flex-direction:column') == true) {
                  final List<String> attributes = element.attributes['style']!.split(';');
                  Map<String, String> styleMap = {'flex': '2'};
                  for (String a in attributes) {
                    final List<String> style = a.split(':');
                    styleMap[style[0]] = style[1];
                  }
                  return styleMap;
                }
                return null;
              },
            ),
          );
        },
      ),
    );
  }
}
