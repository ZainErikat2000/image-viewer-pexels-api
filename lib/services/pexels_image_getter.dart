import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:josequal/models/image_model.dart';

class PexelsManager {
  Future<Map<String, dynamic>> getAllImages() async {
    try {
      http.Response response = await http.get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
          headers: {
            HttpHeaders.authorizationHeader:
                '3KwrzI30zX1YTlNCzBclTm2dxuN8Hm2fioHZu3JXf5pG0hOjlQnDKm6V'
          });
      return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  List<ImageModel> cleanResponse(Map<String, dynamic> data) {
    List<dynamic> photosData = data['photos'];

    List<ImageModel> photos = [];

    print(photosData.length);
    for (Map<String, dynamic> p in photosData) {
      try {
        ImageModel im = ImageModel.fromJson(p);
        photos.add(im);
      } catch (e) {
        e.toString();
      }
    }

    return photos;
  }
}
