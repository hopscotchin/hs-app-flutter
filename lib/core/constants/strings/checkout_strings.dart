class CheckoutStrings {
  CheckoutStrings._();

  // Price Summary
  static const String priceSummary = 'Price Summary';
  static const String includesGst = 'Includes GST and all government taxes';
  static const String item = 'item';
  static const String items = 'items';

  // Checkout / Payment
  static const String checkout = 'Checkout';
  static const String payment = 'Payment';
  static const String placeOrder = 'Place Order';
  static const String proceedToPay = 'Proceed To Pay';
  static const String pay = 'Pay'; // composed inline as `Pay ₹<amount>`
  static const String paymentInitFailed = 'Payment initialization failed';
  static const String processingPayment = 'Processing payment...';
  static const String processingYourPayment = 'Processing your payment';
  static const String processingPaymentSubtitle =
      'Please wait, this may take a while';
  static const String initiatingPayment = 'Initiating payment...';
  static const String orderConfirmation = 'Order Confirmation';
  static const String paymentRetry = 'Retry Payment';
  static const String retry = 'Retry';
  static const String otherOption = 'Other option';
  static const String cancel = 'Cancel';
  static const String reviewCart = 'Review Cart';
  static const String amount = 'Amount';
  static const String creditsLabel = 'Credits:';
  static const String shipToLabel = 'Ship to:';
  static const String addDeliveryAddress = 'Add Delivery Address';
  static const String payLabel = 'Pay:';

  // Payment processing exit sheet
  static const String paymentProcessingTitle = 'Payment Processing';
  static const String paymentPendingConfirm =
      'Transaction is pending. Do you want to go back?';
  static const String yesGoBack = 'YES, GO BACK';
  static const String no = 'NO';

  // Order confirmation
  static const String allDone = 'All done';
  static const String orderPrefix = 'Order'; // composed as `Order <id>`
  static const String orderConfirmed = 'Your order has been confirmed';
  static const String shippingAddress = 'Shipping Address';
  static const String continueShopping = 'CONTINUE SHOPPING';
}
