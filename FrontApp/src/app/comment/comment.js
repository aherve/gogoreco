angular.module('gogoreco.comment', [
  'resources.comment'
])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'comment', {
    url: '/comments/:commentId',
    views: {
      "main": {
        controller: 'CommentCtrl',
        templateUrl: 'comment/comment.tpl.html'
      }
    },
    data:{ pageTitle: 'Comment' },
    resolve: {
      comment: ['Comment', '$stateParams', function( Comment, $stateParams ){
        return Comment.get( $stateParams.commentId );
      }],
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  });
}])

.directive('grComment', [function(){
  return {
    restrict: 'A',
    templateUrl: 'comment/commentDirective.tpl.html',
    controller: 'CommentDirectiveCtrl',
    scope: {
      comment: '='
    }
  };
}])


.controller('CommentDirectiveCtrl', ['$scope', function( $scope ){
}])

.controller('CommentCtrl', ['$scope', 'comment', function( $scope, comment ){
  $scope.comment = comment.comment;
  console.log( $scope.comment );
}]);

