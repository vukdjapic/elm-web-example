var Elm = require('../elm/Program.elm');
require('../css/users.css');

var elmApp = Elm.Program.embed(document.getElementById('elmDiv'), {baseUrl:'http://localhost:8008'});

elmApp.ports.registerUser.subscribe(function(user){
  alert('Registering user ' + user.name + ' with id ' + user.id)
})
