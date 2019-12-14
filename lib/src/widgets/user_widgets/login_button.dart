import 'package:flutter/material.dart';
import '../../blocs/user_provider.dart';

class LogInButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserProvider.of(context);
    
    return StreamBuilder(
      stream: bloc.clientState,
      builder: (context,AsyncSnapshot<bool> snapshot){
        if(!snapshot.hasData){
          return Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.red,),
          );
        }
        
        if(snapshot.data){
          return IconButton(
            icon: Icon(Icons.verified_user),
            onPressed: null,
          );
        }

        return IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){},
          );
      },
    );
  }
}