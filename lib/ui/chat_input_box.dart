import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CommentInputBox extends StatefulWidget {
  final Function(String comment, PlatformFile? file) onSubmit;

  const CommentInputBox({super.key, required this.onSubmit});

  @override
  State<CommentInputBox> createState() => _CommentInputBoxState();
}

class _CommentInputBoxState extends State<CommentInputBox> {
  final TextEditingController controller = TextEditingController();
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  void submit() {
    if (controller.text.trim().isEmpty) return;

    widget.onSubmit(controller.text.trim(), selectedFile);

    controller.clear();
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// File preview
        if (selectedFile != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                Expanded(child: Text(selectedFile!.name, overflow: TextOverflow.ellipsis)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedFile = null;
                    });
                  },
                ),
              ],
            ),
          ),

        /// Input Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Attach Button
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  onPressed: pickFile,
                ),
              ),

              /// TextBox
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Write a comment...",
                    border: InputBorder.none,
                    filled: true, // important
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),

              /// Send Button
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: submit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
