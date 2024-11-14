import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:schedule_generator/search_food/food_api_index.dart';
import 'food_repository.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri{}

class MockFood extends Mock implements Food{}

class MockApiProvider extends Mock implements FoodApiProvider {}

void main(){
  group("FoodApiProvider",(){
    //lazy initialization to allow fresh instance for each test
    late http.Client httpClient;
    late FoodApiProvider apiClient;


    //setUpAll : run once b4 all the tests run in this group
    setUpAll((){
      //whenever it encounters a Uri type in mocked method calls and expectation,
      // it should use FakeUri() if not other specific value is provided
      registerFallbackValue(FakeUri());
    });
    //setUp : run before each individual class

    setUp((){
      httpClient = MockHttpClient();
      apiClient = FoodApiProvider(httpClient: httpClient);
    });

    group("constructor", (){
      test("does not required an httpClient",(){
        expect(FoodApiProvider(), isNotNull);
      });
    });

    group("foodSearch", (){
      const query = "mock_query";

      test("makes correct http request with correct URI", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(()=> response.body).thenReturn('{}');
        //This line tells httpClient to return the response mock whenever httpClient.get
        when(()=>httpClient.get(any())).thenAnswer((_) async => response);
        try{
          // inside foodSearch, httpClient.get() is triggered
          // Since httpClient is mock, mockito keeps track of all interactions with it
          // including what methods were called and with what arguments
          await apiClient.searchMatchingFood(query);
        }catch(_){}
        verify(
          // lambda is to delay its execution, ensuring it doesn't run immediately in test
            () => httpClient.get(
              Uri.http("localhost:8080","/food/search",{"name": query}),
            ),
        ).called(1);
      });

      test("throw FoodSearchFailure on non-200 request", ()async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(()=> httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async =>  apiClient.searchMatchingFood(query)
        ,
          throwsA(isA<FoodRequestFailure>()),
        );
      });

    });
  } );

  group("food_api_repository", () {
    late FoodApiProvider apiProvider;
    late FoodApiRepository apiRepository;

    setUp((){
      apiProvider = MockApiProvider();
      apiRepository = FoodApiRepository(
      );
    });


    group("get food", (){
      const query = "mock_query";

      test("apiProvider is called in repository", () async{
        try {
          await apiRepository.searchMatchingFood(query);
        } catch (_) {}
        verify(()=> apiProvider.searchMatchingFood(query)).called(1);
      });

      test("throws FoodRequestFailure exception when request fails", () async {
        // Arrange: Mock the provider to throw FoodRequestFailure on a non-200 status code
        when(() => apiProvider.searchMatchingFood(any()))
            .thenAnswer((_) async {
          // Simulate a failed response with status code 400
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(400); // non-200 status
          when(() => response.body).thenReturn("{}"); // mock empty body
          // Simulate that the method throws FoodRequestFailure if the response is not 200
          throw FoodRequestFailure();
        });

        // Act & Assert: Expect the exception to be thrown
        expect(
              () async => apiRepository.searchMatchingFood(query),
          throwsA(isA<FoodRequestFailure>()),
        );
      });



    });

  });
}