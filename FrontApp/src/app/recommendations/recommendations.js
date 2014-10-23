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
    $scope.latestItems = response.items;
  });

  $scope.clearIfEmpty = function(){
    $scope.items = null;
  };

  $scope.onItemSelect = function( itemId ){
    Item.get( itemId ).then( function( response ){
      $scope.items = [ response.item ];
    });
  };

  $scope.onTagSelect = function( tagId ){
    Item.filter( null, 50, [ tagId ], [$rootScope.school.id] ).then( function( response ){
      $scope.items = response.items;
    });
  };

  $scope.typeaheadSelect = function(){
    if( $scope.search.type == 'item' ){
      $scope.onItemSelect( $scope.search.id );
    }
    else if( $scope.search.type == 'tag' ){
      $scope.onTagSelect( $scope.search.id );
    }
  };

  $scope.selectTag = function( tag ){
    $scope.search = tag;
    $scope.onTagSelect( tag.id );
  };

  $scope.getSearch = function( search ){
    var result = [];
    return Item.typeahead( search, 10, [], [] ).then( function( response ){
      if( response.items.length ){
        response.items[0].displayItemDivider = true;
      }
      angular.forEach( response.items, function( item ){
        item.type = 'item';
        result.push( item );
      });
      return Tag.typeahead( search, null ).then( function( response ){
        if( response.tags.length ){
          response.tags[0].displayTagsDivider = true;
        }
        angular.forEach( response.tags, function( tag ){
          tag.type = 'tag';
          result.push( tag );
        });
        return result;
      });
    });
  };
}]);
