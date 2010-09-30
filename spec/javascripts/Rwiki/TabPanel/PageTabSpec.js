describe("Rwiki.TabPanel.PageTab", function() {
  var tab;
  var pagePath = './page.txt';

  beforeEach(function() {
    tab = new Rwiki.TabPanel.PageTab({
      id: pagePath
    });
  });

  describe(":getPagePath", function() {
    it("should return '" + pagePath + "'", function() {
      expect(tab.getPagePath()).toEqual(pagePath);
    });
  });

  describe(":setPagePath", function() {
    it("should set the page path", function() {
      tab.setPagePath("./anoter.txt");
      expect(tab.getPagePath()).toEqual("./anoter.txt");
    });
  });

  describe("relayed events", function() {
    var observable = new Ext.util.Observable();
    observable.addEvents('pageContentLoaded');

    describe("on 'pageContentLoaded'", function() {
      beforeEach(function() {
        tab.relayEvents(observable, ['pageContentLoaded']);
        tab.setContent = jasmine.createSpy();
      });

      describe("with same page path", function() {
        it("should set content", function() {
          observable.fireEvent('pageContentLoaded', {
            path: pagePath,
            html: 'Some content'
          });

          expect(tab.setContent).toHaveBeenCalledWith('Some content');
        });
      });

      describe("with another page path", function() {
        it("should not set content", function() {
          observable.fireEvent('pageContentLoaded', {
            path: './another.txt',
            html: 'Some content'
          });

          expect(tab.setContent).not.toHaveBeenCalled();
        });
      });
    });
  });
});
