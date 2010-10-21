describe("Rwiki.TabPanel.PageTab", function() {
  var tab;
  var pagePath = './page.txt';

  beforeEach(function() {
    tab = new Rwiki.TabPanel.PageTab();
    tab.setPagePath(pagePath);
  });

  describe(":getPagePath method", function() {
    it("should return '" + pagePath + "'", function() {
      expect(tab.getPagePath()).toEqual(pagePath);
    });
  });

  describe(":setPagePath method", function() {
    it("should set the page path", function() {
      tab.setPagePath("./anoter.txt");
      expect(tab.getPagePath()).toEqual("./anoter.txt");
    });
  });
});
