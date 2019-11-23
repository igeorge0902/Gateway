'use strict';

var moviesControllers = angular.module('ngRepeat', ['ngRoute']);

moviesControllers.controller('repeatController', function ($scope, $http, $route, $routeParams, $location) {
    $scope.$route = $route;
    $scope.$location = $location;
    $scope.$routeParams = $routeParams;

    // $scope.pagename = function() { return $location.path(); };
    // $scope.pagename = $route.current.$$route.name;

    $scope.movies = [];

    $http({
        method: 'GET',
        url: '/mbooks-1/rest/book/movies',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    }).
    success(function (data, status, headers, config) {

        $scope.movies = data.movies;

    }).
    error(function (data, status, headers, config) {

        $scope.errorMsg = data;
    });
});

moviesControllers.controller('ExampleController', function ($http, $scope, $routeParams, $location) {
    $scope.name = 'ExampleController';
    $scope.params = $routeParams;

    $scope.dates = [];

    $http({
        method: 'GET',
        url: '/mbooks-1/rest/book/dates/' + +$scope.params.venueId + '/' + +$scope.params.bookId,
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    }).
    success(function (data, status, headers, config) {

        $scope.dates = data.dates;

    }).
    error(function (data, status, headers, config) {

        $scope.errorMsg = data;
    });

});

moviesControllers.controller('BookController', function ($http, $scope, $routeParams, $location) {
    $scope.name = 'BookController';
    $scope.params = $routeParams;

    $scope.venues = [];

    $http({
        method: 'GET',
        url: '/mbooks-1/rest/book/venue/' + $scope.params.bookId,
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    }).
    success(function (data, status, headers, config) {

        $scope.venues = data.venues;

    });
});

moviesControllers.config(function ($routeProvider, $locationProvider) {
    $routeProvider
        .when('/mbooks-1/rest/book/venue/:bookId', {
            templateUrl: 'venues.html',
            controller: 'BookController',
            name: 'venues',
            resolve: {
                // I will cause a 1 second delay
                delay: function ($q, $timeout) {
                    var delay = $q.defer();
                    $timeout(delay.resolve, 1000);
                    return delay.promise;
                }
            }
        })
        .when('/mbooks-1/rest/book/dates/:venueId/:bookId', {
            templateUrl: 'dates.html',
            controller: 'ExampleController'
        });

    // configure html5 to get links working on jsfiddle
    $locationProvider.html5Mode(true);
});

angular.element(document.getElementsByTagName('head')).append(angular.element('<base href="' + window.location.pathname + '" />'));

