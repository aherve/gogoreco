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
  $scope.comment.author = $scope.comment.author ? $scope.comment.author : { 
    image: 'assets/images/logo_silver_square.png'
  };
}]);

