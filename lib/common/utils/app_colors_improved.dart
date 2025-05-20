import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors - Phong cách hiện đại, thời trang hơn
  static const Color primaryLight = Color(0xFF94B9AF); // Sage Green - Màu chính
  static const Color secondaryLight = Color(0xFFDCC0BD); // Dusty Rose - Màu phụ
  static const Color accentLight = Color(0xFFFBC8B5); // Peach - Màu nhấn
  static const Color backgroundLight = Color(0xFFF7F8FC); // Trắng ngả nhẹ
  static const Color cardLight = Color(0xFFFFFFFF); // Trắng
  static const Color textDarkLight = Color(0xFF2D3142); // Đậm hơn đen một chút
  static const Color textMediumLight = Color(0xFF83829A); // Màu xám đậm hơn
  static const Color textLightLight = Color(0xFFAFAFBD); // Xám nhạt
  static const Color dividerLight = Color(0xFFE5E5E9); // Màu xám nhạt hơn
  static const Color errorLight = Color(0xFFE98980); // Đỏ pastel
  static const Color successLight = Color(0xFF9CC5A1); // Xanh pastel
  static const Color warningLight = Color(0xFFE7C496); // Vàng pastel

  // Dark Theme Colors - Tối nhưng vẫn giữ tính thẩm mỹ
  static const Color primaryDark = Color(0xFF7A9E93); // Sage Green đậm hơn
  static const Color secondaryDark = Color(0xFFBFA29F); // Dusty Rose đậm hơn
  static const Color accentDark = Color(0xFFD9A997); // Peach đậm hơn
  static const Color backgroundDark = Color(0xFF1A1A22); // Đen xanh
  static const Color cardDark = Color(0xFF242430); // Đen xanh nhạt hơn
  static const Color textDarkDark = Color(0xFFF7F8FC); // Trắng ngả
  static const Color textMediumDark = Color(0xFFBDBDC7); // Xám sáng
  static const Color textLightDark = Color(0xFF83829A); // Xám đậm
  static const Color dividerDark = Color(0xFF31313D); // Đen xanh nhạt hơn nữa
  static const Color errorDark = Color(0xFFC57670); // Đỏ pastel đậm
  static const Color successDark = Color(0xFF82A587); // Xanh pastel đậm
  static const Color warningDark = Color(0xFFC2A47E); // Vàng pastel đậm

  // Gradient Colors - Cho hiệu ứng gradient
  static const List<Color> primaryGradientLight = [
    Color(0xFF94B9AF),
    Color(0xFFBFD3C1),
  ];
  static const List<Color> primaryGradientDark = [
    Color(0xFF7A9E93),
    Color(0xFF94B9AF),
  ];

  static const List<Color> secondaryGradientLight = [
    Color(0xFFDCC0BD),
    Color(0xFFF8EDEB),
  ];
  static const List<Color> secondaryGradientDark = [
    Color(0xFFBFA29F),
    Color(0xFFDCC0BD),
  ];

  // Shadow Colors
  static Color shadowColorLight = const Color(0xFF83829A).withOpacity(0.15);
  static Color shadowColorDark = Colors.black.withOpacity(0.2);

  // Glass Effect Colors
  static Color glassLight = Colors.white.withOpacity(0.6);
  static Color glassDark = const Color(0xFF242430).withOpacity(0.6);

  // Gradient box decoration cho background
  static BoxDecoration gradientBoxDecoration(bool isDarkMode) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:
            isDarkMode
                ? [backgroundDark, cardDark]
                : [backgroundLight, Color(0xFFEFF0F4)],
      ),
    );
  }
}
