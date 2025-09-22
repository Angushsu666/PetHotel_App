# CurlyBaby App (捲毛寶寶)

CurlyBaby is a mobile application designed to simplify the purchasing process for parents shopping for customized baby products. The app streamlines ordering, payment, and order management by integrating modern cloud-based tools and APIs.

## 🧩 Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/)
- **Backend**: [Python Flask](https://flask.palletsprojects.com/)
- **Database**: [Firebase Realtime Database](https://firebase.google.com/products/realtime-database)
- **Payment Gateway**: [ECPay](https://www.ecpay.com.tw/)

## 🚀 Features

- **Real-Time Order Tracking**: Firebase enables instant order status updates and inventory sync.
- **Secure Checkout Flow**: Integrated ECPay for seamless and trusted payment processing.
- **Admin Backend**: Flask backend supports order management, user authentication, and ECPay callbacks.
- **Cross-platform Mobile App**: Built with Flutter for consistent UI/UX across Android and iOS.

## 📦 Architecture Overview

```mermaid
graph TD;
    User -->|UI Interaction| FlutterApp
    FlutterApp -->|API Calls| FlaskBackend
    FlaskBackend -->|Read/Write| FirebaseDB
    FlaskBackend -->|Payment Request| ECPay
    ECPay -->|Callback| FlaskBackend
    FirebaseDB -->|Realtime Sync| FlutterApp

