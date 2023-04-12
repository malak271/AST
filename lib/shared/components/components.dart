import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pie_chart/pie_chart.dart';


Widget DefaultButton({
  double width = double.infinity,
  // Color backgroundColor = HexColor('40A76A'),
  required Function function,
  required String text,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: HexColor('40A76A'),
      ),
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

Widget DeafautlFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validator,
  bool isPassword = false,
  required String text,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  Function? onTap,
  Function? onChange,
  Function? onSubmit,
}) =>
    TextFormField(
      onChanged: (value) => onChange!(value),
      validator: validator,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
            onPressed: () {
              suffixPressed!();
            },
            icon: Icon(suffix)),
      ),
      onTap: () => onTap!(),
      onFieldSubmitted: (value) => onSubmit!(value),
    );


void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

Widget DefaultTextFormField(
{
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validator,
  bool isPassword = false,
  required String text,
}
    )=>TextFormField(
  controller: controller,
  keyboardType:type,
  validator: validator,
  obscureText: isPassword,
  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: HexColor('F9F9F9'), width: 2.0),
    ),
    fillColor:HexColor('F9F9F9'),
    filled: true,
    labelText: text,
    labelStyle: TextStyle(
      color: HexColor('AAADB5'),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ),
    focusedBorder:OutlineInputBorder(
      borderSide: BorderSide(color:HexColor('40A76A'), width: 2.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
  ),
  // style: TextStyle(color:HexColor('40A76A')),
);

Widget buildGridItems(String title,String text,String image ,context)=>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: HexColor('F0F2F8'),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(15),
          child: Image(
            image: AssetImage(image),
          ),
        ),
        SizedBox(width: 15,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Text(
                title,
                style: TextStyle(
                    color: HexColor('8F8E8E'), fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2,),
              Text(
                text,
                style:Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 13,fontWeight:FontWeight.w400 ),
              )
            ],
          ),
        )
      ],
    );

Widget buildPointTitle(context,title)=>Row(
  children: [
    Image(image: AssetImage('assets/images/point.png')),
    SizedBox(width: 5,),
    Text(
        title, //Diet Plan Achievement
        style: Theme.of(context)
            .textTheme
            .bodyText1
    ),
  ],
);

Widget buildPieChart(context, Map<String, double> dataMap)=>PieChart(
  dataMap: dataMap,
  animationDuration: Duration(milliseconds: 800),
  chartLegendSpacing: 32,
  chartRadius: MediaQuery.of(context).size.width / 3.2,
  initialAngleInDegree: 0,
  chartType: ChartType.ring,
  ringStrokeWidth: 32,
  centerText: '2026 \n Kcals',
  colorList: [
    Colors.blue,
    Colors.green,
    HexColor('F0F2F8'),
  ],
  baseChartColor: Colors.white,
  legendOptions: LegendOptions(
    showLegendsInRow: true,
    legendPosition: LegendPosition.bottom,
    showLegends: true,
    legendTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  chartValuesOptions: ChartValuesOptions(
    showChartValueBackground: true,
    showChartValues: false,
    showChartValuesInPercentage: false,
    showChartValuesOutside: false,
    decimalPlaces: 1,
  ),
);



