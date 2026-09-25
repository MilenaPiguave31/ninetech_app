import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';

/// Miniatura de producto: muestra la imagen del producto si existe
/// (assets/products/...), y si no, cae de nuevo al emoji `icon`.
class ProductThumb extends StatelessWidget {
  final Product product;
  final double size;
  final double borderRadius;
  final double emojiFontSize;

  const ProductThumb({
    super.key,
    required this.product,
    this.size = 40,
    this.borderRadius = 10,
    this.emojiFontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final cover = product.coverImage;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        color: AppColors.pinkLight,
        child: cover != null
            ? Image.asset(
                cover,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(
                  product.icon,
                  style: TextStyle(fontSize: emojiFontSize),
                ),
              )
            : Text(
                product.icon,
                style: TextStyle(fontSize: emojiFontSize),
              ),
      ),
    );
  }
}

/// Botón grande estilo prototipo (.btn .btn-pink / .btn-outline / .btn-dark)
class KawaiiButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final KawaiiButtonStyle style;
  final bool isLoading;

  const KawaiiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = KawaiiButtonStyle.pink,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BoxBorder? border;
    switch (style) {
      case KawaiiButtonStyle.pink:
        bg = AppColors.pink;
        fg = Colors.white;
        break;
      case KawaiiButtonStyle.dark:
        bg = AppColors.dark;
        fg = Colors.white;
        break;
      case KawaiiButtonStyle.outline:
        bg = Colors.white;
        fg = AppColors.pink;
        border = Border.all(color: AppColors.pink, width: 1.5);
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: border,
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: fg),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

enum KawaiiButtonStyle { pink, outline, dark }

/// Campo de texto con etiqueta arriba (.input-label + .input-field)
class KawaiiTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final int maxLines;
  final VoidCallback? onTap;
  final bool readOnly;

  const KawaiiTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.dark)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onTap: onTap,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

/// Chip seleccionable estilo ".pill"
class KawaiiPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final Color lightColor;
  final VoidCallback onTap;

  const KawaiiPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = AppColors.pink,
    this.lightColor = AppColors.pinkLight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

/// Muestra un diálogo de éxito reutilizable (confirmaciones)
Future<void> showKawaiiSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  String emoji = '🌸',
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: AppColors.dark),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message,
              style: const TextStyle(fontSize: 12, color: AppColors.gray),
              textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Aceptar',
              style: TextStyle(
                  color: AppColors.pink, fontWeight: FontWeight.w800)),
        ),
      ],
    ),
  );
}
