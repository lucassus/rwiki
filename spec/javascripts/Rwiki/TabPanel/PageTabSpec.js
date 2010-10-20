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

  describe("relayed events", function() {
    var eventSource = new Ext.util.Observable();
    eventSource.addEvents('pageContentLoaded');

    xdescribe("on 'pageContentLoaded'", function() {
      beforeEach(function() {
        tab.relayEvents(eventSource, ['pageContentLoaded']);
        tab.setContent = jasmine.createSpy();
      });

      describe("with same page path", function() {
        it("should set content", function() {
          eventSource.fireEvent('pageContentLoaded', {
            path: pagePath,
            html: 'Some content'
          });

          expect(tab.setContent).toHaveBeenCalledWith('Some content');
        });
      });

      describe("with another page path", function() {
        it("should not set content", function() {
          eventSource.fireEvent('pageContentLoaded', {
            path: './another.txt',
            html: 'Some content'
          });

          expect(tab.setContent).not.toHaveBeenCalled();
        });
      });
    });
  });
});
