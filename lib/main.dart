import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(SpookyHalloweenGame());
}

class SpookyHalloweenGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Halloween Game',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SpookyGameScreen(),
    );
  }
}

class SpookyGameScreen extends StatefulWidget {
  @override
  _SpookyGameScreenState createState() => _SpookyGameScreenState();
}

class _SpookyGameScreenState extends State<SpookyGameScreen>
    with SingleTickerProviderStateMixin {
  final random = Random();
  bool gameWon = false;
  String correctItem = '';
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<String> spookyItems = [
    'assets/image/ghost.svg',
    'assets/image/pumpkin.svg',
    'assets/image/bat.svg'
  ];

  @override
  void initState() {
    super.initState();
    _startBackgroundMusic();
    _assignCorrectItem();
  }

  void _startBackgroundMusic() async {
    await audioPlayer.play(AssetSource('sounds/background.mp3'), volume: 0.5);
  }

  void _assignCorrectItem() {
    correctItem = spookyItems[random.nextInt(spookyItems.length)];
  }

  void _onItemTapped(String item) {
    if (item == correctItem) {
      _playSuccessSound();
      setState(() {
        gameWon = true;
      });
    } else {
      _playJumpScareSound();
    }
  }

  void _playJumpScareSound() async {
    await audioPlayer.play(AssetSource('sounds/jumpscare.mp3'), volume: 1.0);
  }

  void _playSuccessSound() async {
    await audioPlayer.play(AssetSource('sounds/success.mp3'), volume: 1.0);
  }

  void _resetGame() {
    setState(() {
      gameWon = false;
      _assignCorrectItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find the Spooky Item!'),
      ),
      body: Stack(
        children: spookyItems.map((item) {
          return _buildAnimatedSpookyItem(item);
        }).toList()
          ..add(_buildGameMessage()),
      ),
    );
  }

  Widget _buildAnimatedSpookyItem(String item) {
    return Positioned(
      left: random.nextDouble() * MediaQuery.of(context).size.width * 0.8,
      top: random.nextDouble() * MediaQuery.of(context).size.height * 0.8,
      child: GestureDetector(
        onTap: () => _onItemTapped(item),
        child: SvgPicture.asset(
          item,
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  Widget _buildGameMessage() {
    if (gameWon) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You Found It!',
              style: TextStyle(
                fontSize: 40,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
