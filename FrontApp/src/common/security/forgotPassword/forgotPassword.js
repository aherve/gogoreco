angular.module('security.forgotPassword', [])

.controller('ForgotPasswordFormController', ['$scope', 'security', function($scope, security ) {

  $scope.user = {};

  $scope.forgotPassword = function(){
    security.forgotPassword($scope.user.email);
  };

  $scope.cancelForgotPassword = function(){
    security.cancelForgotPassword();
  };

}]);

