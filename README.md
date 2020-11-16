# simple_stock_tracking_app

 Simple stock tracking application based on a finance API. 

## Getting Started

The application works like as stock tracker. It contains different dart documents that generate communication with the Alpha Vantage API and receive data in real time. 

As main screens I have a class that draws each Quote that the user adds and the home screen, where an Appbar is presented with the button to add new quotes. The limit is set to five, so that if the user wants to add more than this amount, the function is disabled. Due to time reasons I didn’t add any show dialog indicating that one has reached the limit.

In the globalQuoteDisplay class I put a streamBuilder whose streamController depends on the function that makes the call to the api. Since it is about stocks, I also set a periodic timer that makes every 65 seconds (calculation proportional to the five calls that the api allows per minute and the number of quotes that the user can add) the stream is heard again, and then with the help of the streambuilder the stocks are redrawn. 

There is this issue with the number of api calls. A retry interceptor could be put at the end of the calls to deal with failed calls due to rate limits. For more information (https://pub.dev/packages/dio_retry).

There is also another issue regarding listview builder, where each time that you make an api call and setState the builder redraws itself. Having checked different documentations, it is a known issue on Flutter and it is still being solved.

With help of the documentation of Alpha Vantages API I also enabled a search engine that receives keywords for the different existing quotes that the user wants to choose.

The application saves with Shared Preferences the quotes that the user to consulted. At the same time, with a dismissible you can swipe to remove unwanted quotes.

The design is unitary and minimalist.
