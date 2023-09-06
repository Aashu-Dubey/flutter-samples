import 'package:flutter/widgets.dart';
import 'package:flutter_samples/models/samples.dart';
import 'package:flutter_samples/screens/samples_list_view.dart';

class AnimationSamplesList extends StatelessWidget {
  static const String route = '/animations';

  const AnimationSamplesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SamplesListView(
        title: "Animations",
        backEnabled: true,
        listData: SampleData.animationSamples);
  }
}
