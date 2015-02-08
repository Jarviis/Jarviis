Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){

  Entities.Issue = Backbone.Model.extend({
    urlRoot: '/api/'+apiVer+'/issues',

    parse: function(data) {
      data.status = Jarviis.states[data.state];
      return data;
    },

    resolve: function () {
      this.changeState('resolve');
    },

    open: function() {
      this.changeState('open');
    },

    close: function() {
      this.changeState('close');
    },

    changeState: function (action) {
      var url = '/api/'+apiVer+'/issues/'+this.get('id')+'/'+action,
          self = this;

      $.ajax({url: url, type: "POST"})
       .done(function (data) {
         if(!data.errors)
           self.set(data);
       });
    }
  });

  var API = {
    getIssuesEntity: function (data) {
      var issues = new Jarviis.Entities.IssueCollection(),
          defer = $.Deferred();

      issues.fetch({
        data: data,
        success: function(data){
          defer.resolve(data);
        },
        error: function(){
          defer.resolve(undefined);
        }
      });

      return defer.promise();
    }
  }

  Jarviis.reqres.setHandler("issues:entity", function (data) {
    return API.getIssuesEntity(data);
  });
});
