# Flight Search App - Technical Assessment

## Short Description

This is a Flutter app built for a RideFi technical assessment.

The user can pick a departure airport, an arrival airport, and a travel date, then search for flights using the Aviationstack API. The app shows a list of flights and lets the user open each flight for more details.

## Features

- Onboarding flow before entering the app
- Airport search sheet for selecting departure and arrival airports
- Travel date picker on the search screen
- Flight search request using Aviationstack
- Flight results list with:
	- Airline name
	- Airline logo
	- Departure and arrival time
	- Price label
- Flight details screen with:
	- Flight number
	- Aircraft
	- Duration
	- Stops
- Favorites flow to save and remove flights
- Infinite scroll style pagination for results and airport list

## Screens

- Splash screen
	- Shows a simple icon and routes to onboarding.
- Onboarding screen
	- 3 intro pages with illustrations and short text.
- Home search screen
	- Select departure airport, arrival airport, trip type, and departure date.
	- Tap Search Flights to run the query.
- Flight results screen
	- Shows loading, error, empty, and result states.
	- Each card shows airline, logo/fallback, time info, and price label.
- Flight details screen
	- Shows selected flight details like flight number, aircraft, duration, and stops.
	- User can favorite/unfavorite from this screen.
- Favorites screen
	- Shows saved flights from local storage.

## Tech Stack

- Flutter
- Riverpod (flutter_riverpod + hooks_riverpod)
- Clean Architecture style folder split
- Dio for API calls
- AutoRoute for navigation
- GetIt + Injectable for dependency injection
- Hive for local storage (favorites)
- CachedNetworkImage for airline logos

## Project Structure

This project follows a feature-first Clean Architecture style.

		lib/
			app/
				app.dart
				router.dart
				injection.dart
			core/
				base/
				errors/
				services/
				theme/
				widget/
			features/
				flight_search/
					data/
						repositories/
						services/
					domain/
						entities/
						models/
					presentation/
						pages/
						providers/
						widgets/
				onboarding/
					presentation/
						pages/

## How to Run the Project

1. Make sure Flutter is installed.
2. Open this project folder.
3. Install packages:

			 flutter pub get

4. Confirm the Aviationstack API key in this file:

			 lib/core/services/api/aviationstack_config.dart

5. Run the app:

			 flutter run

Optional: if you change routes or Injectable setup, regenerate files:

		dart run build_runner build --delete-conflicting-outputs

## Appetize Testing Link

Use this Appetize build to test the app without local setup:

- https://appetize.io/app/YOUR_PUBLIC_APPETIZE_LINK

## How to Test (Important)

Use this flow when testing flight search in this assessment build:

1. Open the app and go to the Home search screen.
2. Tap the **From** field.
3. In the airport bottom sheet, keep scrolling down to load more airports (the list is paginated).
4. Select **ATL** as From.
5. Tap the **To** field.
6. Keep scrolling again in the bottom sheet so more airport data is loaded.
7. Select **BOS** as To.
8. Tap **Search Flights**.

Why this is needed:

- The airport list and flight data are loaded in pages.
- ATL to BOS is a busy route and is a good route to test with.
- If you search too early and get no results, it usually means the needed data has not loaded yet.
- Keep scrolling in the airport sheets first, then search again.
- With a paid Aviationstack subscription, this testing flow would be simpler and this preloading behavior would be much less of an issue.

## API Notes

- API used: Aviationstack (http://api.aviationstack.com/v1)
- Endpoints used in this app:
	- GET /airports
	- GET /flights
- Access key is added as a query parameter.

Important limitation from the free plan:

- The free Aviationstack plan does not allow the level of filtering needed for full flight search behavior.
- Because of that, this assessment app cannot reliably search flights the way a real booking app should.
- Setting departure time is also not possible with the current free-plan access.

## Known Issues and Limitations

- Main blocker: Aviationstack free-plan restrictions prevent proper search behavior and departure-time support.
- The selected departure date is currently not sent from the home screen into the search request.
- Price is not returned by the current API response mapping, so cards show a fallback price label.
- Stops are currently defaulted to 0 in mapped flight data.
- Trip type and optional filters are UI-only right now and are not applied to API query parameters.
- API key is currently stored in source code for assessment convenience.

## Assumptions Made

- I assumed showing a fallback price is acceptable when fare data is missing.
- I assumed non-stop as a default when stop data is not available.
- I assumed airline logos can be built from airline IATA code and a public logo URL pattern.
- I treated this as a one-way search flow for the current API limits, even though round-trip and multi-city tabs are shown in UI.

## Optional Improvements

If I had more time (and a paid API plan), I would add:

- Real filtering by departure date/time and better route filters
- Proper fare/pricing support from a pricing-capable API
- Real stop and layover details from API data
- Fully wired round-trip and multi-city flows
- Better error messages for specific API failure cases
- Unit and widget tests for providers, repository, and key screens
- Move API key to runtime config (for example, dart-define) instead of hardcoding
