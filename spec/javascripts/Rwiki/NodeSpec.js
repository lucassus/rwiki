describe("Rwiki.Node", function() {
  var nodeManager;

  beforeEach(function() {
    nodeManager = new Rwiki.Node();
  });

  describe(":pageTitle method", function() {
    var itShouldReturnValidTitle = function(expected, path) {
      it("should return '" + expected + "' for '" + path + "'", function() {
        expect(nodeManager.pageTitle(path)).toEqual(expected);
      });
    }

    var values = [
      ['.', 'Home'],
      ['./foo.txt', 'foo'],
      ['./folder/test', 'test'],
      ['./sample test', 'sample test'],
      ['./foo/bar/yet another test.txt', 'yet another test']
    ];

    for(var i = 0; i < values.length; i++) {
      var path = values[i][0];
      var expected = values[i][1];
      
      itShouldReturnValidTitle(expected, path);
    }
  });

});
