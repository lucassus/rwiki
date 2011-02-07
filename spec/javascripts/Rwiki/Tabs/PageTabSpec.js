describe("Rwiki.Tab.PageTab", function() {
  var tab;
  var pagePath = './page.txt';

  beforeEach(function() {
    tab = new Rwiki.TabPanel.PageTab();
    tab.setPagePath(pagePath);
  });
});
