// ignore_for_file: lines_longer_than_80_chars

/// Bundled mock response for PDP — mirrors the real `/v3/product/{id}` shape.
///
/// To enable mock mode, flip the toggle in [ProductDetailRepositoryImpl]:
///   static const bool _kUseMock = true;
///
/// To disable and use the live API:
///   static const bool _kUseMock = false;
library;

import '../../../domain/entities/product_detail_entity.dart';
import '../../../domain/entities/recommendations_entity.dart';
import '../../models/product_detail_model.dart';
import '../../models/recommendations_model.dart';

/// Lazily parsed entity — real model/entity code path is exercised.
ProductDetailEntity get pdpMockEntity =>
    ProductDetailModel.fromJson(_kPdpMockJson).toEntity();

RecommendationsEntity get pdpRecommendationsMockEntity =>
    RecommendationsModel.fromJson(_kRecommendationsMockJson).toEntity();

const Map<String, dynamic> _kRecommendationsMockJson = {
  'records': [
    {
      'id': 1317691,
      'name': '2-Pc Bow Jogger Set',
      'brandName': 'Hopscotch',
      'media': [
        {
          'mimeType': 'IMAGE',
          'url':
              'https://qastatic.hopscotch.in/fstatic/product/202006/1bda96d5-dc34-4a16-9e13-6373a59070a0_full.jpg?version=1592223869844',
          'height': 2100,
          'width': 1500,
        },
      ],
      'priceInfo': {
        'sellingPrice': '₹1,919',
        'mrp': '₹2,399',
        'discount': '30% OFF',
        'absoluteValue': 1919,
        'callout': 'Inclusive of all taxes',
      },
      'wishlistInfo': {'id': 301, 'isWishlisted': false, 'canWishlist': true},
      'soldOut': false,
      'colorVariants': '+2 Colours',
      'actionUri': 'hopscotch://product?id=1317691',
    },
    {
      'id': 1317692,
      'name': '2-Pc Bow Jogger Set',
      'brandName': 'Hopscotch',
      'media': [
        {
          'mimeType': 'IMAGE',
          'url':
              'https://qastatic.hopscotch.in/fstatic/product/202006/0a345ec0-0873-4267-b541-7b482cc42ee5_full.jpg?version=1592223870436',
          'height': 2100,
          'width': 1500,
        },
      ],
      'priceInfo': {
        'sellingPrice': '₹1,919',
        'mrp': '₹2,399',
        'discount': '30% OFF',
        'absoluteValue': 1919,
        'callout': 'Inclusive of all taxes',
      },
      'wishlistInfo': {'id': 302, 'isWishlisted': false, 'canWishlist': true},
      'soldOut': false,
      'colorVariants': '+2 Colours',
      'actionUri': 'hopscotch://product?id=1317692',
    },
    {
      'id': 1317693,
      'name': 'Floral Print Maxi Dress',
      'brandName': 'Hopscotch',
      'media': [
        {
          'mimeType': 'IMAGE',
          'url':
              'https://qastatic.hopscotch.in/fstatic/product/202006/1bda96d5-dc34-4a16-9e13-6373a59070a0_full.jpg?version=1592223869844',
          'height': 2100,
          'width': 1500,
        },
      ],
      'priceInfo': {
        'sellingPrice': '₹2,499',
        'mrp': '₹3,199',
        'discount': '22% OFF',
        'absoluteValue': 2499,
        'callout': 'Inclusive of all taxes',
      },
      'wishlistInfo': {'id': 303, 'isWishlisted': false, 'canWishlist': true},
      'soldOut': false,
      'colorVariants': '+3 Sizes',
      'actionUri': 'hopscotch://product?id=1317693',
    },
    {
      'id': 1317694,
      'name': 'Floral Print Maxi Dress',
      'brandName': 'Hopscotch',
      'media': [
        {
          'mimeType': 'IMAGE',
          'url':
              'https://qastatic.hopscotch.in/fstatic/product/202006/0a345ec0-0873-4267-b541-7b482cc42ee5_full.jpg?version=1592223870436',
          'height': 2100,
          'width': 1500,
        },
      ],
      'priceInfo': {
        'sellingPrice': '₹2,499',
        'mrp': '₹3,199',
        'discount': '22% OFF',
        'absoluteValue': 2499,
        'callout': 'Inclusive of all taxes',
      },
      'wishlistInfo': {'id': 304, 'isWishlisted': false, 'canWishlist': true},
      'soldOut': false,
      'colorVariants': '+3 Sizes',
      'actionUri': 'hopscotch://product?id=1317694',
    },
  ],
};

/// Raw JSON matching the `/v3/product/{id}` API contract.
const Map<String, dynamic> _kPdpMockJson = {
  'action': 'success',
  'offersList': {
    'data': [
      {
        'promoCode': 'OFF90',
        'header':
            'Get flat 10% off on order above ₹1000 and below ₹5000. what are you waiting for?',
        'description':
            'Add this promo code to get flat 10% off upto ₹100. Use code OFF90 at checkout. Valid till 31st July 2026.',
        'features': {'displayCoupon': true, 'copyCoupon': true},
      },
      {
        'promoCode': '10OFF',
        'header': 'Get flat 10% off',
        'description': 'Add this promo code to get flat 10% off upto ₹100',
        'features': {'displayCoupon': true, 'copyCoupon': true},
      },
      {
        'promoCode': 'FREESHIPNEW',
        'header': 'FREESHIPNEW',
        'description': 'FREESHIPNEW',
        'features': {'displayCoupon': true, 'copyCoupon': true},
      },
    ],
  },
  'banners': [
    {
      'id': 'banner_1',
      'actionUri': 'hopscotch://collection/summer',
      'position': 'top',
      'media': {
        'url': 'https://cdn.hopscotch.in/banners/summer.jpg',
        'mimeType': 'image/jpeg',
        'height': 200,
        'width': 1080,
      },
    },
  ],
  'product': {
    'id': 1317807,
    'soldOut': false,
    'hasSizeChart': true,
    'name': 'Striped Pant Set',
    'isServiceable': true,
    'isEddDifferentForSKUs': false,
    'isReturnInfoDifferentForSKUs': false,
    'isGift': false,
    'media': [
      {
        'mimeType': 'IMAGE',
        'height': 1000,
        'width': 1000,
        'url':
            'https://qastatic.hopscotch.in/fstatic/product/202006/1bda96d5-dc34-4a16-9e13-6373a59070a0_full.jpg?version=1592223869844',
      },
      {
        'mimeType': 'IMAGE',
        'height': 1000,
        'width': 1000,
        'url':
            'https://qastatic.hopscotch.in/fstatic/product/202006/0a345ec0-0873-4267-b541-7b482cc42ee5_full.jpg?version=1592223870436',
      },
    ],
    // 'visualCue': {
    //   'uiType':   'TEXT',
    //   'location': 'BottomLeft',
    //   'text': '3 LEFT',
    //   'textColor': '#333333',
    //   'backgroundColor': '#E5E5EA',
    // },
    'visualCue': {
      'uiType': 'IMAGE',
      'location': 'BottomLeft',
      'text': 'TRENDING',
      'textColor': '',
      'backgroundColor': '',
      'imageUrl': 'https://qastatic.hopscotch.in/fstatic/trending.svg',
    },
    'priceInfo': {
      'sellingPrice': '₹1,199',
      'mrp': '₹1,499',
      'discount': '20% OFF',
      'absoluteValue': 1199,
      'callout': 'Inclusive of all taxes',
    },
    'wishlistInfo': {'id': 232, 'isWishlisted': true, 'canWishlist': false},
    'colorVariants': {
      'mediaMetaData': {'width': 48, 'height': 68},
      'variants': [
        {
          'productId': 1317807,
          'isSelected': false,
          'mediaUrl':
              'https://static.hopscotch.in/fstatic/product/202604/0608821e-7f18-4b9c-b3cd-4e2f3186e512_full.jpg?version=1775125690032',
          'isStockAvailable': false,
        },
        {
          'productId': 1317808,
          'isSelected': false,
          'mediaUrl':
              'https://static.hopscotch.in/fstatic/product/202604/0608821e-7f18-4b9c-b3cd-4e2f3186e512_full.jpg?version=1775125690032',
          'isStockAvailable': true,
        },
      ],
    },
    'skus': [
      {
        'skuId': 'CNS-4907089',
        'title': '0-1 Y',
        'subTitle': 'Waist: 26 cm',
        'enable': true,
        'info': {'text': 'Only 3 Left!', 'textColor': '#E00000'},
        'priceInfo': {
          'sellingPrice': '₹1,199',
          'mrp': 'MRP:₹1,499',
          'discount': '20% OFF',
          'absoluteValue': 1199,
          'callout': 'Inclusive of all taxes',
        },
        'eddInfo': {
          'edd': 'Get it in 2-3 days',
          'orderSla': 'Usually ships within a day',
        },
        'skuAttributes': {'skuMrp': '₹1,149', 'size': '0-1 Y'},
      },
      {
        'skuId': 'CNS-4907090',
        'title': '1-2 Y',
        'subTitle': 'Waist: 28 cm',
        'enable': true,
        'priceInfo': {
          'sellingPrice': '₹2000',
          'mrp': 'MRP:₹2500',
          'discount': '20% OFF',
          'absoluteValue': 2000,
          'callout': 'Inclusive of all taxes',
        },
        'eddInfo': {
          'edd': 'Get it in 2-3 days',
          'orderSla': 'Usually ships within a day',
        },
        'skuAttributes': {'skuMrp': '₹2000', 'size': '1-2 Y'},
      },
      {
        'skuId': 'CNS-4907091',
        'title': '2-3 Y',
        'subTitle': 'Waist: 30 cm',
        'enable': false,
        'info': {'text': 'Out Of Stock', 'textColor': '#000000'},
        'priceInfo': {
          'sellingPrice': '₹1,199',
          'mrp': '₹1,499',
          'discount': '20% OFF',
          'absoluteValue': 1199,
          'callout': 'Inclusive of all taxes',
        },
      },
      {
        'skuId': 'CNS-4907092',
        'title': '3-4 Y',
        'subTitle': 'Waist: 32 cm',
        'enable': true,
        'priceInfo': {
          'sellingPrice': '₹1,199',
          'mrp': '₹1,499',
          'discount': '20% OFF',
          'absoluteValue': 1199,
          'callout': 'Inclusive of all taxes',
        },
        'eddInfo': {
          'edd': 'Get it in 3-5 days',
          'orderSla': 'Usually ships in 2 days',
        },
      },
    ],
    'eddInfo': {
      'edd': 'Get it in 2-3 days',
      'orderSla': 'Usually ships within a day',
    },
    'serviceGuarantee': [
      {
        'label': '7 Days Return',
        'icon': 'https://static.hopscotch.in/return-available.png',
      },
      {
        'label': '7 Days Exchange',
        'icon': 'https://static.hopscotch.in/exchange-available.png',
      },
      {
        'label': 'Cash On Delivery',
        'icon': 'https://static.hopscotch.in/cod-available.png',
      },
    ],
    'details': [
      {
        'tabName': 'Specification',
        'items': [
          {
            'type': 'skuValue',
            'span': 2,
            'displayKey': 'MRP',
            'fieldPath': 'skuAttributes.price',
            'displayStyle': 'inline',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'skuValue',
            'span': 2,
            'displayKey': 'Size',
            'fieldPath': 'skuAttributes.size',
            'displayStyle': 'inline',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Fabric Composition',
            'values': [
              'Top: 90% Cotton, 10% Polyester',
              'Bottom: 90% Cotton, 10% Polyester',
              'Outer: 90% Cotton, 10% Polyester',
            ],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Bottom Closure',
            'values': ['Button'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Feature',
            'values': ['Applique', 'Soft Elastic Waistband'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Sleeve Type',
            'values': ['Roll-up Sleeves'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Top Closure',
            'values': ['Button'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 1,
            'displayKey': 'Wash Care Instructions',
            'values': ['Hand wash'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
        ],
      },
      {
        'tabName': 'Description',
        'items': [
          {
            'type': 'text',
            'span': 2,
            'values': [
              "Classic shirt and trouser pairing brings a clean and versatile everyday style. With its neat silhouette and subtle detailing, it's perfect for casual outings while still looking put-together and polished.",
            ],
          },
          {
            'type': 'keyValue',
            'span': 2,
            'displayKey': 'What is included',
            'values': ['1 T-shirt, 1 Pant, 1 Jacket'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'skuValue',
            'span': 2,
            'displayKey': 'MRP',
            'fieldPath': 'skuAttributes.skuMrp',
            'displayStyle': 'inline',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'skuValue',
            'span': 2,
            'displayKey': 'Size',
            'fieldPath': 'skuAttributes.size',
            'displayStyle': 'inline',
            'showBullet': false,
            'showDivider': false,
          },
        ],
      },
      {
        'tabName': 'Manufacturer Details',
        'items': [
          {
            'type': 'keyValue',
            'span': 2,
            'displayKey': 'Manufacturer Details',
            'values': ['Kidcity Solutions Pvt Ltd'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 2,
            'displayKey': 'Packer Details',
            'values': [
              'Giggle Ground LLP, A/7, Harihar Corp., Mankoli Naka, Dapode, Bhiwandi, Thane - 421309',
            ],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
          {
            'type': 'keyValue',
            'span': 2,
            'displayKey': 'Country Of Origin',
            'values': ['India'],
            'displayStyle': 'block',
            'showBullet': false,
            'showDivider': false,
          },
        ],
      },
    ],
  },
  'recentlyViewed': {
    'viewConfig': {
      'tileWidth': 200.0,
      'tileHeight': 300.0,
      'minTilesToShow': 2,
      'navigation': true,
      'snapping': false,
      'showPageIndicators': true,
      'peepingFactor': 30,
      'imageCornerRadius': 4.0,
    },
    'tiles': [
      {
        'id': 26795,
        'product': {
          'id': 1317681,
          'name': 'Floral Bow Applique Dress',
          'media': [
            {
              'mimeType': 'IMAGE',
              'url':
                  'https://qastatic.hopscotch.in/fstatic/product/202006/1bda96d5-dc34-4a16-9e13-6373a59070a0_full.jpg?version=1592223869844',
              'height': 2100,
              'width': 1500,
            },
          ],
          'brandName': 'Hopscotch',
          'priceInfo': {
            'sellingPrice': '₹1,199',
            'mrp': '₹1,499',
            'discount': '20% OFF',
            'absoluteValue': 1199,
          },
          'wishlistInfo': {
            'id': 233,
            'isWishlisted': false,
            'canWishlist': true,
          },
          'soldOut': false,
          'colorVariants': '+2 Colors',
          'actionUri': 'hopscotch://product?id=1317681',
          // 'visualCue': {
          //   'uiType': 'TEXT',
          //   'location': 'BottomLeft',
          //   'text': 'Trending',
          //   'textColor': '#FFFFFF',
          //   'backgroundColor': '#6A1B9A',
          // },
          'visualCue': {
            'uiType': 'IMAGE',
            'location': 'BottomLeft',
            'text': 'TRENDING',
            'textColor': '',
            'backgroundColor': '',
            'imageUrl': 'https://qastatic.hopscotch.in/fstatic/trending.svg',
          },
        },
      },
      {
        'id': 26796,
        'product': {
          'id': 1317682,
          'name': 'Striped Shorts Set',
          'media': [
            {
              'mimeType': 'IMAGE',
              'url':
                  'https://qastatic.hopscotch.in/fstatic/product/202006/0a345ec0-0873-4267-b541-7b482cc42ee5_full.jpg?version=1592223870436',
              'height': 2100,
              'width': 1500,
            },
          ],
          'brandName': 'Hopscotch',
          'priceInfo': {
            'sellingPrice': '₹999',
            'mrp': '₹1,299',
            'discount': '23% OFF',
            'absoluteValue': 999,
            'callout': 'Inclusive of all taxes',
          },
          'wishlistInfo': {
            'id': 234,
            'isWishlisted': false,
            'canWishlist': true,
          },
          'soldOut': false,
          'colorVariants': null,
          'actionUri': 'hopscotch://product?id=1317682',
        },
      },
      {
        'id': 26797,
        'product': {
          'id': 1317683,
          'name': 'Printed Dungaree',
          'media': [
            {
              'mimeType': 'IMAGE',
              'url':
                  'https://qastatic.hopscotch.in/fstatic/product/202006/1bda96d5-dc34-4a16-9e13-6373a59070a0_full.jpg?version=1592223869844',
              'height': 2100,
              'width': 1500,
            },
          ],
          'brandName': 'Hopscotch',
          'priceInfo': {
            'sellingPrice': '₹1,499',
            'mrp': '₹1,999',
            'discount': '25% OFF',
            'absoluteValue': 1499,
            'callout': 'Inclusive of all taxes',
          },
          'wishlistInfo': {
            'id': 235,
            'isWishlisted': true,
            'canWishlist': true,
          },
          'soldOut': false,
          'colorVariants': '+1 Color',
          'actionUri': 'hopscotch://product?id=1317683',
        },
      },
    ],
    'title': {
      'url':
          'https://static.hopscotch.in/fstatic/boutique/banner/202603/8025dfc4-3359-4bc5-8a43-58fb68c95dee_full.jpg?version=1773596099632',
      'height': 53,
      'width': 960,
    },
    'margins': {
      'top': 12.0,
      'bottom': 12.0,
      'horizontal': 16.0,
      'innerHorizontalMargin': 8.0,
      'titleBottomMargin': 0.0,
      'titleHorizontalMargin': 0.0,
    },
  },
};
