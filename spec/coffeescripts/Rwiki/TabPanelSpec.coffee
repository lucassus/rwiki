describe 'Rwiki.TabPanel', ->
  tabPanel = null

  beforeEach ->
    tabContent = $('<div />').attr('id', 'tabpanel-div')
    $('#jasmine_content').append(tabContent)

    tabPanel = new Rwiki.TabPanel(
      renderTo: 'tabpanel-div'
    )

  afterEach ->
    $('#jasmine_content').empty()

  describe ':findTabsByParentPath', ->
    beforeEach ->
      paths = [
        '/Home/foo/bar/test',
        '/Home/foo/bar/test/test 1',
        '/Home/foo/bar/test/test 2',
        '/Home/foo/bar',
        '/Home/foo/test',
        '/Home/foo/test/bar 1',
        '/Home/foo/test/bar 2',
        '/Home/foo/testbar'
      ]

      for path in paths
        page = new Rwiki.Data.Page(path: path)
        tabPanel.createPageTab(page)

    it "should return valid tabs for '/Home/foo/bar'", ->
      tabs = tabPanel.findTabsByParentPath('/Home/foo/bar')
      nthTabPagePath = (n) -> tabs[n].getPagePath()

      expect(tabs.length).toBe(4)
      expect(nthTabPagePath(0)).toBe('/Home/foo/bar/test')
      expect(nthTabPagePath(1)).toBe('/Home/foo/bar/test/test 1')
      expect(nthTabPagePath(2)).toBe('/Home/foo/bar/test/test 2')
      expect(nthTabPagePath(3)).toBe('/Home/foo/bar')

    it "should return valid tabs for '/Home/foo/test'", ->
      tabs = tabPanel.findTabsByParentPath('/Home/foo/test')
      nthTabPagePath = (n) -> tabs[n].getPagePath()

      expect(tabs.length).toBe(3)
      expect(nthTabPagePath(0)).toBe('/Home/foo/test')
      expect(nthTabPagePath(1)).toBe('/Home/foo/test/bar 1')
      expect(nthTabPagePath(2)).toBe('/Home/foo/test/bar 2')

  describe "onPageCreated handler", ->
    page = new Rwiki.Data.Page(
      path: '/Home/page',
      text: 'page'
    )
    tab = {}

    beforeEach ->
      eventSource = new Ext.util.Observable()
      eventSource.addEvents('rwiki:pageCreated')

      tabPanel.relayEvents(eventSource, ['rwiki:pageCreated'])
      spyOn(tabPanel, 'createPageTab').andReturn(tab)
      tab.show = jasmine.createSpy('tab.show')

      eventSource.fireEvent('rwiki:pageCreated', page)

    it "should create a new tab", ->
      expect(tabPanel.createPageTab).toHaveBeenCalledWith(page)

    it "should open a new tab", ->
      expect(tab.show).toHaveBeenCalled()

