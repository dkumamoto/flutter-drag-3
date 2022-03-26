import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _key = GlobalKey(); // declare a global key
  List<Offset> points = [];

  Offset getOffset(GlobalKey key) {
    RenderBox? rb = key.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) {
      return Offset.zero;
    }
    return rb.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(
        child: Listener(
          onPointerDown: (e) {
            RenderBox rb = context.findRenderObject() as RenderBox;
            Offset os = rb.localToGlobal(e.position);
            points = [];
            points.add(e.position);
            print('down ${e.position}, ${os}');
          },
          onPointerMove: (e) {
            points.add(e.position);
            setState(() {});
            print('move ${e.position.dx}, ${e.position.dy}');
          },
          onPointerUp: (e) {
            points.add(e.position);
            setState(() {});
            print('up ${e.position.dx}, ${e.position.dy}');
          },
          child: CustomPaint(
            key: _key,
            painter: PathPainter(getOffset(_key), points),
            child: Container(
              width: screenWidth,
              height: screenWidth,
              color: Colors.black12,
            ),
          ),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  List<Offset> points;
  final Offset _offset;
  Path path = Path();

  PathPainter(this._offset, this.points) {
    print('$_offset');
    if (points.isEmpty) return;
    Offset origin = points[0];
    path.moveTo(origin.dx - _offset.dx, origin.dy - _offset.dy);
    for (Offset o in points) {
      path.lineTo(o.dx - _offset.dx, o.dy - _offset.dy);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // todo - determine if the path has changed
  }
}
