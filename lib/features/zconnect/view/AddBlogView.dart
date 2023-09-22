import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/core/utils.dart';
import 'package:zilogic/features/auth/controller/auth_controller.dart';
import 'package:zilogic/features/auth/widgets/auth_field.dart';
import 'package:zilogic/features/zconnect/controller/zconnect_controller.dart';
import 'package:zilogic/theme/theme.dart';

class AddBlogViewWidget extends ConsumerStatefulWidget {
  const AddBlogViewWidget({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const AddBlogViewWidget(),
      );
  @override
  ConsumerState<AddBlogViewWidget> createState() => AddBlogView();
}

class AddBlogView extends ConsumerState<AddBlogViewWidget> {
  late TextEditingController _controller;
  late TextEditingController _authorController;

  late String filePath;

  bool _dragging = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _authorController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void onUploadBlog() {
    if (_controller.text.trim().isNotEmpty &&
        _authorController.text.trim().isNotEmpty &&
        filePath.isNotEmpty) {
      final currentUser = ref.read(currentUserDetailsProvider).value!;
      ref.read(zconnectControllerProvider.notifier).uploadBlog(
          blogFile: File(filePath),
          authorName: _authorController.text,
          title: _controller.text,
          currentUserId: currentUser.uid,
          context: context);
      Navigator.pop(context);
      return;
    }
    showSnackBar(context, "please provide all the required field's");
  }

  Future<dynamic> getBlogFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
        allowMultiple: false,
        dialogTitle: "Ziligic Blog Upload",
        onFileLoading: (FilePickerStatus status) {
          print(status);
        });
    print(result);
    if (result == null) {
      return;
    }
    if (kIsWeb) {
      filePath = "";
      return;
    }
    filePath = result.files.map((e) => e.path!).toSet().first;
    print(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Zconnect Blog Upload ",
          style: TextStyle(
            color: Pallete.orangeColor,
            letterSpacing: 1,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              onPressed: onUploadBlog,
              icon: const Icon(
                Icons.save,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(children: [
          AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            duration: const Duration(milliseconds: 1000),
            child: Column(
              children: [
                AuthField(
                  controller: _controller,
                  hintText: "Title ",
                  isPassword: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthField(
                  controller: _authorController,
                  hintText: "Author Name ",
                  isPassword: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                DropTarget(
                  onDragDone: (details) {
                    if (details.files.isEmpty) {
                      return;
                    }
                    setState(() {
                      if (details.files.first.name.contains(".md")) {
                        filePath = details.files.first.path;
                        return;
                      } else {
                        showSnackBar(
                            context, "Please Provide only  markdown file");
                      }
                    });
                  },
                  onDragEntered: (details) {
                    setState(() {
                      _dragging = true;
                    });
                  },
                  onDragExited: (details) {
                    setState(() {
                      _dragging = false;
                    });
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height / 4,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: _dragging
                                ? Colors.orange
                                : Pallete.backgroundColor,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: getBlogFiles,
                              child: const Text(
                                "click or drag and drop image ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
