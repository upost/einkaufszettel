import 'package:hive_ce/hive.dart';
import '../article.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Article>()])
class HiveAdapters {}
