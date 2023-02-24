import 'package:flutter/material.dart';
import 'package:flutter_samples/models/samples.dart';
import 'package:flutter_samples/screens/list/grid_item_view.dart';
import 'package:flutter_samples/screens/list/list_item_view.dart';

class SamplesListView extends StatefulWidget {
  const SamplesListView({super.key, this.title = "", this.backEnabled = true});

  final String title;
  final bool backEnabled;

  @override
  State<SamplesListView> createState() => _SamplesListViewState();
}

class _SamplesListViewState extends State<SamplesListView> {
  bool isGrid = false;

  void onSamplePress(int index) {
    var routeName = SampleData.sampleTypes[index].routeName;
    if (routeName != null) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(width: 0.3, color: Colors.grey.shade400)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.backEnabled
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          splashRadius: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => {})
                      : Container(width: 32),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      icon: const Icon(Icons.view_agenda),
                      splashRadius: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          isGrid = !isGrid;
                        });
                      }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isGrid
                  ? GridView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 992
                            ? 4
                            : MediaQuery.of(context).size.width > 768
                                ? 3
                                : 2,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                      ),
                      scrollDirection: Axis.vertical,
                      children: List<Widget>.generate(
                          SampleData.sampleTypes.length, (index) {
                        return GridItemView(
                            index: index,
                            onPressed: () => onSamplePress(index));
                      }),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      itemCount: SampleData.sampleTypes.length,
                      itemBuilder: (context, index) {
                        return ListItemView(
                            index: index,
                            onPressed: () => onSamplePress(index));
                      }),
            )
          ],
        ),
      ),
    );
  }
}
