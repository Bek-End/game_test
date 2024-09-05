import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:test_project/end_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final StopWatchTimer _stopWatchTimer;
  late final List<int> _list;
  late final int _level;
  final _rand = Random();
  final _levelDurations = [90, 150, 210];

  @override
  void initState() {
    _level = _rand.nextInt(3) + 4;
    _list = _genListItems();
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond:
          StopWatchTimer.getMilliSecFromSecond(_levelDurations[_level - 4]),
      onEnded: _gameOver,
    )..onStartTimer();
    super.initState();
  }

  void _onTap(int index) {
    final number = _list[index] + 1;
    _list
      ..removeAt(index)
      ..insert(index, number == 6 ? 1 : number);
    setState(() {});
  }

  void _restart() {
    _stopWatchTimer
      ..onStopTimer()
      ..onResetTimer()
      ..onStartTimer();
    _list
      ..clear()
      ..addAll(_genListItems());
    setState(() {});
  }

  List<int> _genListItems() {
    return List.generate(
      _level * _level,
      (index) => index % _level == 0 || index < _level ? 0 : 1,
    );
  }

  void _gameOver() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const EndScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _EdgeContainer(hasTopBorderRadius: true),
          Expanded(
            child: Center(
              child: SizedBox(
                width: _level * 44 + (_level - 1) * 16,
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: _level * _level,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _level,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 44,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox.shrink();

                    return InkWell(
                      onTap: () => _onTap(index),
                      child: Image.asset(
                        'assets/images/${_list[index]}.png',
                        height: 44,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          _EdgeContainer(
            hasBottomBorderRadius: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data ?? 0;
                    final displayTime = StopWatchTimer.getDisplayTime(value,
                        hours: false, milliSecond: false);
                    return Container(
                      height: 44,
                      width: 139,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC620C),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 11.7,
                            blurStyle: BlurStyle.inner,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'timer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: -3,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              displayTime,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: _restart,
                  child: Image.asset(
                    'assets/images/restart_btn.png',
                    height: 44,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EdgeContainer extends StatelessWidget {
  const _EdgeContainer({
    this.hasTopBorderRadius = false,
    this.hasBottomBorderRadius = false,
    this.child,
  });

  final bool hasTopBorderRadius;
  final bool hasBottomBorderRadius;
  final Widget? child;

  String get _board => hasBottomBorderRadius
      ? 'bottom'
      : hasTopBorderRadius
          ? 'top'
          : '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/${_board}_board.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: child,
        ),
      ],
    );
  }
}
