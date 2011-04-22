describe "Rwiki.Data.Page", ->
  node;
  data = {
    path: '/Home/Development/Dynamic languages/Ruby',
    htmlContent: 'html content',
    rawContent: 'raw content'
  }

  beforeEach ->
    node = new Rwiki.Data.Page(data);

  describe ":getPath", ->
    it "should return valid path", ->
      path = node.getPath();
      expect(path).toEqual('/Home/Development/Dynamic languages/Ruby')

  describe ":getParentPath", ->
    it "should return valid parent path", ->
      parentPath = node.getParentPath()
      expect(parentPath).toEqual('/Home/Development/Dynamic languages')

  describe ":getBaseName", ->
    it "should return valid base name", ->
      baseName = node.getBaseName()
      expect(baseName).toEqual("Ruby")

  describe ":getTitle", ->
    it "should return valid title", ->
      title = node.getTitle()
      expect(title).toEqual("Ruby")

