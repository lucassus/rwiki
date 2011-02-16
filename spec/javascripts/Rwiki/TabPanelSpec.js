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
      var paths = [
        '/Home/foo/bar/test',
        '/Home/foo/bar/test/test 1',
        '/Home/foo/bar/test/test 2',
        '/Home/foo/bar',
        '/Home/foo/test',
        '/Home/foo/test/bar 1',
        '/Home/foo/test/bar 2',
        '/Home/foo/testbar'
      ];

      for (var i = 0; i < paths.length; i++) {
        var path = paths[i];
        var page = new Rwiki.Data.Page({path: path});
        tabPanel.createPageTab(page);
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

    it("should return valid tabs for '/Home/foo/bar'", function() {
      var tabs = tabPanel.findTabsByParentPath('/Home/foo/bar');
      
      expect(tabs.length).toBe(3);
      expect(tabs).toIncludeTabWithPath('/Home/foo/bar/test');
      expect(tabs).toIncludeTabWithPath('/Home/foo/bar/test/test 1');
      expect(tabs).toIncludeTabWithPath('/Home/foo/bar/test/test 2');
    });
    
    it("should return valid tabs for '/Home/foo/test'", function() {
      var tabs = tabPanel.findTabsByParentPath('/Home/foo/test');
      
      expect(tabs.length).toBe(2);
      expect(tabs).toIncludeTabWithPath('/Home/foo/test/bar 1');
      expect(tabs).toIncludeTabWithPath('/Home/foo/test/bar 2');
    });
  });

  describe("onPageCreated handler", function() {
    var page = new Rwiki.Data.Page({
      path: '/Home/page',
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
