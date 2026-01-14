import 'package:flutter_bloc/flutter_bloc.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(LoadingNews());
}
