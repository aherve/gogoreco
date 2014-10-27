angular.module( 'gogoreco.classes', [])

.directive('grRecoBars', [function(){
  return {
    restrict: 'A',
    templateUrl: 'classes/recoBars.tpl.html',
    controller: 'RecoBarsCtrl',
    scope: {
      item: '='
    }
  };
}])

.directive('grItem', [function(){
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
  $stateProvider.state( 'classes', {
    url: '/classes',
    views: {
      "main": {
        controller: 'ClassesCtrl',
        templateUrl: 'classes/classes.tpl.html'
      }
    },
    data:{ pageTitle: 'Classes' },
    resolve: {
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

.controller( 'ClassesCtrl', ['$scope', 'Item', '$rootScope', 'School', 'Tag', '$q', function ClassesController( $scope, Item, $rootScope, School, Tag, $q ) {

  $scope.$rootScope = $rootScope;
  School.typeahead( '', 100 ).then( function( response ){
    $scope.schools = response.schools;
  });

  $scope.refreshSchool = function(){
    $scope.items = null;
    Tag.popular( $rootScope.school.id, 30 ).then( function( response ){
      $scope.tagsSuggestions = response.tags;
    });
  };

  if( !!$rootScope.school && angular.isDefined( $rootScope.school.id )){
    $scope.refreshSchool();
  }
  else if ( $rootScope.school && !$rootScope.school.id ){
    $rootScope.school = null;
  }

  $scope.selectSchool = function( school ){
    $rootScope.school = school;
    $scope.refreshSchool();
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
    var itemsPromise = Item.typeahead( search, 10, [], [$rootScope.school.id] );
    var tagsPromise =  Tag.typeahead( search, $rootScope.school.id );

    return $q.all([itemsPromise, tagsPromise]).then( function( response ){
      if( response[0].items.length ){
        response[0].items[0].displayItemDivider = true;
      }
      angular.forEach( response[0].items, function( item ){
        item.type = 'item';
        result.push( item );
      });
      if( response[1].tags.length ){
        response[1].tags[0].displayTagsDivider = true;
      }
      angular.forEach( response[1].tags, function( tag ){
        tag.type = 'tag';
        result.push( tag );
      });
      return result;
    });

  };
}]);
