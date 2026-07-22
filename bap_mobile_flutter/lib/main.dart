// lib/main.dart — entry point. Boots the AuthGate, which dispatches
// between splash / login / change-password / existing BapApp (for
// learners) / web-admin notice (for admin/editor sessions).

import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';

void main() {
  runApp(const AuthGate());
}