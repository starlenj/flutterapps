# Finans Mobil

This is a React Native mobile application providing a financial overview (account balances, recent transactions).

## Prerequisites

- Node.js
- npm or yarn
- React Native development environment (iOS or Android)

## Installation

1. Clone the repository:
   `git clone https://github.com/starlenj/flutterapps`
2. Navigate to the project directory:
   `cd flutterapps`
3. Install dependencies:
   `npm install` or `yarn install`

## Running the Application

- For iOS: `npx react-native run-ios`
- For Android: `npx react-native run-android`

## Features

- **Account Overview:** Displays a list of user accounts with balances.
- **Transaction List:** Displays a paginated list of transactions for a selected account.
- **API Integration:** Fetches data from a backend API (assumed endpoints).
- **State Management:** Uses Redux Toolkit for predictable state container.
- **Error Handling:** Implements global error handling to display user-friendly messages.

## API Endpoints (Assumed)

- `GET /api/v1/accounts`: Returns a list of user accounts with balances.
- `GET /api/v1/transactions?accountId={accountId}&limit={limit}&offset={offset}`: Returns a paginated list of transactions for a specific account.

## Dependencies

- React Native
- Redux Toolkit
- React Native Paper
- Axios