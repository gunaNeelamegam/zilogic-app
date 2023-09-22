import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/common/common.dart';
import 'package:zilogic/constants/constants.dart';
import 'package:zilogic/features/zconnect/controller/zconnect_controller.dart';
import 'package:zilogic/features/zconnect/view/AddBlogView.dart';
import 'package:zilogic/features/zconnect/view/zconnect_card.dart';
import 'package:zilogic/models/zconnect_model.dart';
import 'package:zilogic/theme/theme.dart';

class ZConnectView extends ConsumerStatefulWidget {
  const ZConnectView({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const ZConnectView());

  @override
  ConsumerState<ZConnectView> createState() => _ZConnectViewState();
}

class _ZConnectViewState extends ConsumerState<ZConnectView> {
  final AppBar appBar = UIConstants.appBar(
    titleImage: AssetsConstants.zconnectProfileImage,
  );

  late TextEditingController searchController;
  bool isShowUsers = false;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(AddBlogViewWidget.route());
              },
              child: const Icon(
                Icons.add,
                size: 25,
              ),
            ),
          )
        ],
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search Blog\'s',
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(getSearchByNameProvider(searchController.text)).when(
                data: (blogs) {
                  return ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final blog = blogs[index];
                      return ZConnectCard(blog: blog);
                    },
                  );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
          : ref.watch(getBlogProvider).when(
              data: (blogs) {
                return ref.watch(getLatestBlogProvider).when(
                    data: (data) {
                      if (data.events.contains(
                          "databases.*.collections.${AppwriteConstants.zconnectCollection}.documents.*.create")) {
                        ZConnectModel blog;
                        (() async {
                          blog = await ZConnectModel.fromMap(data.payload);
                          blogs.insert(0, blog);
                        })();
                      }
                      if (data.events.contains(
                          "databases.*.collections.${AppwriteConstants.zconnectCollection}.documents.*.update")) {
                        final startingPoint =
                            data.events[0].lastIndexOf('documents.');
                        final endPoint = data.events[0].lastIndexOf('.update');
                        final blogId = data.events[0]
                            .substring(startingPoint + 10, endPoint);

                        var blog = blogs
                            .where((element) => element.id == blogId)
                            .first;

                        final blogIndex = blogs.indexOf(blog);
                        blogs.removeWhere((element) => element.id == blogId);
                        (() async {
                          blog = await ZConnectModel.fromMap(data.payload);
                        })();
                        blogs.insert(blogIndex, blog);
                      }
                      return ListView.builder(
                        itemCount: blogs.length,
                        itemBuilder: (context, index) {
                          return ZConnectCard(blog: blogs[index]);
                        },
                      );
                    },
                    error: ((error, stackTrace) =>
                        ErrorPage(error: error.toString())),
                    loading: () {
                      return ListView.builder(
                        itemCount: blogs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final blog = blogs[index];
                          return ZConnectCard(blog: blog);
                        },
                      );
                    });
              },
              error: (error, stackTrace) => ErrorPage(error: error.toString()),
              loading: () => const Loader()),
    );
  }
}
