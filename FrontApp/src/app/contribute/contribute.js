angular.module( 'gogoreco.contribute', [
  'services.analytics',
  'resources.item'
])

.config(['securityAuthorizationProvider', '$stateProvider', function config( securityAuthorizationProvider, $stateProvider ) {
  $stateProvider.state( 'recommend item', {
    url: '/contribute/:itemId',
    views: {
      "main": {
        controller: 'EvaluateItemCtrl',
        templateUrl: 'contribute/evaluateItem.tpl.html'
      }
    },
    data:{ pageTitle: 'Recommander' },
    resolve: {
      item: ['Item', '$stateParams', function( Item, $stateParams ){
        return Item.get( $stateParams.itemId );
      }],
      authenticatedUser: securityAuthorizationProvider.requireAuthenticatedUser
    }
  }).state( 'contribute', {
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

.directive('grEvaluate', [function(){
  return {
    restrict: 'AE',
    controller: 'EvaluateItemCtrl',
    templateUrl: 'contribute/evaluateItem.tpl.html',
    scope: {
      item: '=grEvaluate',
      cb: '&'
    }
  };
}])

.controller('EvaluateItemCtrl', ['$scope', 'Item', 'Tag', '$rootScope', 'Analytics', 'item', '$timeout', 'Alerts', function( $scope, Item, Tag, $rootScope, Analytics, item, $timeout, Alerts ){

  $scope.item = item.item;

  if( $scope.item.current_user_score && $scope.item.current_user_commented  ){
    $scope.step = 3;
  }
  else if( $scope.item.current_user_score && !$scope.item.current_user_commented ){
    $scope.step = 2;
  }
  else {
    $scope.step = 1;
  }

  $scope.navToStep = function( step ){
    Alerts.clear();
    if( step == 2 ){
      if( !!$scope.item.current_user_score || !!$scope.item.current_user_commented ){
        $scope.step = 2;
      }
      else {
        Alerts.setAlert( 'warning', 'Choisis une recommandation avant d\'aller l\'expliquer');
      }
    }
    else {
      $scope.step = step;
    }
  };

  $scope.commentItem = function( item ){
    item.commentItem( item.comment ).then( function(){
      $scope.navToStep(3);
    }, function( err ){
      if( err.data.error == 'content is missing' ){
        Alerts.setAlert('warning', 'Explique ta recommandation dans le champ texte avant de valider !');
      }
    });
  };

  $scope.getTagTypeahead = function( search ){
    return Tag.typeahead( search, $rootScope.school.id ).then( function( response ){
      return response.tags;
    });
  };

  $scope.addTag = function(){
    $scope.item.tags = $scope.item.tags ? $scope.item.tags : [];
    if( !!$scope.item.tagToAdd ){
      $scope.item.tags.push({
        name: $scope.item.tagToAdd 
      });
    }
    $scope.item.tagToAdd = null;
  };

  $scope.addTagsToItem = function(){
    var getNames = function( tags ){
      return tags.map( function( tag ){
        return tag.name;
      });
    };
    if( $scope.item.tags.length > 0 ){
      Item.addTagsById( getNames($scope.item.tags), $scope.item.id );
      Analytics.tagItem( $scope.item );
      Alerts.setAlert('info', 'Ta recommandation a bien été prise en compte !');
      $scope.nav('/contribute');
    }
    else {
      Alerts.setAlert('warning', 'Ajoute des tags avant de terminer !');
    }
  };

  $scope.evalItem = function( item, score ){
    if( item.current_user_score == score ){
      if( !item.current_user_comments ){
        item.evalItem( 0 );
      }
      else {
        Alerts.setAlert('warning', 'Tu ne peux pas retirer une recommandation que tu as justifiée par un texte');
      }
    }
    else {
      item.evalItem( score ).then( function(){
        if( score == 1 ){
          item.placeholder = "Je ne recommande pas ce cours pour un profil comme le mien parce que ...";
        }
        else{
          item.placeholder = "Je recommande ce cours à ...";
        }
        $scope.navToStep(2);
      });
    }
  };
}])

.controller( 'ContributeCtrl', ['$scope', 'Item', 'User', '$rootScope', 'School', 'Analytics', 'Alerts', function ContributeController( $scope, Item, User, $rootScope, School, Analytics, Alerts ){

  $scope.activeSchool = {};
  $scope.$rootScope = $rootScope;

  School.index().then( function( response ){
    $scope.schools = response.schools;
  });

  User.should_like().then( function( response ){
    $scope.shouldLike = response.items;
  });

  $scope.initialize = function(){
    $scope.selectedItem = null;
    $scope.itemToRecommend = null;
  };

  $scope.getTypeahead = function( search ){
    return $rootScope.school.id ? Item.typeahead( search, 15, [], [$rootScope.school.id] ).then( function( response ){
      return response.items;
    }) : [];
  };

  $scope.onItemSelect = function(){
    Item.get( $scope.selectedItem.id ).then( function( response ){
      $scope.nav('/contribute/' + response.item.id );
    });
  };

  $scope.selectTextItem = function(){
    if( $scope.selectedItem ){
      Item.create([ $rootScope.school.name ], $scope.selectedItem, [], null, null).then( function( response ){
        $scope.nav('/contribute/' + response.item.id );
        if( response.item.schools.length ){
          $rootScope.school = response.item.schools[0];
        }
        Analytics.createItem( response.item );
      });
    }
  };

  Analytics.contribute();
}]);

