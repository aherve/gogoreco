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
}]);

