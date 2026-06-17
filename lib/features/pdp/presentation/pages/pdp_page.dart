import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pdp_bloc.dart';

class PdpPage extends StatelessWidget {
  final int productId;

  const PdpPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<PdpBloc, PdpState>(
        listenWhen: (prev, curr) {
          if (prev is PdpLoaded && curr is PdpLoaded) {
            return prev.addToBagMessage != curr.addToBagMessage;
          }
          return false;
        },
        listener: (context, state) {
          if (state is PdpLoaded && state.addToBagMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.addToBagMessage!)));
          }
        },
        child: SizedBox.shrink(),
      ),
    );
  }
}
