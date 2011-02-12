describe("Rwiki.TabPanel", function() {
  var tabPanel;

  beforeEach(function() {
    var tabContent = $('<div />').attr('id', 'tabpanel-div');
    $('#jasmine_content').append(tabContent);

    tabPanel = new Rwiki.TabPanel({
      renderTo: 'tabpanel-div'
    });
  });

  afterEach(function() {
    $('#jasmine_content').empty();
  });

  describe(":findTabsByParentPath", function() {
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
          var page = new Rwiki.Data.Node({path: path});
          tabPanel.createPageTab(page);
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

  describe("onPageCreated handler", function() {
    var page = new Rwiki.Data.Node({
      path: './page.txt',
      text: 'page'
    });
    var tab = {};

    beforeEach(function() {
      var eventSource = new Ext.util.Observable();
      eventSource.addEvents('rwiki:pageCreated');

      tabPanel.relayEvents(eventSource, ['rwiki:pageCreated']);
      spyOn(tabPanel, 'createPageTab').andReturn(tab);
      tab.show = jasmine.createSpy('tab.show');

      eventSource.fireEvent('rwiki:pageCreated', page);
    });

    it("should create a new tab", function() {
      expect(tabPanel.createPageTab).toHaveBeenCalledWith(page);
    });

    it("should open a new tab", function() {
      expect(tab.show).toHaveBeenCalled();
    });
  });
});
