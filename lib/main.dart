import 'dart:convert';

import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final chats = await _loadChatList();

  runApp(MyApp(chats: chats));
}

Future<List<Chat>> _loadChatList() async {
  final result = <Chat>[];
  final rawData =
      jsonDecode(await rootBundle.loadString('assets/data/bootcamp.json'));
  for (final item in rawData['data']) {
    result.add(Chat.fromJson(item));
  }
  return result;
}

class MyApp extends StatelessWidget {
  final List<Chat> chats;

  MyApp({Key? key, required this.chats}) : super(key: key);

  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Telegram'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
                color: Colors.white,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index){
                final chat = chats[index];
                final String avatar =
                    chat.userAvatar ?? 'assets/images/default_avatar.png';
                final String lastMessage = chat.lastMessage ?? '';
                final DateTime date = chat.date ?? DateTime.now();
                final String dateString = _formatDate(date);
                final String name = chat.userName;
                final String firstLetter = name.isNotEmpty ? name[0] : '';
                if (lastMessage.isEmpty) {
                  return Container();
                } else {
                  return ListTile(
                    leading: avatar.isNotEmpty
                        ? CircleAvatar(backgroundImage: AssetImage(avatar))
                        : CircleAvatar(child: Text(firstLetter)),
                    title: Text(chat.userName),
                    subtitle: Text(lastMessage),
                    trailing: Text(dateString),
                    onTap: () {
                      // Обработчик нажатия на элемент списка
                  },
                );
                }
              },
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(date).inDays < 7) {
      switch (date.weekday) {
        case DateTime.monday:
          return 'Пн';
        case DateTime.tuesday:
          return 'Вт';
        case DateTime.wednesday:
          return 'Ср';
        case DateTime.thursday:
          return 'Чт';
        case DateTime.friday:
          return 'Пт';
        case DateTime.saturday:
          return 'Сб';
        case DateTime.sunday:
          return 'Вс';
        default:
          return '';
      }
    } else {
      return '${date.day.toString()} ${_getMonthName(date.month)}';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case DateTime.january:
        return 'янв';
      case DateTime.february:
        return 'фев';
      case DateTime.march:
        return 'мар';
      case DateTime.april:
        return 'апр';
      case DateTime.may:
        return 'май';
      case DateTime.june:
        return 'июн';
      case DateTime.july:
        return 'июл';
      case DateTime.august:
        return 'авг';
      case DateTime.september:
        return 'сен';
      case DateTime.october:
        return 'окт';
      case DateTime.november:
        return 'ноя';
      case DateTime.december:
        return 'дек';
      default:
        return '';
    }
  }
}
