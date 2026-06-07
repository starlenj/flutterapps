import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Core/Services/metadata_service.dart';
import 'package:todoapp/Core/Services/platform_service.dart';
import 'package:todoapp/Features/Bookmark/Repository/bookmark_repository.dart';

final metaServiceProvider = Provider<MetadataService>(
  (ref) => MetadataService(),
);
final platformServiceProvider = Provider<PlatformService>(
  (ref) => PlatformService(),
);

final bookmartRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(
    metadata: ref.watch(metaServiceProvider),
    platform: ref.watch(platformServiceProvider),
  );
});
