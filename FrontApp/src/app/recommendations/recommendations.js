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

.controller( 'RecommendationsCtrl', ['$scope', 'Item', '$rootScope', 'School', 'Tag', function RecommendationsController( $scope, Item, $rootScope, School, Tag ) {

  $scope.$rootScope = $rootScope;
  School.typeahead( '', 100 ).then( function( response ){
    $scope.schools = response.schools;
  });

  Item.latest_evaluated(50).then( function( response ){
    $scope.items = response.items;
  });

  $scope.typeaheadSelect = function(){
    if( $scope.search.type == 'item' ){
      Item.get( $scope.search.id ).then( function( response ){
        $scope.items = [ response.item ];
      });
    }
    else if( $scope.search.type == 'tag' ){
      Item.filter( null, 50, [ $scope.search.id ], [$rootScope.school.id] ).then( function( response ){
        $scope.items = response.items;
      });
    }
  };

  $scope.getSearch = function( search ){
    var result = [];
    return Item.typeahead( search, 10, [], [] ).then( function( response ){
      angular.forEach( response.items, function( item ){
        item.type = 'item';
        result.push( item );
      });
      return Tag.typeahead( search, null ).then( function( response ){
        angular.forEach( response.tags, function( tag ){
          tag.type = 'tag';
          result.push( tag );
        });
        return result;
      });
    });
  };
}]);
