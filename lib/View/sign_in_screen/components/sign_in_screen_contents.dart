import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:libvary_app/size_config.dart';
import '../../../constants.dart';
import '../../contents.dart';


final List<String> errors = [];
final _formKey = GlobalKey<FormState>();

class SuffixIcon extends StatelessWidget {
  final String svgIcon;
  const SuffixIcon({super.key, required this.svgIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenHeight(18),
      ),
    );
  }
}

class FormErrors extends StatelessWidget {

  const FormErrors({super.key, required this.errors});

  final List<String> errors;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length, (index) => formErrorText(errors[index]))
    );
  }
  Row formErrorText (String error)
  {
    return Row(
      children: [
        SvgPicture.asset("assets/icons/Error.svg",
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenHeight(14),
        ),
        SizedBox(width: getProportionateScreenWidth(10),),
        Text(error),
      ],
    );
  }
}

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {

  String email = "";
  String password = "";
  bool remember = false;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailFormBody(),
          SizedBox(height: getProportionateScreenHeight(30),),
          passwordFormBody(),
          SizedBox(height: getProportionateScreenHeight(20),),
          FormErrors(errors : errors),
          SizedBox(height: getProportionateScreenHeight(20),),
          defaultButton(
              text: "Giriş Yap",
              press: ()
              {
                if(_formKey.currentState!.validate())
                {
                  _formKey.currentState!.save();
                }
              }
          ),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                setState(() {
                  remember = value!;
                });
                  },
              ),
              Text("Beni Hatırla"),
              Spacer(),
              Text("Şifremi Unuttum",style: TextStyle(decoration: TextDecoration.underline)),
              SizedBox(width: getProportionateScreenWidth(10),),
            ],
          )
        ],
      ),
    );


  }
  emailFormBody(){
    return TextFormField(
      onChanged: (value){
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          setState(() {
            errors.remove(kEmailNullError);
          });
        } else if (emailValidatorRegExp.hasMatch(value) && errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.remove(kInvalidEmailError);
          });}

        return null;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kEmailNullError)) {
          setState(() {
            errors.add(kEmailNullError);
          });
        } else if (value.length > 0 && !emailValidatorRegExp.hasMatch(value) && !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });}

        return null;
      },

      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration( //dekorasyon theme dosyasının içinde düzenlendi
        labelText: "Email",
        hintText: "Email'inizi giriniz",
        suffixIcon: SuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
    );
  }

  passwordFormBody(){

    return TextFormField(
      onSaved: (newValue) => password = newValue!,
      onChanged: (value){
        if (value.isNotEmpty && errors.contains(kPassNullError)) {
          setState(() {
            errors.remove(kPassNullError);
          });
        } else if (value.length >= 8 && errors.contains(kShortPassError)) {
          setState(() {
            errors.remove(kShortPassError);
          });}

        return null;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kPassNullError)) {
          setState(() {
            errors.add(kPassNullError);
          });
        }else if (value.length > 0 &&  value.length < 8 && !errors.contains(kShortPassError)) {
          setState(() {
            errors.add(kShortPassError);
          });}
        return null;
      },

      obscureText: true,
      decoration: InputDecoration( //dekorasyon theme dosyasının içinde düzenlendi
        labelText: "Şifre",
        hintText: "Şifrenizi giriniz",
        suffixIcon: SuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
    );

  }
}

class GoogleSign extends StatelessWidget {
  const GoogleSign({super.key, required this.icon, required this.press});
  final String icon;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
        height: getProportionateScreenHeight(45),
        width: getProportionateScreenWidth(45),
        decoration: BoxDecoration(color: Color(0xFFF5F6F9),shape: BoxShape.circle),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}

