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
.controller( 'ContributeCtrl', ['$scope', 'Item', 'User', '$rootScope', function ContributeController( $scope, Item, User, $rootScope ){

  $scope.activeSchool = {};
  $scope.$rootScope = $rootScope;

  User.should_like().then( function( response ){
    $scope.shouldLike = response.items;
  });

  $scope.initialize = function(){
    $scope.selectedItem = null;
    $scope.itemToRecommend = null;
  };

  $scope.getTypeahead = function( search ){
    return Item.typeahead( search, 15, [], $scope.activeSchool.id ).then( function( response ){
      return response.items;
    });
  };

  $scope.onItemSelect = function(){
    Item.get( $scope.selectedItem.id ).then( function( response ){
      $scope.itemToRecommend = response.item;
    });
  };

  $scope.selectTextItem = function(){
    Item.create(['Dauphine'], $scope.selectedItem, [], null, null).then( function( response ){
      $scope.itemToRecommend = response.item;
    });
  };

  $scope.createItem = function(){
    Item.create( ['Dauphine'], $scope.itemToRecommend.name, [], $scope.itemToRecommend.current_user_eval, $scope.itemToRecommend.content ).then( function( response ){
      $scope.itemToRecommend = response.item;
      $scope.addTagsMode = true;
    });
  };


}]);

