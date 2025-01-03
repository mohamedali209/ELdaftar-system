import 'package:aldafttar/features/daftarview/presentation/view/widgets/buy_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sell_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/titles_daftar.dart';
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_cubit.dart';
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_state.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesDftarBody extends StatelessWidget {
  const EmployeesDftarBody({super.key});

  Future<String> _fetchEmployeeName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .get();
      return doc['name'] ?? 'User';
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesitemCubit, EmployeesitemState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Positioned image background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Element.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 100,
              ),
            ),
            // Content after the image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomScrollView(
                slivers: [
                  // Employee greeting
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () async{
                           await FirebaseAuth.instance.signOut();
                            AppRouter.router.go(AppRouter.kloginview);
                          },
                          child: Text(
                            'تسجيل الخروج',
                            style: Appstyles.regular12cairo(context)
                                .copyWith(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: FutureBuilder<String>(
                            future: _fetchEmployeeName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return  Text(
                                  'اهلا...',
                                      style: Appstyles.regular25(context)
                                        .copyWith(fontSize: 30),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                );
                              } else if (snapshot.hasError) {
                                return const Text(' اهلا,  User');
                              } else {
                                final name = snapshot.data ?? 'User';
                                return Text('اهلا, $name',
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: Appstyles.regular25(context)
                                        .copyWith(fontSize: 30));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      thickness: 2,
                      indent: 150,
                      endIndent: 150,
                      color: Color(0xffF7EAD1),
                    ),
                  ),
                  // Sell Section
                  const SliverToBoxAdapter(
                    child: TitleSelling(),
                  ),
                  SliverToBoxAdapter(
                    child: SellingWidget(
                      onItemAdded: (newItem) {
                        context
                            .read<EmployeesitemCubit>()
                            .addSellingItem(newItem);
                      },
                      items: state.sellingItems,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 15),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      thickness: 2,
                      indent: 150,
                      endIndent: 150,
                      color: Color(0xffF7EAD1),
                    ),
                  ),
                  // Buy Section
                  const SliverToBoxAdapter(
                    child: TitleBuying(),
                  ),
                  SliverToBoxAdapter(
                    child: BuyingWidget(
                      onItemAdded: (newItem) {
                        context
                            .read<EmployeesitemCubit>()
                            .addBuyingItem(newItem);
                      },
                      items: state.buyingItems,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      color: Color.fromARGB(255, 114, 110, 110),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}