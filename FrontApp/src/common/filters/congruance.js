angular.module('filters.congruance', [])

.filter('congruance', [function(){
  return function( input, val, mod ){
    var out = [];

    angular.forEach( input, function( value, key ){
      if( key % mod == val ){
        out.push( value );
      }
    });

    return out;
  };
}]);
