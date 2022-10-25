import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

loadingAnimation() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/LoadingAnimation.json"),
  );
}

noDataFound() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/NoDataFound.json"),
  );
}

error404() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/Error404.json"),
  );
}

searchNotFound() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/SearchNotFound.json"),
  );
}

success() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/Success.json"),
  );
}
