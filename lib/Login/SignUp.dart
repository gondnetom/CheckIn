import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../main.dart';
import 'google_sign_in.dart';


class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}
class _SignUpWidgetState extends State<SignUpWidget> {
  String SchoolName = "학교 고르기";
  List<String> DetailName = ["경기북과학고등학교",];

  final EULAText = '\na. 사용권의 범위: 사용권 허가자는 귀하가 소유하거나 관리하고 사용 규칙에서 허용하는 Apple 제품에서 사용권이 부여된 응용 프로그램을 사용할 수 있는 양도 불가능한 사용권을 귀하에게 부여합니다. 본 표준 EULA의 조건은 사용권이 부여된 응용 프로그램에서 액세스 가능하거나 구입되는 콘텐츠, 자료 또는 서비스를 규제하고, 사용권이 부여된 원본 응용 프로그램을 대체 또는 보완하기 위해 사용권 허가자가 제공하는 업그레이드를 규율합니다. 단, 업그레이드가 사용자 설정 EULA에 의거하여 제공되는 경우는 제외합니다. 사용 규칙에 제공된 경우를 제외하고 귀하는 동시에 여러 기기에서 사용하기 위해 네트워크를 통해 사용권이 부여된 응용 프로그램을 배포하거나 사용 가능하도록 설정할 수 없습니다. 귀하는 사용권이 부여된 응용 프로그램을 양도, 재배포 또는 재사용허가(sublicense)할 수 없습니다. 귀하가 Apple 기기를 제3자에게 판매하는 경우 Apple 기기에서 사용권이 부여된 응용 프로그램을 제거한 다음 판매해야 합니다. 귀하는 사용권이 부여된 응용 프로그램, 업데이트 또는 그 일부의 복사(본 사용권 및 사용 규칙이 허용하는 경우 제외), 역설계, 분해, 소스 코드 추출 시도, 수정 또는 파생 작업을 할 수 없습니다. 단, 앞서 언급한 제한이 관련 법률에 의해 금지되는 경우나 사용권이 부여된 응용 프로그램에 포함된 오픈 소스 구성요소의 사용을 규율하는 사용권 조건에 따라 허용될 수 있는 경우는 제외됩니다.'
      '\n\nb. 데이터 사용에 대한 동의: 귀하는 사용권 허가자가 사용권이 부여된 응용 프로그램과 관련된 소프트웨어 업데이트, 제품 지원 및 기타 서비스(있는 경우)를 용이하게 제공하기 위해 주기적으로 수집되는 기술 데이터 및 관련 정보(기기, 시스템 및 응용 프로그램 소프트웨어, 주변 기기 관련 기술 정보를 포함하나 이에 국한되지는 않음)를 수집하여 사용할 수 있다는 것에 동의합니다. 사용권 허가자는 사용자의 신원을 확인할 수 있는 경우를 제외하고 제품을 개선하고 귀하에게 서비스 또는 기술을 제공하기 위해 본 정보를 사용할 수 있습니다.'
      '\n\nc. 해지. 본 표준 EULA는 귀하 또는 사용권 허가자가 계약을 해지할 때까지 유효합니다. 귀하가 본 표준 EULA의 조건을 준수하지 않을 경우 본 EULA에 따른 귀하의 권리는 자동으로 해지됩니다.'
      '\n\nd. 외부 서비스. 사용권이 부여된 응용 프로그램을 사용하면 사용권 허가자 및/또는 타사 서비스 및 웹사이트(이하 통칭하여 그리고 개별적으로 "외부 서비스")에 액세스할 수 있습니다. 귀하는 외부 서비스 이용에 대한 위험은 전적으로 귀하의 책임이라는 것에 동의합니다. 사용권 허가자는 타사 외부 서비스의 콘텐츠 또는 정확성을 조사 또는 평가할 책임이 없으며 그런 타사 외부 서비스에 대해 어떠한 책임도 지지 않습니다. 사용권이 부여된 응용 프로그램 또는 외부 서비스에 의해 표시되는 데이터(금융, 의료 및 위치 정보를 포함하나 이에 국한되지는 않음)는 일반 정보 확인 용도로만 제공되는 것으로 사용권 허가자 또는 에이전트에 의해 보장되지 않습니다. 귀하는 본 표준 EULA의 조건을 위반하거나 사용권 허가자 또는 제3자의 지식재산권을 침해하는 어떠한 방식으로도 외부 서비스를 사용하지 않습니다. 귀하는 다른 사람이나 법인을 괴롭히거나, 학대하거나, 스토킹하거나, 협박하거나, 비방하는 어떠한 방식으로도 외부 서비스를 사용하지 않을 것이며, 사용권 허가자는 그러한 사용에 대해 어떠한 책임도 지지 않는다는 것에 동의합니다. 외부 서비스는 일부 언어로 또는 귀하의 본국에서 제공되지 않을 수도 있으며, 특정 위치에서 사용하는 것이 적절하지 않거나 이용하지 못할 수도 있습니다. 그러한 외부 서비스를 사용하기로 선택한 경우 관련 법률을 준수하는 것은 전적으로 귀하의 책임입니다. 사용권 허가자는 귀하에게 알리거나 귀하에 대한 어떠한 책임도 없이 언제든지 외부 서비스를 변경, 일시 중지, 제거, 비활성화 또는 액세스를 제한하거나 외부 서비스를 제한할 권리를 보유합니다.'
      '\n\ne. 무보증: 귀하는 사용권이 부여된 응용 프로그램의 사용에 대해 귀하가 전적으로 위험을 부담하며, 만족스러운 품질, 성능, 정확성 및 노력에 대한 모든 위험 역시 귀하가 감수한다는 사실을 명시적으로 인정하고 이에 동의합니다. 관련 법률에 따라 허용되는 최대 범위 내에서 사용권이 부여된 응용 프로그램과 사용권이 부여된 응용 프로그램에서 수행되거나 제공되는 모든 서비스는 어떠한 보증도 없이 모든 결함과 함께 "있는 그대로" 그리고 "이용 가능한 대로"의 상태로 제공됩니다. 또한 사용권 허가자는 이로써 상품성, 만족스러운 품질, 특정한 목적에의 적합성, 정확성, 문제없는 사용 권리, 제3자 권리에 대한 비침해 등에 대한 묵시적 보증 및/또는 조건을 포함하여(이에 국한되지 않음) 명시적이든 묵시적이든 또는 법규상의 것이든 사용권이 부여된 응용 프로그램 및 서비스와 관련한 모든 보증이나 조건을 부인합니다. 사용권 허가자는 사용권이 부여된 응용 프로그램에 포함된 기능 또는 사용권이 부여된 응용 프로그램에 의하여 수행되거나 제공되는 서비스가 귀하가 요구하는 사항을 충족시킨다는 점, 사용권이 부여된 응용 프로그램 또는 서비스의 작동이 방해되지 않거나 오류가 없을 것이라는 점, 사용권이 부여된 응용 프로그램 또는 서비스의 결함이 시정될 것이라는 점 등 귀하가 사용권이 부여된 응용 프로그램을 사용하는 데 대한 장애에 대하여 보증하지 않습니다. 사용권 허가자나 공인 담당자가 구두 또는 서면으로 제공한 정보나 조언이 있다고 해서 보증이 성립되는 것은 아닙니다. 사용권이 부여된 응용 프로그램 또는 서비스에 결함이 있는 것으로 판명될 경우, 필요한 서비스, 수리 혹은 시정 비용을 모두 귀하가 부담하여야 합니다. 특정 관할 지역에서는 묵시적 보증의 배제나 소비자에게 적용되는 성문법상의 권리에 대한 제한을 허용하지 않고 있는바, 위와 같은 보증의 배제 및 책임의 제한이 귀하에게 적용되지 않을 수 있습니다.'
      '\n\nf. 책임의 제한. 관련 법률에 의해 금지되지 않는 범위 내에서 사용권 허가자는 사용권이 부여된 응용 프로그램의 사용이나 사용불능으로 인해 발생하거나 그와 관련하여 발생하는 이익 상실의 손해, 데이터 손실, 영업 중단 또는 기타 상업적인 손해와 멸실 등을 포함(이에 국한되지 않음)하여 신체적 상해나 어떠한 형태의 부수적, 특별, 간접, 또는 결과적 손해에 대해 책임을 지지 않습니다. 이는 배상책임의 법리(계약, 불법행위 또는 기타)와 상관없으며, 사용권 허가자가 그러한 손해의 가능성에 대해 사전에 통보받았다 하더라도 마찬가지입니다. 특정 관할 지역에서는 신체적 상해나 부수적 혹은 결과적인 손해에 대한 책임의 제한을 허용하지 않으므로, 이러한 책임 제한이 귀하에게 적용되지 않을 수 있습니다. 귀하의 모든 손해(신체적 상해와 관련된 사건에서 적용되는 법률이 요구하는 경우를 제외함)에 대한 사용권 허가자의 총 책임 한도액은 어떠한 경우에도 미화 오십 달러(\$50.00)를 초과하지 않습니다. 위에서 언급한 해결 방법이 본질적 목적에 부합하지 않는다고 하더라도 상기의 책임 제한이 적용됩니다.'
      '\n\ng. 귀하는 미합중국 법률 및 사용권이 부여된 응용 프로그램을 취득한 관할 지역의 법률에 의해 승인받은 경우를 제외하고 사용권이 부여된 응용 프로그램을 사용하거나 수출 또는 재수출할 수 없습니다. 특히 사용권이 부여된 응용 프로그램은 (a) 미합중국과 통상금지 조치가 처해진 국가, 또는 (b) 미합중국 재무성의 특별 선정국 목록상의 개인이나 미합중국 상무성의 기피 인물 목록 또는 기피 단체 목록상의 개인 또는 단체(이에 국한되지 않음)로 수출되거나 재수출될 수 없습니다. 사용권이 부여된 응용 프로그램을 사용함에 의해 귀하는 귀하가 위에서 언급한 국가에 거주하지 않거나 그러한 목록상에 있지 않다는 것을 입증하고 보증해야 합니다. 또한 귀하는 핵무기, 미사일 혹은 생화학 무기 등의 개발, 기획, 제조 혹은 생산을 포함하나 이에 한하지 않고 미국법에 의하여 금지된 어떠한 목적을 위하여도 이러한 제품을 사용하지 않을 것에 동의합니다.'
      '\n\nh. 사용권이 부여된 응용 프로그램 및 관련 서류들은 "상업적인 품목"이며, "상업적인 품목"이라는 용어는 48 C.F.R. §2.101에 정의되어 있는바, 이는 "상업적 컴퓨터 소프트웨어" 및 "상업적 컴퓨터 소프트웨어 문서"로 구성되어 있고, 또한 이들 용어는 해당되는 대로 48 C.F.R. §12.212 또는 48 C.F.R. §227.7202에서 사용되고 있습니다. 48 C.F.R. §12.212 또는 48 C.F.R. §227.7202-1~227.7202-4 중 해당하는 조항에 따라, 상용 컴퓨터 소프트웨어와 상용 컴퓨터 소프트웨어 문서는 (a) 상용 품목으로서만 (b) 본 이용 약관에 따른 다른 모든 최종 사용자에게 부여되는 동일한 권리로 미국 정부 최종 사용자에게 사용권이 부여됩니다. 공개되지 않은 권리는 미합중국의 저작권법하에서 유보되어 있습니다.'
      '\n\ni. 다음 단락에 명시적으로 제공되어 있는 경우와 법률 저촉 규정을 제외하고 본 계약과 귀하와 Apple 간의 관계는 캘리포니아주 법에 따라 규율됩니다. 귀하와 Apple은 본 계약에 의거하여 발생하는 모든 분쟁이나 청구를 해결하기 위해 캘리포니아주 산타클라라 카운티 소재 법원의 속인적 배타적 관할권에 복속하는 데 동의합니다. (a) 귀하가 미국 시민이 아니고, (b) 미국 내에 거주하지 않고, (c) 미국에서 서비스에 액세스하지 않고, (d) 아래 식별된 국가 중 한 곳의 시민인 경우, 이로써 귀하는 본 계약에 의거하여 발생하는 모든 분쟁이나 청구는 법률 저촉 규정에 상관없이 아래에 명시된 준거법의 적용을 받으며, 해당 지역의 법률이 적용되는 아래 식별된 주, 도, 국가 소재의 법원의 비배타적 관할권에 취소할 수 없게 복속할 것에 동의합니다.'
      '\n\nj. CheckIn - 기숙 관리 는 어떠한 차별도 용인하지 않으며 다양성과 포용성을 중요시하는 커뮤니티입니다. 우리는 증오 발언이나 행동이 포함된 콘텐츠를 허용하지 않으며 CheckIn - 기숙 관리 플랫폼에서 삭제합니다. 우리는 증오 발언 관련 정책을 위반하거나 CheckIn - 기숙 관리 플랫폼 외에서 증오 발언에 연관된 계정을 일시적으로 정지하거나 사용 금지합니다.'
      '\n\n귀하가 유럽 연합 국가 또는 스위스, 노르웨이, 아이슬란드, 또는 한국에 거주하는 경우 준거법 및 법정지는 귀하의 주거지 소재 법률 및 법원입니다.'
      '\n\n국제물품매매계약에 관한 유엔 협약으로 알려진 법률은 본 계약에 적용이 명시적으로 배제됩니다.';

  Future Googlelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SchoolName', SchoolName);

    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.login();
  }
  Future Applelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SchoolName', SchoolName);

    var credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    await FirebaseAuth.instance.signInWithCustomToken(credential.identityToken);
  }

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff999999),
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        setState(() {
                          SchoolName = "학교 고르기";
                        });
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                    CupertinoButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: 320.0,
                  color: Color(0xfff7f7f7),
                  child:CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        SchoolName = DetailName[value];
                      });
                    },
                    itemExtent: 32.0,
                    children: const [
                      Text("경기북과학고등학교"),
                    ],
                  )
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/app_icon.png"),
              Text("CheckIn",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(height: 60,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    SchoolName = "경기북과학고등학교";
                  });
                  showPicker();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border:Border.all(
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${SchoolName}",style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  if(SchoolName == "학교 고르기"){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "학교를 골라주세요!",
                      ),
                    );
                    return;
                  }
                  if(isiOS){
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => EULA(0),
                    );
                  }else{
                    Googlelogin();
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border:Border.all(
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.google, color: Colors.red),
                        SizedBox(width: 5,),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 5,),
              isiOS ?
              GestureDetector(
                onTap: (){
                  if(SchoolName == "학교 고르기"){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "학교를 골라주세요!",
                      ),
                    );
                    return;
                  }

                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => EULA(1),
                  );

                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.apple,color: Colors.white),
                        SizedBox(width: 5,),
                        Text(
                          'Sign in with Apple',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                      ],
                    )
                ),
              ):
              SizedBox(height: 5,),
            ],
          )
        ],
      ),
    );
  }

  Widget EULA(int Type){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("라이선스 계약",style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon:Icon(CupertinoIcons.xmark,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text(EULAText),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
              onTap: (){
                if(Type ==0){
                  Navigator.pop(context);
                  Googlelogin();
                }else{
                  Navigator.pop(context);
                  Applelogin();
                }
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Center(
                    child: Text("동의",style: TextStyle(fontSize: 20,color: Colors.white)),
                  )
              ),
            ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                      boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                        blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                    ),
                    child: Center(
                      child: Text("거절",style: TextStyle(fontSize: 20,color: Colors.white)),
                    )
                ),
              ),
            ]
          )
        ],
      ),
    );
  }
}