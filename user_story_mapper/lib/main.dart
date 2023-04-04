import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';

void main() => runApp(const ReorderableApp());

final GlobalKey _draggableKey = GlobalKey();
const List<Item> _items = [
  Item(
      description: 'Item1 description',
      title: "Item1 title",
      uid: '1',
      votes: 1),
  Item(
      description: 'Item2 description',
      title: "Item2 title",
      uid: '2',
      votes: 2),
  Item(
      description: 'Item3 description',
      title: "Item3 title",
      uid: '3',
      votes: 3),
];

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _items[0].title,
      home: Scaffold(
          appBar: AppBar(title: const Text("User Story Mapper")),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StoryCard(storyData: Story.getEmptyObj()),
                  StoryCard(storyData: Story.getEmptyObj2()),
                  StoryCard(storyData: Story.getEmptyObj()),
                  StoryCard(storyData: Story.getEmptyObj2()),
                ]),
          )),
    );
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<ReorderableExample> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Container(
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < _items.length; index += 1)
            ListTile(
              key: Key('$index'),
              tileColor: Colors.red,
              title: Text('Item'),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12.0,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
      ),
      child: MenuListItem(
        title: item.title,
        description: item.description,
        votes: item.votes,
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem(
      {super.key, this.title = '', this.description = '', this.votes = 0});

  final String title;
  final String description;
  final int votes;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: 120,
                    width: 120,
                    child: StoryCard(
                        storyData: Story(
                            id: "1",
                            title: "title",
                            description: "description",
                            votes: 2,
                            potentialUsers: [PotentialUser.getEmptyObj()],
                            comments: null,
                            creatorId: 'creatorId')),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.0,
                        ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
  });

  final GlobalKey dragKey;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Card(
              child: Center(child: Text('Elevated Card')),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class Item {
  const Item(
      {required this.description,
      required this.title,
      required this.uid,
      required this.votes});
  final String description;
  final String title;
  final String uid;
  final int votes;
}
