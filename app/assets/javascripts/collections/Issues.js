Jarviis.Collections.Issues = Backbone.Collection.extend({
  model: Jarviis.Models.Issue,
  url: function() {
    return '/api/'+apiVer+'/issues'+(this.type ? '?'+this.type+'_username='+this.username : '')
  },
  initialize: function (options) {
    this.type = options.type;
    this.username = options.username;
  }
});
