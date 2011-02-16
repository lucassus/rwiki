describe("Rwiki.Tab.PageTab", function() {
  var tab;
  var pagePath = '/Home/Page';

  beforeEach(function() {
    tab = new Rwiki.TabPanel.PageTab();
    tab.setPagePath(pagePath);
  });
});
