# Finans Mobil

This is a React Native mobile application providing a financial overview, including account balances and recent transactions.

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

- **Account Overview:** Displays a list of user accounts with their balances.
- **Transaction List:** Displays a paginated list of transactions for a selected account.
- **Pagination:** Allows loading more transactions with a "Load More" button.
- **Error Handling:** Displays user-friendly error messages for API failures.
- **State Management:** Uses Redux Toolkit for predictable state management.
- **API Integration:** Communicates with a backend API to fetch account and transaction data.

## API Endpoints (Assumed)

- `GET /api/v1/accounts`: Returns a list of user accounts with balances.
- `GET /api/v1/transactions?accountId={accountId}&limit={limit}&offset={offset}`: Returns a paginated list of transactions for a specific account.

## Data Types

typescript
interface Account {
  accountId: string;
  accountType: string;
  balance: number;
}

interface Transaction {
  transactionId: string;
  date: string;
  amount: number;
  description: string;
}
