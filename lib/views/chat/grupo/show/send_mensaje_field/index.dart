import 'package:flutter/material.dart';

class SendMensajeField extends StatefulWidget {
  final TextEditingController mensajeController;
  final FocusNode mensajeFocusNode;
  final bool sending;
  final Function enviarMensaje;

  const SendMensajeField({
    Key key,
    @required this.mensajeController,
    @required this.mensajeFocusNode,
    @required this.sending,
    @required this.enviarMensaje,
  }) : super(key: key);

  @override
  _SendMensajeFieldState createState() => _SendMensajeFieldState();
}

class _SendMensajeFieldState extends State<SendMensajeField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.mensajeController,
              focusNode: widget.mensajeFocusNode,
              maxLength: 5000,
              decoration: InputDecoration(
                hintText: 'Mensaje',
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (val) =>
                  val.isEmpty || widget.sending ? null : widget.enviarMensaje(),
              onChanged: (val) {
                if (mounted) setState(() {});
              },
            ),
          ),
          Material(
            color: Colors.transparent,
            child: widget.sending
                ? SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed:
                        widget.mensajeController.text.isEmpty || widget.sending
                            ? null
                            : widget.enviarMensaje,
                  ),
          ),
        ],
      ),
    );
  }
}
