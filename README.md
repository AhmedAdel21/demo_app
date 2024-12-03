# E-Commerce Insights Flutter App

This Flutter application provides key insights into an e-commerce dataset. It is designed to be user-friendly and runs seamlessly on iOS, Android, and Web platforms.

## Features
1. **Order Metrics Screen**: 
   - Displays total number of orders.
   - Shows the average price of orders.
   - Indicates the number of returned orders.

2. **Order Graph Screen**:
   - Plots a graph of the number of orders (Y-axis) over time (X-axis).
   - Interactive buttons to filter data by:
     - Last 6 months.
     - Last year.
     - All data.

3. **Responsive Design**:
   - Adapts seamlessly to mobile and web platforms.
   - Designed with a modern and sleek UI inspired by global leading FinTech companies.

4. **Bonus**: 
   - Includes animations and interactive filtering for a superior user experience.

## Demo
### GIF Walkthroughs

#### Android and iOS Demo
<div style="display: flex; justify-content: space-evenly;">
  <img src="assets\gifs\android.gif" alt="iOS Demo" width="45%">
  <img src="assets\gifs\ios.gif" alt="Android Demo" width="45%">
</div>

#### Web Demo
![Web Demo](assets\gifs\web.gif)

## Getting Started

### Prerequisites
1. Flutter SDK (version 3.24.5 or higher)
2. Any IDE for Flutter development (e.g., VS Code, Android Studio)
3. Clone the repository using Git.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/AhmedAdel21/demo_app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd demo_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## File Structure

- **`lib/:`** Main application logic.
    - **`app/:`**  Application Layer
    - **`data/:`** Data Layer for sending, receiving and storing data
    - **`domain/:`** Domain Layer for the business logic
    - **`presentation/:`** Presentation Layer Contains Screens and widgets.
- **`assets/:`** Contains the orders.json dataset, and other application assets.

## Dataset
The  **`orders.json`** file is located in the  **`assets`** directory. The app parses this dataset locally and does not require network calls.

## How to Run

1. Ensure Flutter is installed and configured.
2. Run the app on your desired platform:
    - Web:
   ```bash
   flutter run -d chrome
   ```
    - IOS:
   ```bash
   flutter run -d ios
   ```
    - Android:
   ```bash
   flutter run -d android
   ```

## How to Test
- Navigate between screens using the bottom navigation bar.
- On the Graph Screen, interact with the filter buttons to adjust the data range dynamically.
- Observe that both metrics and the graph update based on your selection.
