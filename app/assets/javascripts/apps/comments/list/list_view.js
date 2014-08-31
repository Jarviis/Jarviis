Jarviis.module("Comments.List", function(List, Jarviis, Backbone, Marionette, $, _){
  List.Comment = Marionette.ItemView.extend({
    tagName: 'li',
    className: 'list-group-item',
    template: "#comment-template"
  });

  List.Comments = Marionette.CollectionView.extend({
    tagName: 'ul',
    className: 'list-group',
    itemView: List.Comment
  });
});
