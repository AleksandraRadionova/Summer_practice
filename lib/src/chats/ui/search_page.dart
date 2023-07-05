import 'package:flutter/material.dart';
import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'dart:math';

class SearchPage extends StatefulWidget {
  final List<Chat> chats;

  const SearchPage({Key? key, required this.chats}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredChats = widget.chats.where((chat) {
      final lowercaseQuery = _query.toLowerCase();
      final lowercaseUserName = chat.userName.toLowerCase();
      final lowercaseLastMessage = chat.lastMessage?.toLowerCase() ?? '';

      return lowercaseUserName.contains(lowercaseQuery) ||
          lowercaseLastMessage.contains(lowercaseQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: TextField(
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Поиск',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredChats.length,
        itemBuilder: (BuildContext context, int index) {
          final chat = filteredChats[index];
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
                      Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      Colors.white,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: avatar != 'null' ? AssetImage(avatar) : null,
                  backgroundColor: Colors.transparent,
                  child: avatar == 'null'
                      ? Text(firstLetter, style: TextStyle(color: Colors.white))
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
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
