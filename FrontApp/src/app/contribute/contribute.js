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

/**
 * And of course we define a controller for our route.
 */
.controller( 'ContributeCtrl', ['$scope', 'Item', function ContributeController( $scope, Item ) {

  $scope.activeSchool = {};
  $scope.mode = null;

  $scope.initialize = function(){
    $scope.selectedItem = null;
    $scope.itemToRecommend = null;
    $scope.mode = null;
  };

  $scope.getTypeahead = function( search ){
    return Item.typeahead( search, 15, [], $scope.activeSchool.id ).then( function( response ){
      return response.items;
    });
  };

  $scope.onItemSelect = function(){
    $scope.mode = "edit";
    Item.get( selectedItem.id ).then( function( response ){
      selectedItem = response;
    });
  };

  $scope.selectTextItem = function(){
    $scope.mode = "create";
    $scope.itemToRecommend = {
      name: $scope.selectedItem,
      current_user_eval: 4
    };
  };

  $scope.createItem = function(){
    Item.create( ['Dauphine'], $scope.itemToRecommend.name, [], $scope.itemToRecommend.current_user_eval, $scope.itemToRecommend.content ).then( function( response ){
      $scope.itemToRecommend = response.item;
      $scope.addTagsMode = true;
    });
  };

  $scope.addTag = function(){
    $scope.itemToRecommend.tags = $scope.itemToRecommend.tags ? $scope.itemToRecommend.tags : [];
    if( !!$scope.itemToRecommend.tagToAdd ){
      $scope.itemToRecommend.tags.push( $scope.itemToRecommend.tagToAdd );
    }
    $scope.itemToRecommend.tagToAdd = null;
  };

  $scope.addTagsToItem = function(){
    Item.addTagsById( $scope.itemToRecommend.tags, $scope.itemToRecommend.id );
    $scope.initialize();
  };

}]);

