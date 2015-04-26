Jarviis.module("Issues.New", function(New, Jarviis, Backbone, Marionette, $, _){

  var URL_REGEX = /^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i;

  New.Upload = Marionette.ItemView.extend({
    template: "#new-upload",

    ui: {
      content: '.modal-content',
      minimized: '.modal-minimized'
    },

    events: {
      'click #close': 'exit',
      'click #minimize': 'minimize',
      'click #maximize': 'maximize',
      'click .upload': 'upload',
      'paste #url': 'paste',
      'drop #drop-zone': 'drop',
      'dragenter #drop-zone': 'highDropZone',
      'dragleave #drop-zone': 'unhighDropZone',
      'dragover #drop-zone': 'dragOver'
    },

    initialize: function () {
      this.collection = new Backbone.Collection();

      this.collection.on('all', this.renderList, this);
    },

    url: function () {
      var id = Backbone.history.fragment.split('/')[1];
      return '/api/v1/issues/' + id + '/attachments';
    },

    maximize: function () {
      this.ui.minimized.hide();
      this.ui.content.slideDown(100);
    },

    minimize: function () {
      var that = this;
      this.ui.content.slideUp(100, function () {
        that.ui.minimized.show();
      });
    },

    highDropZone: function (ev) {
      ev.preventDefault();
    },

    dragOver: function (ev) { ev.preventDefault(); },

    unhighDropZone: function(ev) {
      ev.preventDefault();
    },

    drop: function (ev) {
      var e = null,
          picture = null;

      ev.preventDefault();
      ev.stopPropagation();

      e = ev.originalEvent;
      e.dataTransfer.dropEffect = 'copy';

      _.each(e.dataTransfer.files, function(file) {
        this.addFiles({
          name: file.name,
          file: file,
          status: 'waiting'
        });
      }, this)
    },

    paste: function (ev) {
      var self = this;
      var $el = this.$(ev.currentTarget);

      setTimeout(function () {
        var url = $el.val();
        var file = _.last(url.split('/'));
        $el.val('');
        if (!URL_REGEX.test(url)){
          alertify.error('Please paste a valid URL.');
          return false;
        }
        self.addFiles({
          name: url,
          file: file,
          status: 'waiting',
          remote_image_url: true
        });
      }, 0);
    },

    addFiles: function (attributes) {
      this.collection.add(attributes);
    },

    upload: function () {
      var url = this.url();
      var collection = this.collection;

      if (collection.length) {
        collection.each(function (model) {
          var formData = new FormData();
          var name = model.get('name');
          var file = model.get('file');
          if (model.get('remote_image_url')) {
            formData.append('remote_image_url', name);
            formData.append('attachment[filename]', file);
          } else {
            formData.append('attachment[filename]', model.get('file'));
          }

          $.ajax({
            url: url,
            type: 'POST',
            contentType: false,
            processData: false,
            data: formData
          })
          .done(function (response) {
            collection.findWhere({name: name}).set({status: 'done'})
            Jarviis.execute('new:attachments');
          })
          .fail(function() {
            collection.findWhere({name: name}).set({status: 'error'})
          });
        }, this);

      } else {
        alertify.log("Please add a file to the upload queue.")
      }
    },

    renderList: function (model) {
      var template = _.template('<ul class="list-group"><% _.each(files, function (file) { %>' +
          '<li class="list-group-item"><span class="badge <% if(file.status==="done") { %>alert-success<% } %> pull-right"> ' +
          '<%- file.status %></span><%- file.name %></li><% }); %></ul>');

      var html = template({files: this.collection.toJSON()});

      $('#processed-files').html(html);
      this.$('.upload-files').show();
    },

    exit: function () {
      Jarviis.modalRegion.reset();
    }

  });
});

