import 'package:flutter/material.dart';
import 'package:fresh_fruit/language/LanguagesManager.dart';
import 'package:fresh_fruit/model/address/AddressCity.dart';
import 'package:fresh_fruit/model/address/AddressDistricts.dart';
import 'package:fresh_fruit/model/address/AdressWards.dart';
import 'package:fresh_fruit/theme/AppColor.dart';
import 'package:fresh_fruit/theme/AppDimen.dart';

class DropDownDistricts extends StatefulWidget {
  final List<District> districts;
  final Function(District) callback;
  final District? district;

  DropDownDistricts(
      {required Key key,
      this.district,
      required this.districts,
      required this.callback})
      : super(key: key);

  @override
  DropDownDistrictsState createState() => DropDownDistrictsState();
}

class DropDownDistrictsState extends State<DropDownDistricts> {
  District? district;
  List<Ward> wards = [];

  List<District> get listItems => widget.districts;
  var temp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: AppColor.grey)),
      child: DropdownButton<District>(
          value: widget.district ?? district,
          hint: Text(
            locale.language.DELIVERY_ADDRESS_SELECT_DISTRICT,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
          ),
          underline: Container(
            color: Colors.transparent,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          isExpanded: true,
          onChanged: (District? newValue) {
            if (newValue != null) {
              widget.callback(newValue);
            }
          },
          items: listItems.map(
            (value) {
              return DropdownMenuItem<District>(
                value: value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(value.name ?? ""),
                    Icon(
                      Icons.check,
                      color: (value.name == district?.name)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    )
                  ],
                ),
              );
            },
          ).toList()),
    );
  }
}

class DropDownWards extends StatefulWidget {
  final List<Ward> wards;
  final Ward? ward;
  final Function(Ward) onChange;
  final Function(List<Ward>) callback;

  DropDownWards(
      {required Key key,
      required this.onChange,
      this.ward,
      required this.wards,
      required this.callback})
      : super(key: key);

  @override
  DropDownWardsState createState() => DropDownWardsState();
}

class DropDownWardsState extends State<DropDownWards> {
  Ward? ward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimen.space8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: AppColor.grey)),
      child: DropdownButton<Ward>(
        underline: Container(
          color: Colors.transparent,
        ),
        value: widget.ward ?? ward,
        hint: Text(
          locale.language.DELIVERY_ADDRESS_SELECT_WARD,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w600,
              ),
        ),
        icon: Icon(Icons.keyboard_arrow_down),
        style: TextStyle(color: Colors.black),
        isExpanded: true,
        onChanged: (Ward? newValue) {
          if (newValue != null) {
            widget.onChange(newValue);
          }
        },
        items: widget.wards.map(
          (value) {
            return DropdownMenuItem<Ward>(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(value.name ?? ""),
                  Icon(
                    Icons.check,
                    color: (value.name == ward?.name)
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  )
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class DropDownCities extends StatefulWidget {
  final List<City> cities;
  final Function(List<District>) getDistrictsCallback;
  final Function(City) callback;
  final City? city;

  const DropDownCities(
      {required Key key,
      this.city,
      required this.cities,
      required this.getDistrictsCallback,
      required this.callback})
      : super(key: key);

  @override
  DropDownCitiesState createState() => DropDownCitiesState();
}

class DropDownCitiesState extends State<DropDownCities> {
  City? city;
  List<District> districts = [];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<City>(
      onTap: () {},
      value: widget.city,
      hint: Text(
        'Chọn Tỉnh / Thành phố',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      underline: Container(
        color: Colors.transparent,
      ),
      icon: Icon(Icons.keyboard_arrow_down),
      style: TextStyle(color: Colors.black),
      isExpanded: true,
      onChanged: (City? newValue) async {
        // await provider.getListDistrict(newValue.id.toString()).then((_) {
        //   widget.getDistrictsCallback(provider.districts);
        // });

        if (newValue != null) {
          widget.callback(newValue);
        }
      },
      items: widget.cities.map(
        (value) {
          return DropdownMenuItem<City>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(value.name ?? ""),
                Icon(
                  Icons.check,
                  color: (value.name == city?.name)
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                )
              ],
            ),
          );
        },
      )?.toList(),
    );
  }
}
