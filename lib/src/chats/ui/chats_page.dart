import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bootcamp_project/src/chats/ui/search_page.dart';

class ChatsPage extends StatelessWidget {
  final List<Chat> chats;

  ChatsPage({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red[300],
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
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SearchPage(chats: chats)));
                  },
                  color: Colors.white,
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                final chat = chats[index];
                final String avatar = chat.userAvatar ?? 'null';
                final String lastMessage = chat.lastMessage ?? '';
                final DateTime date = chat.date ?? DateTime.now();
                final String dateString = _formatDate(date);
                final String name = chat.userName;
                final String firstLetter = name.isNotEmpty ? name[0] : '';
                if (lastMessage.isEmpty) {
                  return Container();
                } else {
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            Colors.white,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            avatar != 'null' ? AssetImage(avatar) : null,
                        backgroundColor: Colors.transparent,
                        child: avatar == 'null'
                            ? Text(firstLetter,
                                style: TextStyle(color: Colors.white))
                            : null,
                      ),
                    ),
                    title: Text(chat.userName),
                    subtitle: Text(lastMessage),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (chat.date != null) Text(dateString),
                        if (chat.countUnreadMessages > 0)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.red[300],
                            ),
                            child: Text(
                              chat.countUnreadMessages.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {},
                  );
                }
              },
            ),
          ),
        );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
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
