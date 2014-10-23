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

  $scope.resetSelectedItem = function(){
    $scope.selectedItem = null;
    $scope.mode = null;
  };

  $scope.getTypeahead = function( search ){
    return Item.typeahead( search, 15, [], $scope.activeSchool.id );
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
      current_user_score: 4
    };
  };

}]);

