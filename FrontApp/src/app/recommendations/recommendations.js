angular.module( 'gogoreco.recommendations', [])

.directive('grRecoBars', [function(){
  return {
    restrict: 'A',
    templateUrl: 'recommendations/recoBars.tpl.html',
    controller: 'RecoBarsCtrl',
    scope: {
      item: '='
    }
  };
}])

.controller('RecoBarsCtrl', ['$scope', function( $scope ){
}])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'recommendations', {
    url: '/recommendations',
    views: {
      "main": {
        controller: 'RecommendationsCtrl',
        templateUrl: 'recommendations/recommendations.tpl.html'
      }
    },
    data:{ pageTitle: 'Recommendations' },
    resolve: {
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'RecommendationsCtrl', ['$scope', function RecommendationsController( $scope ) {
}]);


