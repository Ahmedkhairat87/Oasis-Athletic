import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/drawer/widgets/gallery/album_photos.dart';
import 'package:oasisathletic/ui/drawer/widgets/gallery/provider/cart_provider.dart';
import '../../core/reusable_components/app_background.dart';
import 'package:provider/provider.dart';


class Gallery extends StatelessWidget {
  static const routeName = '/gallery';

  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().cart.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Photos Gallery'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Stack(
          children: [
            const Center(child: Icon(Icons.shopping_cart)),
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => Navigator.pushNamed(context, '/cart'),
      ),
      body: AppBackground(
        child: GridView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: albums.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25.w,
            mainAxisSpacing: 30.h,
          ),
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlbumPhotos(albumName: albums[i]),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.photo_album,
                      size: 60.sp, color: Colors.blue),
                  SizedBox(height: 10.h),
                  Text(albums[i], textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

const albums = [
  'Kermesse',
  'After School',
];