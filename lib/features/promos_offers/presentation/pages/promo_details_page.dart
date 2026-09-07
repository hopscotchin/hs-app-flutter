import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/constants/strings/promos_offers_strings.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/promo_details_entity.dart';
import '../../domain/entities/promo_offer_entity.dart';
import '../bloc/promo_details_bloc.dart';
import '../widgets/promo_offer_card.dart';

/// Full detail for one promo, reached by the `hopscotch://offers?id=<promoId>`
/// deeplink that the offer list hands out as `promoTermsLink` ("See terms").
///
/// Read-only: applying/removing stays with the offers bottom sheet, so nothing
/// here can leave the cart stale.
class PromoDetailsPage extends StatelessWidget {
  final String? savingsTextFromCart;
  const PromoDetailsPage({super.key, this.savingsTextFromCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: PromosOffersStrings.offerDetails,
        titleKey: const ValueKey(PromoDetailsTestStrings.appBarTitle),
        backButtonKey: const ValueKey(PromoDetailsTestStrings.backButton),
      ),
      body: _Body(savingsTextFromCart: savingsTextFromCart),
    );
  }
}

class _Body extends StatelessWidget {
  final String? savingsTextFromCart;
  const _Body({this.savingsTextFromCart});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromoDetailsBloc, PromoDetailsState>(
      builder: (context, state) {
        switch (state.status) {
          case PromoDetailsStatus.initial:
          case PromoDetailsStatus.loading:
            return const _LoadingSkeleton();
          case PromoDetailsStatus.error:
            return _Message(
              text: state.errorMessage ?? CommonStrings.somethingWentWrong,
            );
          case PromoDetailsStatus.success:
            final details = state.details!;
            final item = details.item;
            if (item.title.isEmpty && details.hasNoContent) {
              return const _Message(
                text: PromosOffersStrings.offerNoLongerAvailable,
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              children: [
                // Same card as the offer list. No onApply/onRemove, so it
                // renders read-only — applying stays with the offers sheet.
                PromoOfferCard(
                  offer: item,
                  onAction: item.hasAction
                      ? () => ActionUrlHandler.navigate(context, item.actionUri)
                      : null,
                  codeKey: const ValueKey(PromoDetailsTestStrings.code),
                  titleKey: const ValueKey(PromoDetailsTestStrings.title),
                  descriptionKey: const ValueKey(
                    PromoDetailsTestStrings.description,
                  ),
                  validityKey: const ValueKey(
                    PromoDetailsTestStrings.validityText,
                  ),
                  savingsKey: const ValueKey(
                    PromoDetailsTestStrings.savingsText,
                  ),
                  ctaKey: const ValueKey(PromoDetailsTestStrings.ctaButton),
                  savingsTextFromCart: savingsTextFromCart,
                ),
                if (details.hasAbout) ...[
                  const SizedBox(height: _gapSection),
                  _AboutSection(text: details.about),
                ],
                // Separates the offer blurb from the numbered lists below;
                // pointless when there are no lists.
                if (details.hasAbout &&
                    (details.hasFaqs || details.hasTerms)) ...[
                  const SizedBox(height: _gapSection),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                ],
                if (details.hasFaqs) ...[
                  const SizedBox(height: _gapSection),
                  _FaqSection(faqs: details.faqs),
                ],
                if (details.hasTerms) ...[
                  const SizedBox(height: _gapSection),
                  _TermsSection(terms: details.terms),
                ],
              ],
            );
        }
      },
    );
  }
}

/// Stands in for the real layout while loading: one card-shaped block, then a
/// heading + body lines per section. Same paddings and gaps as the content it
/// replaces, so nothing jumps when the response lands.
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: const [
        LoadingShimmer(height: PromoOfferCard.approxHeight),
        SizedBox(height: _gapSection),
        _SectionSkeleton(lines: 2),
        SizedBox(height: _gapSection),
        _SectionSkeleton(lines: 3),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.lines});

  static const double _headingWidth = 160;
  static const double _headingHeight = 14;
  static const double _lineHeight = 12;
  static const BorderRadius _lineRadius = BorderRadius.all(Radius.circular(4));

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Aligned rather than sized directly: a ListView hands children tight
        // width constraints, which would stretch a fixed-width block.
        const Align(
          alignment: Alignment.centerLeft,
          child: LoadingShimmer(
            width: _headingWidth,
            height: _headingHeight,
            borderRadius: _lineRadius,
          ),
        ),
        for (var i = 0; i < lines; i++) ...[
          const SizedBox(height: _gapHeadingToBody),
          // Last line runs short, the way a wrapped paragraph ends.
          if (i == lines - 1)
            const Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.55,
                child: LoadingShimmer(
                  height: _lineHeight,
                  borderRadius: _lineRadius,
                ),
              ),
            )
          else
            const LoadingShimmer(
              height: _lineHeight,
              borderRadius: _lineRadius,
            ),
        ],
      ],
    );
  }
}

/// Gap between the card and every section below it, and between sections.
const double _gapSection = AppSpacing.lg; // 24

/// Heading → first item, and item → item, inside a section.
const double _gapHeadingToBody = 6;
const double _gapFaqItem = AppSpacing.sm; // 12
const double _gapTermsItem = 9;

TextStyle get _headingStyle =>
    AppTypographyV1.bodySmall.bold.textPrimary(); // 13, bold

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PromosOffersStrings.aboutTheOffer,
          key: const ValueKey(PromoDetailsTestStrings.aboutTitle),
          style: _headingStyle,
        ),
        const SizedBox(height: _gapHeadingToBody),
        Text(
          text,
          key: const ValueKey(PromoDetailsTestStrings.aboutText),
          style: AppTypographyV1.labelLarge.regular.textPrimary(),
        ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({required this.faqs});

  final List<PromoFaqEntity> faqs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PromosOffersStrings.frequentlyAskedQuestions,
          key: const ValueKey(PromoDetailsTestStrings.faqTitle),
          style: _headingStyle,
        ),
        for (final (i, faq) in faqs.indexed) ...[
          const SizedBox(height: _gapFaqItem),
          _FaqItem(faq: faq, index: i),
        ],
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.faq, required this.index});

  final PromoFaqEntity faq;
  final int index;

  @override
  Widget build(BuildContext context) {
    final base = '${PromoDetailsTestStrings.faqItem}_$index';
    final questionStyle = AppTypographyV1.labelLarge.medium.textPrimary();

    return _NumberedRow(
      key: ValueKey(base),
      number: index + 1,
      numberStyle: questionStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (faq.question.isNotEmpty)
            Text(
              faq.question,
              key: ValueKey(
                '${base}_${PromoDetailsTestStrings.faqQuestionSuffix}',
              ),
              style: questionStyle,
            ),
          if (faq.answer.isNotEmpty) ...[
            if (faq.question.isNotEmpty)
              const SizedBox(height: _gapHeadingToBody),
            Text(
              faq.answer,
              key: ValueKey(
                '${base}_${PromoDetailsTestStrings.faqAnswerSuffix}',
              ),
              style: AppTypographyV1.labelLarge.regular.textPrimary(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.terms});

  final List<String> terms;

  @override
  Widget build(BuildContext context) {
    final style = AppTypographyV1.labelLarge.regular.textPrimary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PromosOffersStrings.termsAndConditions,
          key: const ValueKey(PromoDetailsTestStrings.termsTitle),
          style: _headingStyle,
        ),
        for (final (i, term) in terms.indexed) ...[
          const SizedBox(height: _gapTermsItem),
          _NumberedRow(
            key: ValueKey('${PromoDetailsTestStrings.termsItem}_$i'),
            number: i + 1,
            numberStyle: style,
            child: Text(term, style: style),
          ),
        ],
      ],
    );
  }
}

/// "1." in a fixed gutter with the body hanging beside it, so wrapped lines
/// stay aligned with the text rather than sliding under the number.
class _NumberedRow extends StatelessWidget {
  const _NumberedRow({
    super.key,
    required this.number,
    required this.numberStyle,
    required this.child,
  });

  static const double _gutter = 18;

  final int number;
  final TextStyle numberStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _gutter,
          child: Text('$number.', style: numberStyle),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Text(
          text,
          key: const ValueKey(PromoDetailsTestStrings.errorText),
          textAlign: TextAlign.center,
          style: AppTypographyV1.bodySmall.regular.textSecondary(),
        ),
      ),
    );
  }
}
