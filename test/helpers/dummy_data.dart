import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_data_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_meta_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/product_price_entity.dart';

const dummyProductDetail = ProductDetailEntity(
  action: 'success',
);

const dummyListingProduct = ListingProductEntity(
  id: 1,
  name: 'Listing Product 1',
  brandName: 'Brand A',
  price: ProductPriceEntity(
      sellingPrice: '30',
      mrp: 'MRP: 50',
      discountLabel: '15% off'
  ),
  quantity: 10,
);

const dummyListingProduct2 = ListingProductEntity(
  id: 2,
  name: 'Listing Product 2',
  brandName: 'Brand B',
  price: ProductPriceEntity(
      sellingPrice: '30',
      mrp: 'MRP: 50',
      discountLabel: '15% off'
  ),
  quantity: 5,
);

const dummyListingData = ListingDataEntity(
  records: [dummyListingProduct, dummyListingProduct2],
  pageMeta: PageMetaEntity(
    pageSize: 20,
    page: 1,
    totalCount: 2
  )
);

const dummyListingDataWithMore = ListingDataEntity(
  records: [dummyListingProduct],
    pageMeta: PageMetaEntity(
        pageSize: 20,
        page: 1,
        totalCount: 2
    )
);

const dummyHomePage = HomePageEntity(
  action: 'success',
  pageMeta: PageMeta(
    pageName: 'discover',
    totalCollections: 2,
  ),
  pageComponents: [
    PageComponent(type: PageComponentType.hero, position: 0),
    PageComponent(type: PageComponentType.customTiles, position: 1),
  ],
);
