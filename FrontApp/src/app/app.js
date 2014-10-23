angular.module( 'gogoreco', [
  'templates-app',
  'templates-common',
  'restangular',
  'ui.router',
  'ngAnimate',
  'ui.bootstrap',
  'LocalStorageModule',
  'security',

  'gogoreco.header',
  'gogoreco.config',
  'gogoreco.welcome',
  'gogoreco.startpage',
  'gogoreco.contribute',
  'gogoreco.recommendations',
  'gogoreco.usersConfirmation',

  'services.analytics',
  'services.alerts',
  'services.appText',

  'resources.item',
  'resources.school',
  'resources.evaluation'
])

.config( ['$stateProvider', '$urlRouterProvider', function myAppConfig ( $stateProvider, $urlRouterProvider ) {
  $urlRouterProvider.otherwise( '/start' );
}])

.config( ['$locationProvider', function( $locationProvider ){
  $locationProvider.html5Mode(true);
}])

.run(['ENV', function( ENV ){
  try {
    mixpanel.init( ENV.mixpanel_id );
  }
  catch( err ){
    console.log( err );
  }
}])

.controller( 'AppCtrl', ['$scope', '$location', function AppCtrl ( $scope, $location ) {
  $scope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams){
    if ( angular.isDefined( toState.data.pageTitle ) ) {
      $scope.pageTitle = toState.data.pageTitle + ' | gogoreco' ;
    }
  });

  $scope.nav = function( path ){
    $location.path( path );
  };
}])

.config(['localStorageServiceProvider', function(localStorageServiceProvider){
    localStorageServiceProvider.setPrefix('gogoreco');
}])


.run(['localStorageService', '$window', '$rootScope', '$state', function( localStorageService, $window, $rootScope, $state ){
  if( localStorageService.get('back url')){
    var url = '#' + localStorageService.get('back url');
    localStorageService.remove('back url');
    $rootScope.$apply( function(){
      $window.location.assign(url);
      $state.reload();
    });
  }
}])

.config(['RestangularProvider', function(RestangularProvider) {
  var toType = function(obj) {
    return ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
  };

  RestangularProvider
  .setBaseUrl('/api/')
  .setRequestSuffix('/?format=json')
  .setDefaultHttpFields({
    withCredentials: true,
    cache: false
  })
  .setDefaultHeaders({ "Content-Type": "application/json" })
  .setDefaultHeaders({'Accept-Version': "v1"})

  .setFullRequestInterceptor(function(element, operation, route, url, headers, params, httpConfig) {

    headers['content-type'] = "application/json";

    // find arrays in requests and transform 'key' into 'key[]' so that rails can understand that the reuquets contains an array 
    angular.forEach( params, function(param, key){
      if (toType(param) == 'array'){
        var newParam = [];
        angular.forEach( param, function(value, key){
          newParam[key] = value;
        });
        params[ key + '[]' ] = newParam;
        delete params[ key ];
        newParam = null;
      }
    });

    return {
      element: element,
      params: params,
      headers: headers,
      httpConfig: httpConfig
    };
  });
}])

;

