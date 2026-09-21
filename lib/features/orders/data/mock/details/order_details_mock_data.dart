// Payloads for the Order Details mock.
//
// Copied from docs/orders/be/be_order_details_v9.jsonc with the comments
// stripped. If that contract changes, change these with it: holding the
// payloads here rather than paraphrasing them is what stops the mock and the
// contract drifting apart.
//
// ── WHICH URLS ACTUALLY RESOLVE ────────────────────────────────────────────
// The contract's asset paths are placeholders written while drafting, so a
// screen fed the contract verbatim renders a grid of broken images. Two
// substitutions are made here, and only these two:
//
//   · product images   real URLs lifted from the captured order/v8 responses
//                      in docs/orders/android_api_responses/, paired with the
//                      product name and price that shipped with them
//   · status icons     every one is vector_cod_available.svg, the single
//                      status glyph on static.hopscotch.in today. So every
//                      status looks identical until BE publishes the eight —
//                      read the title, not the icon
//
// Everything else keeps the contract's placeholder path and will 404: the
// support footer's phone and help glyphs, the COD banner icon, the refund-T&C
// chevron, and the two instructional photographs in `knowMoreInfo`.
//
// Amounts add up, which the contract's own example does not: Total Item Price
// is the sum of MRP x quantity, Item Discount brings it to the selling prices,
// and the payment rows sum to the total.
//
// Delete this file when BE ships the endpoint.

/// Every block the screen can draw, in one response — useful while building,
/// misleading as a model of a real order.
///
/// Two shipments. The first is in flight and carries a free gift (no `size`,
/// no `actionUri`), an item with the non-returnable advisory, a delivered item
/// waiting to be rated, and an item mid-return with `statusTags` and an HTML
/// `statusLabel`. The second is delivered, so it carries the return-condition
/// notice, the `knowMoreInfo` sheet behind it, and Return / Exchange.
///
/// Partially paid: ₹120 taken online, ₹5,300 owed at the door, which is why
/// the banner, the payment rows and the two-segment bar all say so.
///
/// It has no `paymentRecovery` — that block and shipment `ctaActions` never
/// arrive together. See [kOrderDetailsPaymentFailed] for that path.
const String kOrderDetailsEverything = r'''
{
  "action": "success",
  "orderId": "26719242",
  "pageMeta": {
    "pageTitle": "Order 082426719242",
    "pageSubtitle": "Placed on 24 Aug, 2026"
  },
  "messageBars": [
    {
      "messageType": "success",
      "message": "Please pay ₹5,300 to the delivery agent",
      "hasIcon": true,
      "icon": "https://static.hopscotch.in/fstatic/orders/cod.svg",
      "bgColor": "#DCF0E4",
      "textColor": "#333333"
    }
  ],
  "shipments": [
    {
      "shipmentId": "26719243",
      "shipmentInfo": {
        "title": "Shipment 1 of 2",
        "subtitle": "Arriving on time",
        "totalLabel": "Total",
        "totalAmount": "₹4,850",
        "itemCountLabel": "for 4 items"
      },
      "items": [
        {
          "itemId": "43852253",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202007/2bce54a5-3f9e-407d-9687-289fe2352db0_medium.jpg?version=1594037018086",
            "mimeType": "IMAGE"
          },
          "title": "Free Gift",
          "priceInfo": {
            "sellingPrice": "₹0"
          },
          "quantity": 1,
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Arrives by 30 Aug",
            "ctaAction": {
              "label": "Track",
              "actionUri": "hopscotch://track/43852253",
              "style": "link"
            }
          },
          "rating": {
            "visible": false
          }
        },
        {
          "itemId": "43852225",
          "actionUri": "hopscotch://product/891283",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/201911/bcf2a828-af8e-4711-b598-d41a0d479fd6_medium.jpg?version=1572936751855",
            "mimeType": "IMAGE"
          },
          "title": "Red Text Printed Full Sleeves Onesies and Skirt Set",
          "priceInfo": {
            "sellingPrice": "₹751",
            "mrp": "₹1,029"
          },
          "quantity": 2,
          "size": "0-6 months",
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
            "title": "Arrives by 30 Aug",
            "ctaAction": {
              "label": "Track",
              "actionUri": "hopscotch://track/43852225",
              "style": "link"
            }
          },
          "rating": {
            "visible": false
          }
        },
        {
          "itemId": "43852226",
          "actionUri": "hopscotch://product/912909",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/201912/040dcb04-b2ec-49ad-91b1-cf029aeb09a2_medium.jpg?version=1577432793871",
            "mimeType": "IMAGE"
          },
          "title": "Yellow Off Shoulder Choli With Lehenga",
          "priceInfo": {
            "sellingPrice": "₹2,499"
          },
          "quantity": 1,
          "size": "3-4 years",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Delivered on 28 Aug"
          },
          "rating": {
            "visible": true,
            "value": 0,
            "ratingId": "S0tKvrmryY1rs3j7ni2tbAm9nDUDfqyEHhhgUn9BIHc=",
            "actionUri": "hopscotch://rate/43852226"
          }
        },
        {
          "itemId": "43852227",
          "actionUri": "hopscotch://product/949919",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202007/4a842b1b-1817-4c91-baa8-1a816138d5d5_medium.jpg?version=1595250254804",
            "mimeType": "IMAGE"
          },
          "title": "Blue Full Length Baby Footie (Pack Of 3)",
          "priceInfo": {
            "sellingPrice": "₹849",
            "mrp": "₹1,199"
          },
          "quantity": 1,
          "size": "Newborn",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Return initiated: 1 qty"
          },
          "statusTags": [
            "Returned: 1 Qty"
          ],
          "statusLabel": "Refund has been initiated. It will reflect in your original payment source by <strong>Friday, 29 May 2026</strong>.",
          "rating": {
            "visible": false
          }
        }
      ],
      "ctaActions": [
        {
          "label": "Cancel",
          "actionUri": "hopscotch://order/26719243/cancel",
          "style": "secondary"
        }
      ]
    },
    {
      "shipmentId": "26719244",
      "shipmentInfo": {
        "title": "Shipment 2 of 2",
        "subtitle": "Delivered on 26 Aug",
        "totalLabel": "Total",
        "totalAmount": "₹470",
        "itemCountLabel": "for 1 item"
      },
      "items": [
        {
          "itemId": "43852228",
          "actionUri": "hopscotch://product/923956",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202002/cd9ccf61-62b7-4baf-b23a-756b7daf2880_medium.jpg?version=1582693870585",
            "mimeType": "IMAGE"
          },
          "title": "Navy Strip Half Sleeve T-Shirt And Shorts Set",
          "priceInfo": {
            "sellingPrice": "₹470"
          },
          "quantity": 1,
          "size": "0-6 months",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Delivered on 26 Aug"
          },
          "rating": {
            "visible": true,
            "value": 5,
            "ratingId": "T1uLwsnszZ2st4k8oj3ucBn0oEVEgrfZIiihVo0CJId=",
            "actionUri": "hopscotch://rate/43852228"
          }
        }
      ],
      "messageBars": [
        {
          "messageType": "custom",
          "message": "Items must be in unused condition with all tags intact",
          "hasIcon": true,
          "icon": "https://static.hopscotch.in/fstatic/orders/tag_info.svg",
          "bgColor": "#DDDCFB",
          "textColor": "#333333",
          "actionText": "Know more",
          "actionLink": "knowMoreInfo"
        }
      ],
      "knowMoreInfo": {
        "title": "Know more",
        "sections": [
          {
            "title": "Return Tag",
            "media": {
              "url": "https://static.hopscotch.in/fstatic/orders/return_tag.png",
              "mimeType": "IMAGE"
            },
            "caption": "Make sure the return tag is intact."
          },
          {
            "title": "MRP Label",
            "media": {
              "url": "https://static.hopscotch.in/fstatic/orders/mrp_label.png",
              "mimeType": "IMAGE"
            },
            "caption": "Make sure the MRP label is intact."
          }
        ]
      },
      "ctaActions": [
        {
          "label": "Return",
          "actionUri": "hopscotch://order/26719244/return",
          "style": "secondary"
        },
        {
          "label": "Exchange",
          "actionUri": "hopscotch://order/26719244/exchange",
          "style": "secondary"
        }
      ]
    }
  ],
  "recipient": {
    "sectionTitle": "Shipping Details",
    "name": "Rohan Kumar",
    "displayAddress": "Link Rd 4, Next To Nagarjuna Restaurant, KHB Colony, Stage 2, Hoysala Nagar, Indiranagar, Bengaluru, Karnataka 560095",
    "phones": [
      "+91 01234 56789",
      "+91 01234 56789"
    ],
    "email": "nathan.roberts@example.com"
  },
  "orderSummary": {
    "sectionTitle": "Price Summary",
    "subText": "Includes GST and government taxes",
    "pricingData": [
      {
        "priceType": "Total Item Price",
        "displayValue": "₹6,226",
        "displayColor": "#333333"
      },
      {
        "priceType": "Item Discount",
        "displayValue": "-₹906",
        "displayColor": "#0B8A46"
      },
      {
        "priceType": "Platform Fee",
        "displayValue": "₹50",
        "displayColor": "#333333",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Platform fee",
            "description": "A platform fee may be applied to your order. It helps us ensure secure payments, smooth updates, and a seamless shopping experience for you."
          }
        }
      },
      {
        "priceType": "Shipping fee",
        "displayValue": "₹50",
        "displayColor": "#333333",
        "subText": "Free shipping on orders of ₹1000 or more",
        "subTextColor": "#467AFF",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Why a Shipping Fee?",
            "description": "The Shipping fee helps us cover safe packaging, quick delivery, and a reliable courier service - so your order reaches you in perfect condition."
          }
        }
      }
    ],
    "totalOrderAmount": {
      "priceType": "Total",
      "displayValue": "₹5,420",
      "displayColor": "#070707"
    }
  },
  "paymentModes": {
    "sectionTitle": "Payment mode",
    "rows": [
      {
        "priceType": "Debit Card",
        "displayValue": "₹120",
        "displayColor": "#333333",
        "subText": "Non-refundable if the order is not accepted at delivery",
        "subTextColor": "#467AFF"
      },
      {
        "priceType": "Cash On Delivery",
        "displayValue": "₹5,300",
        "displayColor": "#333333"
      }
    ],
    "status": {
      "segments": [
        {
          "label": "₹120 Paid",
          "bgColor": "#3D8B37",
          "textColor": "#FFFFFF",
          "widthPercent": 30
        },
        {
          "label": "₹5,300 Due",
          "bgColor": "#E8E8E8",
          "textColor": "#1A1A1A",
          "widthPercent": 70
        }
      ]
    }
  },
  "support": {
    "title": "Need help with your order?",
    "ctaActions": [
      {
        "label": "Call Us",
        "type": "CALL_US",
        "icon": "https://static.hopscotch.in/fstatic/orders/phone.svg",
        "style": "secondary"
      },
      {
        "label": "Help Center",
        "type": "HELP_CENTER",
        "icon": "https://static.hopscotch.in/fstatic/orders/help.svg",
        "style": "secondary"
      }
    ]
  },
  "refundPolicy": {
    "label": "Read full refund T&C",
    "type": "REFUND_POLICY",
    "icon": "https://static.hopscotch.in/fstatic/chevron_right.svg",
    "style": "link"
  },
  "trackingMeta": {
    "parent_order_id": "26719242",
    "order_id": [
      "26719242",
      "26719243",
      "26719244"
    ],
    "order_status": [
      "Confirmed",
      "Confirmed",
      "Delivered"
    ],
    "total_item_price": 6226.0
  }
}
''';

/// The everyday order: one shipment, paid up front, nothing delivered yet.
///
/// No message bars, no `knowMoreInfo`, no `paymentRecovery`, no status chips,
/// nothing rateable — only Cancel. Shipping is waived, so its row sends
/// `displayValue: "Free"` with `originalValue` for the strikethrough, and the
/// payment bar is one segment at 100.
const String kOrderDetailsSingleShipment = r'''
{
  "action": "success",
  "orderId": "26719251",
  "pageMeta": {
    "pageTitle": "Order 082426719251",
    "pageSubtitle": "Placed on 12 Sep, 2026"
  },
  "shipments": [
    {
      "shipmentId": "26719251",
      "shipmentInfo": {
        "title": "Shipment 1 of 1",
        "subtitle": "Arriving on time",
        "totalLabel": "Total",
        "totalAmount": "₹900",
        "itemCountLabel": "for 2 items"
      },
      "items": [
        {
          "itemId": "43852301",
          "actionUri": "hopscotch://product/944106",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202006/1a090d3a-b96c-464a-aa01-7e01e7334ef0_medium.jpg?version=1591854084977",
            "mimeType": "IMAGE"
          },
          "title": "Blue Numerical Applique Slip Ons",
          "priceInfo": {
            "sellingPrice": "₹650",
            "mrp": "₹1,500"
          },
          "quantity": 1,
          "size": "Euro 19.5 (6-9 months)",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Arrives by 18 Sep",
            "ctaAction": {
              "label": "Track",
              "actionUri": "hopscotch://track/43852301",
              "style": "link"
            }
          },
          "rating": {
            "visible": false
          }
        },
        {
          "itemId": "43852302",
          "actionUri": "hopscotch://product/949337",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202007/2bce54a5-3f9e-407d-9687-289fe2352db0_medium.jpg?version=1594037018086",
            "mimeType": "IMAGE"
          },
          "title": "Multi All Over Print Kids Socks",
          "priceInfo": {
            "sellingPrice": "₹125"
          },
          "quantity": 2,
          "size": "4-6 Years",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Arrives by 18 Sep",
            "ctaAction": {
              "label": "Track",
              "actionUri": "hopscotch://track/43852302",
              "style": "link"
            }
          },
          "rating": {
            "visible": false
          }
        }
      ],
      "ctaActions": [
        {
          "label": "Cancel",
          "actionUri": "hopscotch://order/26719251/cancel",
          "style": "secondary"
        }
      ]
    }
  ],
  "recipient": {
    "sectionTitle": "Shipping Details",
    "name": "Rohan Kumar",
    "displayAddress": "Link Rd 4, Next To Nagarjuna Restaurant, KHB Colony, Stage 2, Hoysala Nagar, Indiranagar, Bengaluru, Karnataka 560095",
    "phones": [
      "+91 01234 56789",
      "+91 01234 56789"
    ],
    "email": "nathan.roberts@example.com"
  },
  "orderSummary": {
    "sectionTitle": "Price Summary",
    "subText": "Includes GST and government taxes",
    "pricingData": [
      {
        "priceType": "Total Item Price",
        "displayValue": "₹1,750",
        "displayColor": "#333333"
      },
      {
        "priceType": "Item Discount",
        "displayValue": "-₹850",
        "displayColor": "#0B8A46"
      },
      {
        "priceType": "Platform Fee",
        "displayValue": "₹50",
        "displayColor": "#333333",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Platform fee",
            "description": "A platform fee may be applied to your order. It helps us ensure secure payments, smooth updates, and a seamless shopping experience for you."
          }
        }
      },
      {
        "priceType": "Shipping fee",
        "displayValue": "Free",
        "displayColor": "#333333",
        "subText": "Free shipping on orders of ₹1000 or more",
        "subTextColor": "#467AFF",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Why a Shipping Fee?",
            "description": "The Shipping fee helps us cover safe packaging, quick delivery, and a reliable courier service - so your order reaches you in perfect condition."
          }
        },
        "originalValue": "₹50"
      }
    ],
    "totalOrderAmount": {
      "priceType": "Total",
      "displayValue": "₹950",
      "displayColor": "#070707"
    }
  },
  "paymentModes": {
    "sectionTitle": "Payment mode",
    "rows": [
      {
        "priceType": "UPI",
        "displayValue": "₹950",
        "displayColor": "#333333"
      }
    ],
    "status": {
      "segments": [
        {
          "label": "₹950 Paid",
          "bgColor": "#3D8B37",
          "textColor": "#FFFFFF",
          "widthPercent": 100
        }
      ]
    }
  },
  "support": {
    "title": "Need help with your order?",
    "ctaActions": [
      {
        "label": "Call Us",
        "type": "CALL_US",
        "icon": "https://static.hopscotch.in/fstatic/orders/phone.svg",
        "style": "secondary"
      },
      {
        "label": "Help Center",
        "type": "HELP_CENTER",
        "icon": "https://static.hopscotch.in/fstatic/orders/help.svg",
        "style": "secondary"
      }
    ]
  },
  "refundPolicy": {
    "label": "Read full refund T&C",
    "type": "REFUND_POLICY",
    "icon": "https://static.hopscotch.in/fstatic/chevron_right.svg",
    "style": "link"
  },
  "trackingMeta": {
    "parent_order_id": "26719251",
    "order_id": [
      "26719251"
    ],
    "order_status": [
      "Confirmed"
    ],
    "total_item_price": 1750.0
  }
}
''';

/// The recovery path: the order exists, the payment did not go through.
///
/// The shipment sends no `ctaActions` of its own — `paymentRecovery` carries
/// the two buttons instead — and the payment bar is a single grey Due segment.
/// The root `messageBars` entry is typed `error`, so it uses a bundled glyph
/// and ignores any `icon`.
const String kOrderDetailsPaymentFailed = r'''
{
  "action": "success",
  "orderId": "26719253",
  "pageMeta": {
    "pageTitle": "Order 082426719253",
    "pageSubtitle": "Placed on 14 Sep, 2026"
  },
  "messageBars": [
    {
      "messageType": "error",
      "message": "Your payment could not be processed",
      "hasIcon": true,
      "bgColor": "#FDE7E7",
      "textColor": "#333333"
    }
  ],
  "shipments": [
    {
      "shipmentId": "26719253",
      "shipmentInfo": {
        "title": "Shipment 1 of 1",
        "subtitle": "Payment failed",
        "totalLabel": "Total",
        "totalAmount": "₹599",
        "itemCountLabel": "for 1 item"
      },
      "items": [
        {
          "itemId": "43852401",
          "actionUri": "hopscotch://product/919724",
          "media": {
            "url": "https://qastatic.hopscotch.in/fstatic/product/202001/9df20281-522b-4bca-b24b-dd329569c869_medium.jpg?version=1579518011086",
            "mimeType": "IMAGE"
          },
          "title": "Blue Stripes Half Sleeves T-Shirt",
          "priceInfo": {
            "sellingPrice": "₹599"
          },
          "quantity": 1,
          "size": "4-5 years",
          "status": {
            "icon": "https://static.hopscotch.in/vector_cod_available.svg",
            "title": "Waiting for payment"
          },
          "rating": {
            "visible": false
          }
        }
      ]
    }
  ],
  "paymentRecovery": {
    "ctaActions": [
      {
        "label": "Retry online payment",
        "actionUri": "hopscotch://payment/retry",
        "style": "secondary"
      },
      {
        "label": "Place COD order",
        "actionUri": "hopscotch://payment/cod",
        "style": "primary"
      }
    ]
  },
  "recipient": {
    "sectionTitle": "Shipping Details",
    "name": "Rohan Kumar",
    "displayAddress": "Link Rd 4, Next To Nagarjuna Restaurant, KHB Colony, Stage 2, Hoysala Nagar, Indiranagar, Bengaluru, Karnataka 560095",
    "phones": [
      "+91 01234 56789",
      "+91 01234 56789"
    ],
    "email": "nathan.roberts@example.com"
  },
  "orderSummary": {
    "sectionTitle": "Price Summary",
    "subText": "Includes GST and government taxes",
    "pricingData": [
      {
        "priceType": "Total Item Price",
        "displayValue": "₹599",
        "displayColor": "#333333"
      },
      {
        "priceType": "Item Discount",
        "displayValue": "₹0",
        "displayColor": "#0B8A46"
      },
      {
        "priceType": "Platform Fee",
        "displayValue": "₹50",
        "displayColor": "#333333",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Platform fee",
            "description": "A platform fee may be applied to your order. It helps us ensure secure payments, smooth updates, and a seamless shopping experience for you."
          }
        }
      },
      {
        "priceType": "Shipping fee",
        "displayValue": "Free",
        "displayColor": "#333333",
        "subText": "Free shipping on orders of ₹1000 or more",
        "subTextColor": "#467AFF",
        "action": {
          "type": "bottomSheet",
          "icon": "https://static.hopscotch.in/fstatic/info_black.svg",
          "content": {
            "title": "Why a Shipping Fee?",
            "description": "The Shipping fee helps us cover safe packaging, quick delivery, and a reliable courier service - so your order reaches you in perfect condition."
          }
        },
        "originalValue": "₹50"
      }
    ],
    "totalOrderAmount": {
      "priceType": "Total",
      "displayValue": "₹649",
      "displayColor": "#070707"
    }
  },
  "paymentModes": {
    "sectionTitle": "Payment mode",
    "rows": [
      {
        "priceType": "Online Payment",
        "displayValue": "₹649",
        "displayColor": "#333333",
        "subText": "Payment not received",
        "subTextColor": "#467AFF"
      }
    ],
    "status": {
      "segments": [
        {
          "label": "₹649 Due",
          "bgColor": "#E8E8E8",
          "textColor": "#1A1A1A",
          "widthPercent": 100
        }
      ]
    }
  },
  "support": {
    "title": "Need help with your order?",
    "ctaActions": [
      {
        "label": "Call Us",
        "type": "CALL_US",
        "icon": "https://static.hopscotch.in/fstatic/orders/phone.svg",
        "style": "secondary"
      },
      {
        "label": "Help Center",
        "type": "HELP_CENTER",
        "icon": "https://static.hopscotch.in/fstatic/orders/help.svg",
        "style": "secondary"
      }
    ]
  },
  "refundPolicy": {
    "label": "Read full refund T&C",
    "type": "REFUND_POLICY",
    "icon": "https://static.hopscotch.in/fstatic/chevron_right.svg",
    "style": "link"
  },
  "trackingMeta": {
    "parent_order_id": "26719253",
    "order_id": [
      "26719253"
    ],
    "order_status": [
      "Waiting for payment"
    ],
    "total_item_price": 599.0
  }
}
''';

/// The failure envelope. `message` is shown to the customer word for word.
///
/// Point [OrderDetailsMockSource] at this to check the error state: nothing
/// else arrives with it — no partial `shipments`, no `pageMeta`.
const String kOrderDetailsFailure = r'''
{
  "action": "failure",
  "message": "We couldn't find this order."
}
''';
