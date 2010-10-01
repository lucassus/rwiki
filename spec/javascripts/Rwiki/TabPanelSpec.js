describe("Rwiki.TabPanel", function() {
  var tabPanel;

  beforeEach(function() {
    tabPanel = new Rwiki.TabPanel();
  });

  describe(":findTabsByParentPath method", function() {
    beforeEach(function() {
      var pages = [
      './foo/bar/test.txt',
      './foo/bar/test/test 1.txt',
      './foo/bar/test/test 2.txt',
      './foo/bar.txt',
      './foo/test',
      './foo/test/bar 1.txt',
      './foo/test/bar 2.txt',
      './foo/testbar.txt'
      ];

      for (var i = 0; i < pages.length; i++) {
        var path = pages[i];
        if (path.match(new RegExp('\.txt$'))) {
          tabPanel.createPageTab(path);
        }
      }

      this.addMatchers({
        toIncludeTabWithPath: function(path) {
          var tabs = this.actual;
          var result = false;
          for (var i = 0; i < tabs.length; i++) {
            if (tabs[i].getPagePath() == path) {
              result = true;
              break;
            }
          }

          return result;
        }
      });
    });

    it("should return valid tabs for './foo/bar'", function() {
      var tabs = tabPanel.findTabsByParentPath('./foo/bar');
      expect(tabs.length).toBe(3);
      expect(tabs).toIncludeTabWithPath('./foo/bar/test.txt');
      expect(tabs).toIncludeTabWithPath('./foo/bar/test/test 1.txt');
      expect(tabs).toIncludeTabWithPath('./foo/bar/test/test 2.txt');
    });
    
    it("should return valid tabs for './foo/test'", function() {
      var tabs = tabPanel.findTabsByParentPath('./foo/test');
      expect(tabs.length).toBe(2);
      expect(tabs).toIncludeTabWithPath('./foo/test/bar 1.txt');
      expect(tabs).toIncludeTabWithPath('./foo/test/bar 2.txt');
    });
  });

  describe("relayed events", function() {
    var observable = new Ext.util.Observable();
    observable.addEvents('pageCreated');
    
    describe("on 'pageCreated'", function() {
      var tab = {};
      
      beforeEach(function() {
        tabPanel.relayEvents(observable, ['pageCreated']);
        spyOn(tabPanel, 'createPageTab').andReturn(tab);
        tab.show = jasmine.createSpy('tab.show');

        observable.fireEvent('pageCreated', {
          path: './page.txt',
          text: 'page'
        });
      });

      it("should create a new tab", function() {
        expect(tabPanel.createPageTab).toHaveBeenCalledWith('./page.txt', 'page');
      });

      it("should open a new tab", function() {
        expect(tab.show).toHaveBeenCalled();
      });
    });
  });
});