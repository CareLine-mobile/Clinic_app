// lib/features/home/presentation/widget/shimmer/home_body_shimmer.dart

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/utils/app_size.dart';

/// Shimmer loading for home screen body content only (without header)
class HomeBodyShimmer extends StatelessWidget {
  const HomeBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: SizeApp.s50)),

          // Featured Clinics Shimmer
          SliverToBoxAdapter(
            child: _buildFeaturedClinicsShimmer(),
          ),

          // Nearby Clinics Shimmer
          SliverToBoxAdapter(
            child: _buildNearbyClinicsShimmer(),
          ),

          // All Clinics Header Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeApp.s20,
                vertical: SizeApp.s8,
              ),
              child: Text(
                "جميع العيادات",
                style: TextStyle(
                  fontSize: SizeApp.s24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // All Clinics List Shimmer
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeApp.s12),
                    child: _buildClinicCardShimmer(),
                  );
                },
                childCount: 5,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: SizeApp.s40)),
        ],
      ),
    );
  }

  Widget _buildFeaturedClinicsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Bone.text(words: 2, fontSize: 20),
          SizedBox(height: SizeApp.s16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: SizeApp.s12),
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Bone.square(
                          size: 180,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeApp.s12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Bone.text(words: 3),
                              SizedBox(height: SizeApp.s8),
                              const Bone.text(words: 2),
                              SizedBox(height: SizeApp.s8),
                              Row(
                                children: [
                                  const Bone.icon(size: 16),
                                  SizedBox(width: SizeApp.s4),
                                  const Bone.text(words: 1),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: SizeApp.s20),
        ],
      ),
    );
  }

  Widget _buildNearbyClinicsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Bone.text(words: 2, fontSize: 20),
          SizedBox(height: SizeApp.s16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: SizeApp.s12),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Bone.square(
                          size: 120,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeApp.s8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Bone.text(words: 2),
                              SizedBox(height: SizeApp.s4),
                              const Bone.text(words: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: SizeApp.s20),
        ],
      ),
    );
  }

  Widget _buildClinicCardShimmer() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(SizeApp.s12),
      child: Row(
        children: [
          Bone.square(size: 100, borderRadius: BorderRadius.circular(12)),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Bone.text(words: 3),
                const Bone.text(words: 2),
                Row(
                  children: [
                    const Bone.icon(size: 16),
                    SizedBox(width: SizeApp.s4),
                    const Bone.text(words: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}