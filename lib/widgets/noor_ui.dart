import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/noor_theme.dart';

class NoorPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const NoorPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = EdgeInsets.zero,
    this.color,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? NoorColors.panel) : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border ?? Border.all(color: NoorColors.gold.withOpacity(0.20)),
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      ),
    );
  }
}

class NoorPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;

  const NoorPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.showBack = true,
    this.onBack,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 58 : 68);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack && leading == null,
      leading: leading ??
          (showBack
              ? IconButton(
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                )
              : null),
      titleSpacing: showBack || leading != null ? 0 : 18,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: NoorColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9),
            ),
        ],
      ),
      actions: actions,
    );
  }
}

class NoorLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const NoorLogo({super.key, this.size = 34, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    final mark = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: NoorColors.panelRaised,
            borderRadius: BorderRadius.circular(size * 0.28),
            border: Border.all(color: NoorColors.gold),
          ),
          child: Icon(Icons.nightlight_round, color: NoorColors.goldBright, size: size * 0.58),
        ),
      ),
    );

    if (!showLabel) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Noor-e-Qalb', style: GoogleFonts.poppins(color: NoorColors.text, fontWeight: FontWeight.w700, fontSize: 14)),
            Text('NAMAZ & QURAN', style: GoogleFonts.poppins(color: NoorColors.gold, fontSize: 7, letterSpacing: 1.3, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class NoorSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry margin;

  const NoorSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(10, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(action!, style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class NoorSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const NoorSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        suffixIcon: const Icon(Icons.tune_rounded, size: 17),
      ),
    );
  }
}

class NoorIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const NoorIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: size * 0.48, color: color ?? NoorColors.goldBright),
      ),
    );
    if (backgroundColor == null) return button;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle, border: Border.all(color: NoorColors.gold.withOpacity(0.25))),
      child: button,
    );
  }
}

class NoorPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const NoorPill({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? NoorColors.gold : NoorColors.panelSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? NoorColors.gold : NoorColors.gold.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: selected ? NoorColors.background : NoorColors.goldBright),
            const SizedBox(width: 5),
          ],
          Text(label, style: GoogleFonts.poppins(color: selected ? NoorColors.background : NoorColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
    return onTap == null
        ? child
        : GestureDetector(onTap: onTap, child: child);
  }
}

class NoorProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const NoorProgressBar({super.key, required this.value, this.color = NoorColors.gold, this.height = 6});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: height,
        backgroundColor: NoorColors.background,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class NoorBottomDivider extends StatelessWidget {
  const NoorBottomDivider({super.key});

  @override
  Widget build(BuildContext context) => const Divider(color: Color(0x22FFFFFF), height: 20);
}
