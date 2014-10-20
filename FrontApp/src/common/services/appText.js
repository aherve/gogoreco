angular.module( 'services.appText', [])

.run(['$rootScope', '$window', function($rootScope, $window){
  var language = $window.navigator.userLanguage || $window.navigator.language; 
  $rootScope.language = language;
}])

.filter( 'language', ['$rootScope', '$parse', function( $rootScope, $parse ){
  var language = $rootScope.language || 'en';
  var getLanguage = $parse( language );
  return function( input ){
    return getLanguage( input ) || $parse( 'en' )( input );
  };
}])

.factory('AppText', ['$filter', function( $filter ){
  var AppText = {
    translate: function( dict, key ){
      return $filter( 'language' )( dict[ key ] );
    }
  };

  return AppText;
}]);



