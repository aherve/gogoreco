angular.module( 'gogoreco.contribute', [])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'contribute', {
    url: '/contribute',
    views: {
      "main": {
        controller: 'ContributeCtrl',
        templateUrl: 'contribute/contribute.tpl.html'
      }
    },
    data:{ pageTitle: 'Contribute' },
    resolve: {
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

.directive('grEvaluate', [function(){
  return {
    restrict: 'AE',
    controller: 'EvaluateItemCtrl',
    templateUrl: 'contribute/evaluateItem.tpl.html',
    scope: {
      item: '=grEvaluate',
      cb: '&'
    }
  };
}])

.controller('EvaluateItemCtrl', ['$scope', 'Item', 'Tag', '$rootScope', function( $scope, Item, Tag, $rootScope ){

  commentItem = function(){
    $scope.item.commentItem( $scope.item.comment );
  };

  $scope.getTagTypeahead = function( search ){
    return Tag.typeahead( search, $rootScope.school.id ).then( function( response ){
      return response.tags;
    });
  };

  $scope.addTag = function(){
    $scope.item.tags = $scope.item.tags ? $scope.item.tags : [];
    if( !!$scope.item.tagToAdd ){
      $scope.item.tags.push({
        name: $scope.item.tagToAdd 
      });
    }
    $scope.item.tagToAdd = null;
  };

  $scope.addTagsToItem = function(){
    var getNames = function( tags ){
      return tags.map( function( tag ){
        return tag.name;
      });
    };
    Item.addTagsById( getNames($scope.item.tags), $scope.item.id );
    $scope.cb();
  };

}])

/**
 * And of course we define a controller for our route.
 */
.controller( 'ContributeCtrl', ['$scope', 'Item', 'User', '$rootScope', 'School', function ContributeController( $scope, Item, User, $rootScope, School ){

  $scope.activeSchool = {};
  $scope.$rootScope = $rootScope;

  School.index().then( function( response ){
    $scope.schools = response.schools;
  });

  User.should_like().then( function( response ){
    $scope.shouldLike = response.items;
  });

  $scope.initialize = function(){
    $scope.selectedItem = null;
    $scope.itemToRecommend = null;
  };

  $scope.getTypeahead = function( search ){
    return $rootScope.school.id ? Item.typeahead( search, 15, [], $scope.activeSchool.id ).then( function( response ){
      return response.items;
    }) : [];
  };

  $scope.onItemSelect = function(){
    Item.get( $scope.selectedItem.id ).then( function( response ){
      $scope.itemToRecommend = response.item;
    });
  };

  $scope.selectTextItem = function(){
    Item.create([ $rootScope.school.name ], $scope.selectedItem, [], null, null).then( function( response ){
      $scope.itemToRecommend = response.item;
      if( response.item.schools.length ){
        $rootScope.school = response.item.schools[0];
      }
    });
  };
}]);

