Jarviis.Regions.Modal = Backbone.Marionette.Region.extend({
  el: "#modal",
  events: {
    'click .close': 'exit'
  },
  initialize: function () {
  },
  exit: function () {
    alert('lalal')
  },
  onShow: function() {
    this.$el.show();
  }
});
