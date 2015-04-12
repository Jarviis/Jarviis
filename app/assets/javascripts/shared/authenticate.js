$.ajaxSetup({
  beforeSend: function(xhr){
    xhr.setRequestHeader('Authorization', "Token token=" + getCookie("token"));
  }
});

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    var token;
    _.each(ca, function(c) {
      c = c.replace(/\s/g,'');
      if (c.indexOf(name) !== -1) {
        token = c.substring(name.length,c.length);
      }
    });

    if (token != undefined) {
      return token;
    } else {
      return undefined;
    }
}
