// Payloads for the Gift Cards tab of the listing mock.
//
// Copied verbatim from docs/orders/be/be_gift_cards_listing_v2.jsonc,
// comments stripped. If that file changes, change these with it: holding the
// payloads here rather than paraphrasing them is what stops the mock and the
// contract drifting apart.
//
// Decoded through the real `OrdersListingResponseModel.fromJson`, so the mock
// exercises the same parsing path production does — a key renamed in the
// contract fails here exactly as it would against the live API.
//
// Delete this file when BE ships the endpoint.

/// The Gift Cards tab, single page. The nudge is here too — it shows on both
/// tabs, matching Android, which binds it above the tab pager. Still absent:
/// `support`, and `size` on every record.
const String kGiftCardsPage1 = r'''
{
  "action": "success",
  "pageMeta": {
    "page": 1,
    "pageSize": 20,
    "totalCount": 15,
    "hasNextPage": false
  },
  "notificationNudge": {
    "title": "Stay Updated!",
    "titleImage": "https://static.hopscotch.in/fstatic/orders/bell.svg",
    "description": "Would you like us to notify you with details and status updates of your order?",
    "negativeButtonText": "No",
    "positiveButtonText": "Yes, Please",
    "rule": {
      "showNudgeFrequency": 3,
      "dismissedFrequency": 7,
      "deniedFrequency": 30
    }
  },
  "trackingMeta": {
    "order_count": 15,
    "active_orders": 15,
    "tab": "gift_cards"
  },
  "records": [
    {
      "orderId": "ORD100004",
      "orderItemId": "GC-ORD100004-1",
      "actionUri": "hopscotch://gift-card/ORD100004",
      "actionUriWeb": "https://www.hopscotch.in/gift-card/ORD100004",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Amazon Gift Card",
      "priceInfo": {
        "sellingPrice": "₹2,500"
      },
      "quantity": 2,
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Purchased on Feb 24",
        "subtitle": "Your item has been delivered"
      }
    },
    {
      "orderId": "ORD100006",
      "orderItemId": "GC-ORD100006-1",
      "actionUri": "hopscotch://gift-card/ORD100006",
      "actionUriWeb": "https://www.hopscotch.in/gift-card/ORD100006",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Myntra Gift Card",
      "priceInfo": {
        "sellingPrice": "₹1,000"
      },
      "quantity": 1,
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Cancelled on May 25",
        "subtitle": "Your item has been Cancelled and Payment has been Refunded"
      }
    },
    {
      "orderId": "ORD100005",
      "orderItemId": "GC-ORD100005-1",
      "actionUri": "hopscotch://gift-card/ORD100005",
      "actionUriWeb": "https://www.hopscotch.in/gift-card/ORD100005",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Flipkart Gift Card",
      "priceInfo": {
        "sellingPrice": "₹400"
      },
      "quantity": 2,
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Order pending",
        "subtitle": "Transaction is pending. Please check back later for the order status"
      }
    }
  ]
}
''';

/// The empty Gift Cards tab. Its CTA points at woohoo.in, a third-party
/// provider — an external redirect, not an in-app route.
const String kGiftCardsEmpty = r'''
{
  "action": "success",
  "pageMeta": {
    "page": 1,
    "pageSize": 20,
    "totalCount": 0,
    "hasNextPage": false
  },
  "emptyState": {
    "title": "Uh-Oh! No gift card added yet!\nTap below to purchase one now!",
    "ctaAction": {
      "label": "Buy a Gift Card",
      "actionUri": "https://hopscotch.woohoo.in",
      "style": "primary"
    }
  },
  "trackingMeta": {
    "order_count": 0,
    "active_orders": 0,
    "tab": "gift_cards"
  },
  "records": []
}
''';
