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

.controller('RecoBarsCtrl', ['$scope', '$filter', function( $scope, $filter ){
  $scope.array = [0, 1, 2, 3, 4];
  $scope.score = function( val ){
    return $filter( 'normalizeScores' )( $scope.item )[ val ];
  };
}])

.filter('normalizeScores', [function(){

  var makeList = function( item ){
    return [
      item.haters_count,
      item.mehers_count,
      item.likers_count,
      item.lovers_count
    ];
  };

  var normalize = function( score, max ){
    return max < 6 ? score : Math.floor( 5 * score / max );
  };

  return function( item ){
    var max = Math.max( item.lovers_count, item.haters_count, item.mehers_count, item.likers_count );
    return makeList( item ).map( function( count ){
      return normalize( count, max );
    });
  };
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
.controller( 'RecommendationsCtrl', ['$scope', 'Item', function RecommendationsController( $scope, Item ) {
  Item.latest_evaluated().then( function( response ){
    $scope.items = response.items;
  });
}]);


