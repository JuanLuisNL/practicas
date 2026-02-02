import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagesController extends GetxController {
  // Lista de URLs de ejemplo (pueden reemplazarse por rutas locales)
  RxList<String> lstImages = [
    'https://picsum.photos/seed/1/800/600',
    'https://picsum.photos/seed/2/800/600',
    'https://picsum.photos/seed/3/800/600',
    'https://picsum.photos/seed/4/800/600',
    'https://picsum.photos/seed/5/800/600',
    'https://picsum.photos/seed/6/800/600',
  ].obs;

  RxSet<String> setFavorites = <String>{}.obs;
  late SharedPreferences oSP;
  String keyFavorites = 'list_favorite_images';

  @override
  Future<void> onInit() async {
    super.onInit();
    oSP = await SharedPreferences.getInstance();
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    List<String>? lstFavList = oSP.getStringList(keyFavorites);
    if (lstFavList != null) {
      setFavorites.addAll(lstFavList);
    }
  }

  void addImage(String url) {
    lstImages.add(url);
  }

  void removeImage(String url) {
    lstImages.remove(url);
    setFavorites.remove(url);
  }

  Future<void> toggleFavorite(String url) async {
    if (setFavorites.contains(url)) {
      setFavorites.remove(url);
    } else {
      setFavorites.add(url);
    }
    await oSP.setStringList(keyFavorites, setFavorites.toList());
  }

  void clearAll() {
    lstImages.clear();
    setFavorites.clear();
  }
}
