// Payloads for the Orders tab of the listing mock.
//
// Copied verbatim from docs/orders/be/be_orders_listing_v6.jsonc,
// comments stripped. If that file changes, change these with it: holding the
// payloads here rather than paraphrasing them is what stops the mock and the
// contract drifting apart.
//
// Decoded through the real `OrdersListingResponseModel.fromJson`, so the mock
// exercises the same parsing path production does — a key renamed in the
// contract fails here exactly as it would against the live API.
//
// Delete this file when BE ships the endpoint.

/// Page 1 of the Orders tab: a free gift (no `size`), an in-flight item
/// carrying the non-returnable advisory, and a cancelled one. Has the nudge
/// and the support footer, and `hasNextPage: true` so pagination has
/// somewhere to go.
const String kOrdersListingPage1 = r'''
{
  "action": "success",
  "pageMeta": {
    "page": 1,
    "pageSize": 20,
    "totalCount": 41,
    "hasNextPage": true
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
  "support": {
    "title": "Need help with your order?",
    "ctaActions": [
      {
        "label": "Call us",
        "type": "CALL_US",
        "icon": "https://static.hopscotch.in/fstatic/orders/phone.svg",
        "style": "secondary"
      },
      {
        "label": "Help center",
        "type": "HELP_CENTER",
        "icon": "https://static.hopscotch.in/fstatic/orders/help.svg",
        "style": "secondary"
      }
    ]
  },
  "trackingMeta": {
    "order_count": 41,
    "active_orders": 20,
    "tab": "orders"
  },
  "records": [
    {
      "orderId": "26719251",
      "orderItemId": "43852253",
      "actionUri": "hopscotch://order/26719251",
      "actionUriWeb": "https://www.hopscotch.in/order/26719251",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Free Gift",
      "priceInfo": {
        "sellingPrice": "₹0"
      },
      "quantity": 1,
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Delivery by Apr 20",
        "subtitle": "Your item has been placed"
      }
    },
    {
      "orderId": "26719251",
      "orderItemId": "43852254",
      "actionUri": "hopscotch://order/26719251",
      "actionUriWeb": "https://www.hopscotch.in/order/26719251",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Girls Beige and Blue Solid Jacket and Pant Set",
      "priceInfo": {
        "sellingPrice": "₹499"
      },
      "quantity": 1,
      "size": "8-9 Years",
      "itemDetails": {
        "title": "Non returnable & non exchangeable",
        "titleColor": "#3D65F7",
        "action": {
          "type": "tooltip",
          "icon": "https://static.hopscotch.in/fstatic/info.svg",
          "content": {
            "bgColor": "#3D65F7",
            "textColor": "#FFFFFF",
            "text": "Final Reduction Sale: Products in this sale are non-returnable, and products in this category are non-exchangeable"
          }
        }
      },
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Delivery by Apr 20",
        "subtitle": "Your item has been placed"
      }
    },
    {
      "orderId": "26719250",
      "orderItemId": "43852235",
      "actionUri": "hopscotch://order/26719250",
      "actionUriWeb": "https://www.hopscotch.in/order/26719250",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Navy Strip Half Sleeve T-Shirt And Shorts Set",
      "priceInfo": {
        "sellingPrice": "₹499"
      },
      "quantity": 1,
      "size": "8-9 Years",
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Cancelled on Apr 20",
        "subtitle": "Your item has been cancelled and ₹499 has been refunded"
      }
    }
  ]
}
''';

/// Page 2: three more rows with fresh ids and `hasNextPage: false`, so the
/// list stops. No nudge and no support block — both are page-level, and the
/// merge keeps page 1's.
const String kOrdersListingPage2 = r'''
{
  "action": "success",
  "pageMeta": {
    "page": 2,
    "pageSize": 20,
    "totalCount": 41,
    "hasNextPage": false
  },
  "trackingMeta": {
    "order_count": 41,
    "active_orders": 40,
    "tab": "orders"
  },
  "records": [
    {
      "orderId": "26719300",
      "orderItemId": "43852300",
      "actionUri": "hopscotch://order/26719300",
      "actionUriWeb": "https://www.hopscotch.in/order/26719300",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Free Gift",
      "priceInfo": {
        "sellingPrice": "₹0"
      },
      "quantity": 1,
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Delivery by Apr 20",
        "subtitle": "Your item has been placed"
      }
    },
    {
      "orderId": "26719301",
      "orderItemId": "43852301",
      "actionUri": "hopscotch://order/26719301",
      "actionUriWeb": "https://www.hopscotch.in/order/26719301",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Girls Beige and Blue Solid Jacket and Pant Set",
      "priceInfo": {
        "sellingPrice": "₹499"
      },
      "quantity": 1,
      "size": "8-9 Years",
      "itemDetails": {
        "title": "Non returnable & non exchangeable",
        "titleColor": "#3D65F7",
        "action": {
          "type": "tooltip",
          "icon": "https://static.hopscotch.in/fstatic/info.svg",
          "content": {
            "bgColor": "#3D65F7",
            "textColor": "#FFFFFF",
            "text": "Final Reduction Sale: Products in this sale are non-returnable, and products in this category are non-exchangeable"
          }
        }
      },
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Delivery by Apr 20",
        "subtitle": "Your item has been placed"
      }
    },
    {
      "orderId": "26719302",
      "orderItemId": "43852302",
      "actionUri": "hopscotch://order/26719302",
      "actionUriWeb": "https://www.hopscotch.in/order/26719302",
      "media": {
        "url": "https://qastatic.hopscotch.in/fstatic/product/202408/2b0987c4-93c8-4905-a5bb-5641f65e2775_full.jpg?version=1724587138304",
        "mimeType": "IMAGE"
      },
      "title": "Navy Strip Half Sleeve T-Shirt And Shorts Set",
      "priceInfo": {
        "sellingPrice": "₹499"
      },
      "quantity": 1,
      "size": "8-9 Years",
      "status": {
        "icon": "https://static.hopscotch.in/vector_cod_available.svg",
        "title": "Cancelled on Apr 20",
        "subtitle": "Your item has been cancelled and ₹499 has been refunded"
      }
    }
  ]
}
''';

/// The empty Orders tab. No records — just the server-owned copy and its CTA.
/// Point [OrdersListingMockSource] at this to check the empty state.
const String kOrdersListingEmpty = r'''
{
  "action": "success",
  "pageMeta": {
    "page": 1,
    "pageSize": 20,
    "totalCount": 0,
    "hasNextPage": false
  },
  "emptyState": {
    "title": "Looks like you haven't\nplaced an order yet.",
    "ctaAction": {
      "label": "Shop now",
      "actionUri": "hopscotch://home",
      "style": "primary"
    }
  },
  "trackingMeta": {
    "order_count": 0,
    "active_orders": 0,
    "tab": "orders"
  },
  "records": []
}
''';
