import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/image_picker_providers.dart';

class ImagePickerScreen extends ConsumerWidget {
  const ImagePickerScreen({super.key});

  Future<String?> _inputTitle(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('タイトルを入力'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '例: 旅行、仕事、家族'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.year}/${dt.month}/${dt.day} "
        "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedImages = ref.watch(pickedImagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('タイトル付き写真一覧')),
      body: groupedImages.isEmpty
          ? const Center(child: Text('まだ写真がありません'))
          : ListView(
        children: groupedImages.entries.map((entry) {
          final title = entry.key;
          final images = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // タイトル
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 画像グリッド
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (_, i) {
                  final img = images[i];
                  return Column(
                    children: [
                      Expanded(
                        child: Image.file(
                          File(img.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(img.takenAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await _inputTitle(context);
          if (title != null && title.isNotEmpty) {
            ref.read(pickedImagesProvider.notifier).addImage(title);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
