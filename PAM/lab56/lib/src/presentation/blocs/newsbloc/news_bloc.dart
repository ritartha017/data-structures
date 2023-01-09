import 'package:lab5/src/presentation/blocs/newsbloc/news_events.dart';
import 'package:lab5/src/presentation/blocs/newsbloc/news_states.dart';
import 'package:lab5/src/domain/models/article_model.dart';
import 'package:lab5/src/domain/models/featured_model.dart';
import 'package:lab5/src/data/repositories/news_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvents, NewsStates> {
  NewsRepository newsRepository;
  NewsBloc({required NewsStates initialState, required this.newsRepository})
      : super(initialState) {
    add(StartEvent());
  }

  @override
  Stream<NewsStates> mapEventToState(NewsEvents event) async* {
    if (event is StartEvent) {
      try {
        List<ArticleModel> articleList = [];
        List<FeaturedModel> featuredList = [];
        yield NewsLoadingState();
        articleList = await newsRepository.fetchNews();
        featuredList = await newsRepository.fetchFeatured();
        yield NewsLoadedState(articleList: articleList, featuredList: featuredList);
      } catch (e) {
        yield NewsErrorState(errorMessage: e as String);
      }
    }
  }
}
