module.exports = function(app) {
  function index(request, response) {
    response.render('index', { title: 'Express' });
  }

  return {
    index : index
  };
}