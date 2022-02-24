import 'dart:convert';
import 'dart:io';

dynamic fixture(String fileName) => json.decode(File('test/fixtures/$fileName.json').readAsStringSync());