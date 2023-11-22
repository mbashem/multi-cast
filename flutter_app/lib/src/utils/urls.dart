// ignore: constant_identifier_names
import 'package:flutter/foundation.dart';

const baseURL = (kIsWeb ? "http://localhost:8080" : "http://10.0.2.2:8080");
const apiURL = "$baseURL/api";
const socketURL = (kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000");
