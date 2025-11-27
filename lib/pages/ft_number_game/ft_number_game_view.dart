import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ft_number_game_logic.dart';

class FtNumberGameView extends GetView<FtNumberGameLogic> {
  const FtNumberGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${controller.modeTitle} - ${controller.level}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: controller.themeColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTimerAndNext(),
              Expanded(child: Center(child: _buildGrid())),
              _buildRestartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerAndNext() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.timer.value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: controller.primaryColor,
                ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  's',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Obx(() {
              final items = controller.gridItems;
              final crossAxisCount = controller.gridSize;
              final fontSizeMap = {
                3: 56.sp,
                4: 40.sp,
                5: 32.sp,
                6: 28.sp,
                7: 24.sp,
                8: 20.sp,
                9: 18.sp,
              };
              final fontSize = fontSizeMap[crossAxisCount] ?? 24.sp;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8.w,
                  crossAxisSpacing: 8.w,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return _AnimatedGridCell(
                    item: item,
                    fontSize: fontSize,
                    onTap: () => controller.onCellTap(item),
                  );
                },
              );
            }),
            Obx(
              () => controller.showError.value
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.nextTarget.value,
                              style: TextStyle(
                                fontSize: 200.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestartButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      child: GestureDetector(
        onTap: controller.restart,
        child: Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.refresh,
            color: controller.primaryColor,
            size: 40.sp,
          ),
        ),
      ),
    );
  }
}

class _AnimatedGridCell extends StatefulWidget {
  final String item;
  final double fontSize;
  final VoidCallback onTap;

  const _AnimatedGridCell({
    required this.item,
    required this.fontSize,
    required this.onTap,
  });

  @override
  State<_AnimatedGridCell> createState() => _AnimatedGridCellState();
}

class _AnimatedGridCellState extends State<_AnimatedGridCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<FtNumberGameLogic>();

    return Obx(() {
      final isClicked = logic.clickedItems.contains(widget.item);

      return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isClicked ? logic.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.item,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: isClicked ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
