import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_state.dart';
import 'package:ahadith/data/models/hadith.dart';

import '../../../../business_logic/single_hadith_cubit/single_hadith_cubit.dart';

class HadithDetailedScreen extends StatefulWidget {
  const HadithDetailedScreen({super.key, required this.hadith});

  final Hadith hadith;

  @override
  State<HadithDetailedScreen> createState() => _HadithDetailedScreenState();
}

class _HadithDetailedScreenState extends State<HadithDetailedScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SingleHadithCubit>(context)
        .getHadith(hadithId: widget.hadith.id!);
    Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hadith.title!),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<SingleHadithCubit, SingleHadithState>(
        builder: (context, state) {
          if (state is SingleHadithLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          state.hadith.hadeeth! + state.hadith.attribution!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          state.hadith.grade!,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.deepPurple,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        Text(
                          ' حديث',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            text: 'التفسير : ',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                            children: [
                              TextSpan(
                                text: state.hadith.explanation!,
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'السند',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              state.hadith.reference!,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 17.sp,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'حسناً',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.deepPurple, width: 1)
                        ),
                        child: const Text(
                          'اظهار السند',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black87
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          } else if (state is SingleHadithLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SingleHadithError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
