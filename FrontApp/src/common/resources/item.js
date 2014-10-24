angular.module('resources.item', [
  'restangular'
])

.factory('Item', ['Restangular', function( Restangular ){

  /**
   * Defines some cool function for item
   **/

  var addTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customPOST( params, 'tags' );
  };

  var removeTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customDELETE( params, 'tags' );
  };

  var setTags = function( tag_names ){
    var item = this;
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', this.id).customPUT( params, 'tags' );
  };

  var commentItem = function( content ){
    var item = this;
    var params = {
      content: content,
      entities: {
        comment: {
          content: true,
          author: true,
          related_evaluation: true
        },
        user: {
          firstname: true,
          lastname: true,
          image: true
        }
      }

    };
    return Restangular.one('items', item.id).all('comments').customPOST( params, 'create' ).then( function( response ){
      item.current_user_commented = true;
      console.log( response.comment );
      item.currentUserComment = response.comment;
      return response;
    });
  };

  var evalItem = function( score ){
    var item = this;
    var params = {
      score: score
    };
    return Restangular.one('items', item.id).customPUT( params, 'evals' ).then( function( response ){
      item.current_user_score = score;
    });
  };

  /**
   * Extends the item model 
   **/

  var extendItem = function(item) {
    return angular.extend(item, {
      addTags: addTags,
      removeTags: removeTags,
      evalItem: evalItem,
      setTags: setTags,
      commentItem: commentItem
    });
  };

  Restangular.extendModel('items', function (item){
    return extendItem(item);
  });

  /**
   * Adds methods to Item object 
   **/

  var Item = Restangular.all('items');

  Item.typeahead = function( search, nmax, tag_ids, school_ids ){
    var params = {
      search: search,
      nmax: nmax,
      tag_ids: tag_ids,
      school_ids: school_ids,
      entities: {
        item: {
          name: true
        }
      }
    };
    return Restangular.all('items').customPOST( params, 'typeahead' ).then( function( response ){
      response.items = Restangular.restangularizeCollection( null, response.items, 'items');
      return response;
    });
  };

  Item.filter = function( search, nmax, tag_ids, school_ids ){
    var params = {
      search: search,
      nmax: nmax || 10,
      tag_ids: tag_ids,
      school_ids: school_ids,
      entities: {
        item: {
          "comments": true,
          "comments_count": true,
          "current_user_commented": false,
          "current_user_score": false,
          "id": true,
          "likers_count": true,
          "lovers_count": true,
          "haters_count": true,
          "mehers_count": true,
          "name": true,
          "tags": true
        },
        comment: {
          content: true,
          author: true
        },
        user: {
          firstname: true,
          lastname: true,
          image: true
        },
        tag: {
          name: true
        }
      }
    };
    return Restangular.all('items').customPOST( params, 'typeahead' );
  };

  Item.create = function( school_names, item_name, tag_names, eval_score, comment_content ){
    var params = {
      school_names: school_names,
      item_name: item_name,
      tag_names: tag_names,
      eval_score: eval_score,
      comment_content: comment_content,
      entities: {
        item: {
          "comments": true,
          "comments_count": true,
          "current_user_commented": true,
          "current_user_score": true,
          "id": true,
          "likers_count": true,
          "lovers_count": true,
          "haters_count": true,
          "mehers_count": true,
          "name": true,
          "tags": true
        }
      }
    };
    return Restangular.all('items').customPOST( params, 'create' ).then( function( response ){
      response.item = Restangular.restangularizeElement( null, response.item, 'items');
      return response;
    });
  };

  Item.get = function( id ){
    var params = {
      entities: {
        item: {
          "comments": true,
          "comments_count": true,
          "current_user_commented": true,
          "current_user_score": true,
          "id": true,
          "likers_count": true,
          "lovers_count": true,
          "haters_count": true,
          "mehers_count": true,
          "name": true,
          "tags": true
        },
        comment: {
          content: true,
          author: true
        },
        user: {
          firstname: true,
          lastname: true,
          image: true
        },
        tag: {
          name: true
        }
      }
    };
    return Restangular.one('items', id).customPOST( params ).then( function( response ){
      response.item = Restangular.restangularizeElement( null, response.item, 'items');
      return response;
    });
  };

  Item.addTagsById = function( tag_names, id ){
    var params = {
      tag_names: tag_names
    };
    return Restangular.one('items', id).customPOST( params, 'tags' );
  };


  Item.latest_evaluated = function( nmax ){
    var params = {
      entities: {
        nmax: nmax || 10,
        item: {
          "comments": true,
          "comments_count": true,
          "current_user_commented": false,
          "current_user_score": false,
          "id": true,
          "likers_count": true,
          "lovers_count": true,
          "haters_count": true,
          "mehers_count": true,
          "name": true,
          "tags": true
        },
        comment: {
          content: true
        },
        tag: {
          name: true
        }
      }
    };
    return Restangular.all( 'items' ).customPOST( params, 'latest_evaluated' );
  };

  return Item;
}]);
