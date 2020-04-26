import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:uuid/uuid.dart';


final dioInstance = new dio.Dio(dio.BaseOptions(
    baseUrl: 'https://wxardm.weixin.qq.com/',
    connectTimeout: 4000,
    receiveTimeout: 8000,
    headers: {
      'Host': 'wxardm.weixin.qq.com',
      'User-Agent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.3 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1 wechatdevtools/1.02.1912261 MicroMessenger/7.0.4 Language/zh_CN webview/',
      'content-type': 'application/x-www-form-urlencoded',
      'Referer':
          'https://servicewechat.com/wx9d7db7620ef5e23c/devtools/page-frame.html'
    },
    contentType: dio.Headers.formUrlEncodedContentType,
    responseType: dio.ResponseType.json));

final String cookie =
    '0Ji+vblf1ixZQ75MWHmm0kw2lpqz/HO9uPzyCk6dtXiHG7O5tp9rzyOOItOirdPVBKPZSpx6VPQzPUxI+9l+zQ==';

final uuid = Uuid();

Future _getApplist({String query = ''}) async {
  print('query: ${query}');
  dio.Response response =
      await dioInstance.post('/wxa-cgi/innersearch/subsearch', data: {
    'begid': '0',
    'longitude': '10',
    'latitude': '120.1',
    'client_version': '638058496',
    'query': query,
    'scene': '2001',
    'source': '0',
    'sub_type': '1',
    'search_scene': '1',
    'search_id': uuid.v1(),
    'device': '-1',
    'session_id': '123',
    'q_highlight': '',
    'cookie': cookie,
    'subsys_type': '1',
    'offset_buf': '',
    'sugid': '',
    'prefixsug': '',
    'sugbuf': '',
    'sugtype': '0',
    'sugpos': '0',
    'h5version': '65900619',
    'from_h5': 0
  });
  return response.data;
}

void _getSuggestionList({String query = ''}) async {
  dio.Response response =
      await dioInstance.post('/wxa-cgi/innersearch/subsearchgetsuggestio', data: {
    'begid': '0',
    'longitude': '10',
    'latitude': '120.1',
    'client_version': '638058496',
    'query': query,
    'scene': '2001',
    'source': '0',
    'sub_type': '1',
    'search_scene': '1',
    'search_id': uuid.v1(),
    'device': '-1',
    'session_id': '123',
    'q_highlight': '',
    'cookie': cookie,
    'subsys_type': '1',
    'offset_buf': '',
    'sugid': '',
    'prefixsug': '',
    'sugbuf': '',
    'sugtype': '0',
    'sugpos': '0',
    'h5version': '65900619',
    'from_h5': 1
  });
  return response.data;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        this.close(context, null);
      },
    );
  }

  // @override
  // TextInputType get keyboardType => TextInputType.number;

  @override
  String searchFieldLabel = "搜索小程序";

  Future _fetchPosts() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/posts/$query');
    final data = await json.decode(response.body);

    return data;
  }

  Future _fetchSuggestion() async {
    return Future.delayed(Duration(seconds: 1), () {
      return 1;
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    // if (int.parse(query) >= 100) {
    //   return Center(child: Text('请输入小于 100 的数字'));
    // }
    if (query.length == 0) {
      return null;
    }

    return FutureBuilder(
      future: _getApplist(query: query),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final res = snapshot.data;

          if (res['base'] != null && res['base']['ret'] == 0 && res['respBody'] != null) {
            // 后台返回了数据
            List<Widget> appItems = [];
            if (res['respBody']['items'] != null && res['respBody']['items'].length > 0) {
              for (int i = 0; i < res['respBody']['items'].length; ++i) {
                var item = res['respBody']['items'][i];
                if (item['extra_json'] != null) {
                  item['ext'] = json.decode(item['extra_json']);
                  if (item['ext']['cookie'] != null) {
                    // TODO 更新cookie， 应该是做滚动加载的
                  }
                } else {
                  item['ext'] = {};
                }
                
                appItems.add(ListTile(
                    title: Text(item['ext']['title'], maxLines: 1),
                    subtitle: Text(item['ext']['title'], maxLines: 3),
                    onTap: () {
                      String appid = item['appid'];
                      if (appid != null) {
                        
                      }
                    },
                ));

              }
            } else {
              appItems.add(ListTile(
                  title: Text('没有数据了', maxLines: 1),
                  subtitle: Text('没有数据了', maxLines: 3),
              ));
            }

            return ListView(
              children: appItems,
            );
          } else if (res.base != null && res.base.ret == 200003) {
            return Center(child: Text('cookie校验失败，需要重新请求cookie'));
          } else if (res.base != null && res.base.ret == -202){
            return Center(child: Text('202超时，重试一次'));
          } else {
            return Center(child: Text('加载失败'));
          }
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      // 拉取关键词联想
      return FutureBuilder(
        future: _fetchSuggestion(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                ListTile(title: Text('Suggest 01')),
                ListTile(title: Text('Suggest 02')),
                ListTile(title: Text('Suggest 03')),
                ListTile(title: Text('Suggest 04')),
                ListTile(title: Text('Suggest 05')),
              ],
            );
          }
          return Center(child: null);
        },
      );
    } else {
      // 拉取历史记录
      return FutureBuilder(
        future: _fetchSuggestion(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                ListTile(title: Text('History 01')),
                ListTile(title: Text('History 02')),
                ListTile(title: Text('History 03')),
                ListTile(title: Text('History 04')),
                ListTile(title: Text('History 05')),
              ],
            );
          }
          return Center(child: null);
        },
      );
    }
  }
}
