angular.module( 'gogoreco.home', [])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'home', {
    url: '/home',
    views: {
      "main": {
        controller: 'HomeCtrl',
        templateUrl: 'home/home.tpl.html'
      }
    },
    data:{ pageTitle: 'Home' },
    resolve: {
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'HomeCtrl', ['$scope', 'Item', 'Analytics', function HomeController( $scope, Item, Analytics ) {

  Analytics.home();

  Item.latest_evaluated(50).then( function( response ){
    $scope.latestItems = response.items;
  });

}]);
