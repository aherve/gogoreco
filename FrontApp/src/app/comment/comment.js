angular.module('gogoreco.comment', [])

.directive('grComment', [function(){
  return {
    restrict: 'A',
    templateUrl: 'comment/comment.tpl.html',
    controller: 'CommentCtrl',
    scope: {
      comment: '='
    }
  };
}])

.controller('CommentCtrl', ['$scope', function( $scope ){
  if( $scope.comment.author ){
    if( !$scope.comment.author.image ){
      $scope.comment.author.image = 'assets/images/logo_silver_square.png';
    }
  }
}]);

