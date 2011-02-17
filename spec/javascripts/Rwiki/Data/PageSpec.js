describe("Rwiki.Data.Page", function() {
  var node;
  var data = {
    path: './Development/Dynamic languages/Ruby.txt',
    htmlContent: 'html content',
    rawContent: 'raw content'
  };

  beforeEach(function() {
    node = new Rwiki.Data.Page(data);
  });

  describe(":getPath", function() {
    it("should return valid path", function() {
      var path = node.getPath();
      expect(path).toEqual('./Development/Dynamic languages/Ruby.txt');
    });
  });

  describe(":getParentPath", function() {
    it("should return valid parent path", function() {
      var parentPath = node.getParentPath();
      expect(parentPath).toEqual('./Development/Dynamic languages');
    });
  });

  describe(":getBaseName", function() {
    it("should return valid base name", function() {
      var baseName = node.getBaseName();
      expect(baseName).toEqual("Ruby.txt");
    });
  });

  describe(":getTitle", function() {
    it("should return valid title", function() {
      var title = node.getTitle();
      expect(title).toEqual("Ruby");
    });
  });

});